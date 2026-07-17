class AppstoreconnectMcp < Formula
  desc "App Store Connect MCP Server (Swift)"
  homepage "https://github.com/__OWNER__/appstoreconnect-mcp"
  url "__URL__"
  sha256 "__SHA256__"
  version "__VERSION__"

  depends_on :macos => :sequoia

  def install
    bin.install "appstoreconnect-mcp"
  end

  test do
    # Verify the binary is executable and outputs the diagnostic banner
    assert_match "App Store Connect MCP Diagnostic", shell_output("echo '' | #{bin}/appstoreconnect-mcp --test", 1)
  end
end
