#!/bin/bash

set -e

echo "🚀 开始安装 t3rn Executor..."

# 创建目录
mkdir -p ~/t3rn && cd ~/t3rn

# 获取最新版本号
VERSION=$(curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
echo "📦 最新版本: $VERSION"

# 下载 Binary 文件
wget https://github.com/t3rn/executor-release/releases/download/${VERSION}/executor-linux-${VERSION}.tar.gz

# 解压
tar -xzf executor-linux-*.tar.gz

# 进入执行目录
cd executor/executor/bin

# 设置环境变量（你可以根据自己的实际信息修改）
echo "🔧 设置环境变量..."

cat <<EOF >> ~/.bashrc

# === t3rn Executor 环境变量 ===
export ENVIRONMENT=testnet
export LOG_LEVEL=debug
export LOG_PRETTY=false

export EXECUTOR_PROCESS_BIDS_ENABLED=true
export EXECUTOR_PROCESS_ORDERS_ENABLED=true
export EXECUTOR_PROCESS_CLAIMS_ENABLED=true

export EXECUTOR_MAX_L3_GAS_PRICE=100

# ⚠️ 请替换为你自己的私钥
export PRIVATE_KEY_LOCAL=dead93c715fdd31c61141abd04a99fd6822c8558854ccde39a5684e7a56dbeef

export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,l2rn'

export RPC_ENDPOINTS='{
    "l2rn": ["https://b2n.rpc.caldera.xyz/http"],
    "arbt": ["https://arbitrum-sepolia.drpc.org", "https://sepolia-rollup.arbitrum.io/rpc"],
    "bast": ["https://base-sepolia-rpc.publicnode.com", "https://base-sepolia.drpc.org"],
    "opst": ["https://sepolia.optimism.io", "https://optimism-sepolia.drpc.org"],
    "unit": ["https://unichain-sepolia.drpc.org", "https://sepolia.unichain.org"]
}'

export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=true
# === t3rn Executor 环境变量 END ===
EOF

# 应用环境变量
source ~/.bashrc

# 可选安装 screen 工具
sudo apt update && sudo apt install screen -y

echo "✅ 安装完成！你可以使用以下命令启动 Executor："
echo ""
echo "cd ~/t3rn/executor/executor/bin"
echo "./executor"
echo ""
echo "💡 推荐在 screen 中运行："
echo "screen -S t3rn-executor"
echo "./executor"
echo "(Ctrl+A+D 可后台运行，screen -r t3rn-executor 可重新连接)"
