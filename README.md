# App Store Connect MCP Server (Swift)

这是一个基于 Swift 语言与 [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi) 开发的 Model Context Protocol (MCP) 服务端程序。

通过此 MCP 服务，AI 助手（如 Claude、Gemini 等）可以直接在编辑器内为您查询和管理 App Store Connect 后台的各类 resources，包括 App 详情、构建版本、TestFlight 测试、本地化文本（副标题、描述、关键词等）、用户评价回复以及团队成员管理，极大提升开发与发布自动化体验。

如需查看 App Store Connect API 的完整能力范围以及当前 MCP 工具的覆盖进度，请参阅我们的 [项目路线图 (ROADMAP.md)](./ROADMAP.md)。

---

## 🚀 核心功能与 MCP 工具

本服务通过 MCP 暴露了以下 20 个核心 API 能力工具：

### 1. App 详情与版本管理
*   `list_apps`: 列出您账号下的所有 App 列表。
*   `get_app_details`: 获取特定 App 的详细信息（如 ID、Bundle ID 等）。
*   `list_app_store_versions`: 列出指定 App 的所有 App Store 版本（如 1.0、2.0）。
*   `create_app_store_version`: 为 App 创建新的 App Store 待提交版本（如新建 1.0 版本）。

### 2. App 本地化元数据 (Subtitle, Description, Keywords)
*   `list_app_infos`: 获取 App 基础属性实体（包含主分类、副分类等）。
*   `list_app_info_localizations`: 列出 App 基础属性在不同语言下的本地化对象。
*   `update_app_info_localizations`: 修改 App 副标题 (Subtitle) 或隐私政策 URL。
*   `list_app_store_version_localizations`: 列出特定 App Store 版本在不同语言下的本地化信息。
*   `update_app_store_version_localizations`: 修改新版本的本地化数据（包含 **Description（新版本描述）**、**Keywords（搜索关键词）**、**Promotional Text（促销文本）**）。

### 3. 构建包 (Builds) 与 TestFlight 管理
*   `list_builds`: 列出指定 App 或版本上传上来的所有 IPA 构建包。
*   `get_latest_build_info`: 获取特定 App 版本的最新构建包属性及状态。
*   `list_beta_groups`: 获取 App 在 TestFlight 上的所有测试人员群组。
*   `create_beta_group`: 在 TestFlight 后台自动创建一个新的测试群组。
*   `list_beta_testers`: 列出特定测试群组内绑定的所有 Beta 测试员。
*   `add_beta_tester_to_group`: 将已有的测试人员添加进 TestFlight 的测试群组中。

### 4. 类别查询与修改
*   `list_app_categories`: 列出 App Store 支持的官方分类 ID（如 `NEWS`、`UTILITIES`、`BUSINESS` 等）。
*   `update_app_info`: 更新 App 的核心属性，例如修改其主分类（Primary Category）。

### 5. 用户评价与互动 (Customer Reviews)
*   `list_customer_reviews`: 获取指定 App 的用户评分与真实评价（支持 limit 限制）。
*   `submit_customer_review_reply`: 向特定的用户评价提交或修改开发者的官方答复。

### 6. 开发者团队管理 (Users & Roles)
*   `list_users`: 列出您开发者账号下的所有协作成员信息及其角色（如 ADMIN, ACCOUNT_HOLDER 等）。

---

## 🛠️ 编译与安装

本服务端是一个原生 Swift 命令行程序。您可以使用 `xcodebuild` 在本地完成编译：

```bash
# 进入工程目录
cd /Users/jihongbo/Developer/appstoreconnect-mcp

# 执行 Debug 编译
xcodebuild -project appstoreconnect-mcp.xcodeproj -scheme MyTool -configuration Debug
```

编译生成的二进制文件路径为：
`/Users/jihongbo/Library/Developer/Xcode/DerivedData/appstoreconnect-mcp-dzybcwfrwbweqicopheydixfpeol/Build/Products/Debug/MyTool`

---

## ⚙️ MCP 宿主配置说明

将以下配置项追加至您的全局 MCP 配置文件中（通常位于 `/Users/jihongbo/.gemini/config/mcp_config.json` 或 `/Users/yourusername/.codeium/config.json` 等位置）：

```json
{
  "mcpServers": {
    "appstoreconnect-mcp": {
      "command": "/Users/jihongbo/Library/Developer/Xcode/DerivedData/appstoreconnect-mcp-dzybcwfrwbweqicopheydixfpeol/Build/Products/Debug/MyTool",
      "args": [],
      "env": {
        "APP_STORE_CONNECT_ISSUER_ID": "你的Issuer_ID_Ex_4f70c262-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
        "APP_STORE_CONNECT_PRIVATE_KEY_ID": "你的Key_ID_Ex_TKY25M6624",
        "APP_STORE_CONNECT_PRIVATE_KEY_PATH": "/Users/yourusername/Downloads/AuthKey_TKY25M6624.p8"
      }
    }
  }
}
```

### 🔑 环境变量参数：
1.  `APP_STORE_CONNECT_ISSUER_ID`: 苹果 API 密钥页面顶部的 Issuer ID。
2.  `APP_STORE_CONNECT_PRIVATE_KEY_ID`: 密钥文件的 Key ID。
3.  `APP_STORE_CONNECT_PRIVATE_KEY_PATH`: 苹果后台生成的 `.p8` 私钥文件的**绝对路径**。

---

## 💻 调试与命令行测试

您也可以直接通过终端运行该二进制来进行单点诊断，传入 `--test` 参数将自动检查您的 API 连接与凭证可用性：

```bash
/Users/jihongbo/Library/Developer/Xcode/DerivedData/appstoreconnect-mcp-dzybcwfrwbweqicopheydixfpeol/Build/Products/Debug/MyTool --test
```
