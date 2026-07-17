#!/bin/bash

# App Store Connect MCP Server One-Click Installer
# Targets macOS 15+ 

set -e

# Output styling helper
INFO="\033[1;36m[INFO]\033[0m"
SUCCESS="\033[1;32m[SUCCESS]\033[0m"
ERROR="\033[1;31m[ERROR]\033[0m"
WARNING="\033[1;33m[WARNING]\033[0m"

echo -e "\033[1;35m=========================================================\033[0m"
echo -e "\033[1;35m     App Store Connect MCP Server - One-Click Installer  \033[0m"
echo -e "\033[1;35m=========================================================\033[0m"

# 1. Platform verification
OS="$(uname -s)"
if [ "$OS" != "Darwin" ]; then
    echo -e "${ERROR} This installer only supports macOS (Darwin). Current platform: ${OS}"
    exit 1
fi

# 2. Retrieve latest version
echo -e "${INFO} Checking latest release version from GitHub..."
REPO_OWNER="jihongboo"
REPO_NAME="appstoreconnect-mcp"
LATEST_RELEASE_JSON=$(curl -s "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest")

TAG_NAME=$(echo "$LATEST_RELEASE_JSON" | grep '"tag_name":' | sed -E 's/.*"tag_name":\s*"(.*)".*/\1/')

if [ -z "$TAG_NAME" ]; then
    echo -e "${WARNING} Could not retrieve latest release via API. Falling back to default download..."
    DOWNLOAD_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/latest/download/appstoreconnect-mcp.zip"
    TAG_NAME="latest"
else
    DOWNLOAD_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/download/${TAG_NAME}/appstoreconnect-mcp.zip"
    echo -e "${INFO} Found version: ${TAG_NAME}"
fi

# 3. Create temp workspace
TMP_DIR=$(mktemp -d -t appstoreconnect-mcp-XXXXXX)
ZIP_PATH="${TMP_DIR}/appstoreconnect-mcp.zip"
trap 'rm -rf "${TMP_DIR}"' EXIT

# 4. Download Release asset
echo -e "${INFO} Downloading ${DOWNLOAD_URL}..."
curl -L -f -o "$ZIP_PATH" "$DOWNLOAD_URL"

# 5. Extract asset
echo -e "${INFO} Extracting archive..."
unzip -q -o "$ZIP_PATH" -d "$TMP_DIR"

BINARY_SOURCE="${TMP_DIR}/appstoreconnect-mcp"
if [ ! -f "$BINARY_SOURCE" ]; then
    BINARY_SOURCE="${TMP_DIR}/MyTool"
    if [ ! -f "$BINARY_SOURCE" ]; then
        echo -e "${ERROR} Executable binary not found in the downloaded archive."
        exit 1
    fi
fi

# 6. Determine target installation path
INSTALL_DIR="/usr/local/bin"
TARGET_PATH="${INSTALL_DIR}/appstoreconnect-mcp"

echo -e "${INFO} Installing to ${TARGET_PATH}..."

if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${INFO} Directory ${INSTALL_DIR} does not exist. Creating..."
    if [ -w "/usr/local" ]; then
        mkdir -p "$INSTALL_DIR"
    else
        sudo mkdir -p "$INSTALL_DIR"
    fi
fi

if [ -w "$INSTALL_DIR" ]; then
    cp "$BINARY_SOURCE" "$TARGET_PATH"
    chmod +x "$TARGET_PATH"
else
    echo -e "${INFO} Root privileges required to write to ${INSTALL_DIR}. Prompting for sudo..."
    sudo cp "$BINARY_SOURCE" "$TARGET_PATH"
    sudo chmod +x "$TARGET_PATH"
fi

echo -e "\033[1;35m=========================================================\033[0m"
echo -e "${SUCCESS} Installation Completed Successfully!"
echo -e "Binary Installed: ${TARGET_PATH}"
echo -e "Installed Version: ${TAG_NAME}"
echo -e "\033[1;35m=========================================================\033[0m"

# -----------------------------------------------------------------
# Interactive MCP Host Configuration
# -----------------------------------------------------------------
echo -e "\nWould you like to automatically configure this MCP server for your local clients? (y/N)"
read -r -p "> " CONF_ANSWER

if [[ "$CONF_ANSWER" =~ ^[Yy]$ ]]; then
    # Prompt for environment variables (optional)
    echo -e "\nTo complete the configuration, you can optionally enter your App Store Connect credentials now."
    echo -e "If you press Enter to skip, placeholder values will be written instead.\n"

    read -r -p "1. APP_STORE_CONNECT_ISSUER_ID (UUID): " INPUT_ISSUER
    read -r -p "2. APP_STORE_CONNECT_PRIVATE_KEY_ID (10-char Key ID): " INPUT_KEY_ID
    read -r -p "3. APP_STORE_CONNECT_PRIVATE_KEY_PATH (Absolute path to .p8 file): " INPUT_KEY_PATH

    # Set default values if empty
    [ -z "$INPUT_ISSUER" ] && INPUT_ISSUER="Your_Issuer_ID_Here"
    [ -z "$INPUT_KEY_ID" ] && INPUT_KEY_ID="Your_Key_ID_Here"
    [ -z "$INPUT_KEY_PATH" ] && INPUT_KEY_PATH="/path/to/AuthKey_xxxx.p8"

    export INPUT_ISSUER
    export INPUT_KEY_ID
    export INPUT_KEY_PATH

    # If user provided custom credentials (not default placeholders), perform a diagnostic test
    if [[ "$INPUT_ISSUER" != "Your_Issuer_ID_Here" ]]; then
        echo -e "\n${INFO} Verifying credentials by running the built-in diagnostic test..."
        
        # Temp export variables under correct names for --test diagnostics
        export APP_STORE_CONNECT_ISSUER_ID="$INPUT_ISSUER"
        export APP_STORE_CONNECT_PRIVATE_KEY_ID="$INPUT_KEY_ID"
        export APP_STORE_CONNECT_PRIVATE_KEY_PATH="$INPUT_KEY_PATH"
        
        if ! "$TARGET_PATH" --test; then
            echo -e "\n${ERROR} App Store Connect API connection validation failed."
            echo -e "Would you still like to force-write these configuration files? (y/N)"
            read -r -p "> " FORCE_ANSWER
            if [[ ! "$FORCE_ANSWER" =~ ^[Yy]$ ]]; then
                echo -e "${INFO} Configuration cancelled. IDE settings files were not modified."
                exit 1
            fi
        else
            echo -e "\n${SUCCESS} Credentials and API connection verified successfully!"
        fi
    fi

    # Define configure target files
    CLAUDE_CONFIG="$HOME/Library/Application Support/Claude/mcp_config.json"
    WINDSURF_CONFIG="$HOME/.codeium/windsurf/mcp_config.json"

    # Merge logic helper using python (guaranteed to be on macOS)
    run_python_config() {
        local config_file="$1"
        local app_name="$2"
        local format_type="$3"
        echo -e "${INFO} Configuring ${app_name}..."

        python3 -c "
import json, os, sys

config_path = os.path.expanduser(sys.argv[1])
format_type = sys.argv[2]
os.makedirs(os.path.dirname(config_path), exist_ok=True)

if os.path.exists(config_path):
    try:
        with open(config_path, 'r') as f:
            data = json.load(f)
    except Exception:
        data = {}
else:
    data = {}

env_dict = {
    'APP_STORE_CONNECT_ISSUER_ID': os.environ.get('INPUT_ISSUER', ''),
    'APP_STORE_CONNECT_PRIVATE_KEY_ID': os.environ.get('INPUT_KEY_ID', ''),
    'APP_STORE_CONNECT_PRIVATE_KEY_PATH': os.environ.get('INPUT_KEY_PATH', '')
}

if format_type == 'zed':
    if 'mcp_servers' not in data:
        data['mcp_servers'] = {}
    data['mcp_servers']['appstoreconnect-mcp'] = {
        'path': 'appstoreconnect-mcp',
        'args': [],
        'env': env_dict
    }
else: # standard
    if 'mcpServers' not in data:
        data['mcpServers'] = {}
    data['mcpServers']['appstoreconnect-mcp'] = {
        'command': 'appstoreconnect-mcp',
        'args': [],
        'env': env_dict
    }

with open(config_path, 'w') as f:
    json.dump(data, f, indent=2)
" "$config_file" "$format_type"
        echo -e "${SUCCESS} Configured ${app_name} successfully at: ${config_file}"
    }

    # Configure Claude Desktop
    run_python_config "$CLAUDE_CONFIG" "Claude Desktop" "standard"

    # Configure Windsurf (Codex)
    if [ -d "$HOME/.codeium/windsurf" ] || [ -f "$WINDSURF_CONFIG" ]; then
        run_python_config "$WINDSURF_CONFIG" "Windsurf (Codex)" "standard"
    fi

    # Configure Cline (VS Code)
    CLINE_DIR="$HOME/Library/Application Support/Code/User/globalStorage/saoudrizwan.claude-dev/settings"
    CLINE_CONFIG="${CLINE_DIR}/cline_mcp_settings.json"
    if [ -d "$CLINE_DIR" ] || [ -f "$CLINE_CONFIG" ]; then
        run_python_config "$CLINE_CONFIG" "Cline" "standard"
    fi

    # Configure Roo Code (VS Code)
    ROO_DIR="$HOME/Library/Application Support/Code/User/globalStorage/rooveterinaryinc.roo-cline/settings"
    ROO_CONFIG="${ROO_DIR}/cline_mcp_settings.json"
    if [ -d "$ROO_DIR" ] || [ -f "$ROO_CONFIG" ]; then
        run_python_config "$ROO_CONFIG" "Roo Code" "standard"
    fi

    # Configure Zed
    ZED_DIR="$HOME/.config/zed"
    ZED_CONFIG="${ZED_DIR}/settings.json"
    if [ -d "$ZED_DIR" ] || [ -f "$ZED_CONFIG" ]; then
        run_python_config "$ZED_CONFIG" "Zed" "zed"
    fi
else
    echo -e "${INFO} Auto-configuration skipped."
fi

# -------------------------------------------------------------
# Diagnostics & Next Steps
# -------------------------------------------------------------
echo -e "\n\033[1;35m=========================================================\033[0m"
echo -e "                   IMPORTANT NEXT STEPS                  "
echo -e "\033[1;35m=========================================================\033[0m"

echo -e "\n\033[1;32mDiagnostics:\033[0m"
echo -e "To verify that your API credentials work, run:"
echo -e "  appstoreconnect-mcp --test\n"
