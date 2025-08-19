# ================================
# Build image
# ================================
FROM swift:5.10-noble AS build

WORKDIR /build

# Resolve Swift package
COPY Package.* ./
RUN swift package resolve \
    $([ -f ./Package.resolved ] && echo "--force-resolved-versions" || true)

# 複製專案並編譯
COPY . .
RUN swift build -c release --static-swift-stdlib

# ================================
# Run image
# ================================
FROM ubuntu:noble

# 安裝 runtime 依賴（安裝 OpenJDK 17）
RUN apt-get update && apt-get install -y \
      ca-certificates \
      openjdk-17-jre-headless \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 複製可執行檔和 Resources
COPY --from=build /build/.build/release/App ./
COPY --from=build /build/Resources ./Resources

CMD ["./App"]
