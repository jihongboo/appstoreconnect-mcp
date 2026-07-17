# ==========================================
# Build Stage
# ==========================================
FROM swift:6.0 AS builder

# Set the working directory
WORKDIR /workspace

# Copy Package.swift first to leverage Docker cache
COPY Package.swift ./
COPY Package.resolved* ./

# Resolve dependencies
RUN swift package resolve

# Copy source files
COPY Sources ./Sources

# Build the executable in release mode
RUN swift build -c release

# ==========================================
# Run Stage
# ==========================================
FROM swift:6.0-slim

# Install CA certificates to enable HTTPS requests to App Store Connect API
RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy the compiled binary from the builder stage
COPY --from=builder /workspace/.build/release/appstoreconnect-mcp /usr/local/bin/appstoreconnect-mcp

# Set the entrypoint to the compiled binary
ENTRYPOINT ["/usr/local/bin/appstoreconnect-mcp"]
