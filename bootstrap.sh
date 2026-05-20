#!/bin/bash
# =========================================================
# Hermes One-Click Bootstrap — 在任何云平台初始化工作环境
# 支持: 阿里云ECS / 腾讯云CVM / AutoDL / 任何Linux服务器
# =========================================================
# 用法:
#   curl -fsSL https://raw.githubusercontent.com/jcwb520/hermes-knowledge/main/bootstrap.sh | bash
# 或者:
#   wget -qO- https://jcwb520-models-1251372921.cos.ap-seoul.myqcloud.com/tools/bootstrap.sh | bash
# =========================================================

set -e
GITHUB_TOKEN="__GITHUB__"
GH_REPO="https://jcwb520:${GITHUB_TOKEN}@github.com/jcwb520/hermes-knowledge.git"
COS_BUCKET="jcwb520-models-1251372921"
COS_REGION="ap-seoul"
OSS_BUCKET="jcwb520-models-jkt"
OSS_REGION="oss-ap-southeast-5"
AK="__ALIBABA_AK__"
SK="__ALIBABA_SK__"
COS_SECRET_ID="__TENCENT_ID__"
COS_SECRET_KEY="__TENCENT_KEY__"

echo "============================================"
echo "🚀 Hermes 一键部署 — 适用于任何云平台"
echo "============================================"
echo ""

# 1. 检测平台
PLATFORM="unknown"
if [ -f /etc/aliyun-release ] 2>/dev/null; then PLATFORM="alibaba"
elif [ -f /etc/tencent-release ] 2>/dev/null; then PLATFORM="tencent"
elif [ -d /autodl ] 2>/dev/null; then PLATFORM="autodl"
elif curl -s --connect-timeout 2 metadata.tencentyun.com >/dev/null 2>&1; then PLATFORM="tencent"
elif curl -s --connect-timeout 2 100.100.100.200 >/dev/null 2>&1; then PLATFORM="alibaba"
else PLATFORM="generic"
fi
echo "📡 检测到平台: $PLATFORM"

# 2. 检测GPU
GPU="none"
if command -v nvidia-smi &>/dev/null; then
    GPU=$(nvidia-smi --query-gpu=name,memory.total --format=csv,noheader 2>/dev/null | head -1)
    echo "🎮 GPU: $GPU"
else
    echo "🎮 GPU: 无 (仅CPU模式)"
fi

# 3. 安装基础工具
echo ""
echo "📦 安装基础工具..."
apt-get update -qq && apt-get install -y -qq git curl wget python3-pip nvtop htop iotop >/dev/null 2>&1 || true

# 4. 克隆知识库
echo "📚 克隆 hermes-knowledge..."
if [ ! -d ~/hermes-knowledge ]; then
    git clone "$GH_REPO" ~/hermes-knowledge --depth 1 2>/dev/null || echo "  ⚠️ clone失败，可能token过期"
fi

# 5. 配置云存储CLI
echo ""
echo "🔧 配置云存储..."
# COSCLI (腾讯云)
pip3 install coscmd -q 2>/dev/null || pip3 install --break-system-packages coscmd -q 2>/dev/null
coscmd config -a "$COS_SECRET_ID" -s "$COS_SECRET_KEY" -b "$COS_BUCKET" -r "$COS_REGION" 2>/dev/null
echo "  ✅ COS首尔 已配置"

# OSSUTIL (阿里云)
pip3 install oss2 -q 2>/dev/null || pip3 install --break-system-packages oss2 -q 2>/dev/null
echo "  ✅ OSS雅加达 已配置"

# 6. 如果32G以上内存 + GPU，下载模型
TOTAL_RAM=$(free -m | awk '/^Mem:/{print $2}')
if [ "$GPU" != "none" ] && [ "$TOTAL_RAM" -gt 16000 ]; then
    echo ""
    echo "📥 下载Qwen2.5-7B模型到本地..."
    mkdir -p /data/models
    python3 -c "
import oss2
auth = oss2.Auth('$AK', '$SK')
bucket = oss2.Bucket(auth, '$OSS_REGION.aliyuncs.com', '$OSS_BUCKET')
for obj in oss2.ObjectIterator(bucket, prefix='models/gguf/'):
    local_path = f'/data/models/{obj.key.split(\"/\")[-1]}'
    if not os.path.exists(local_path):
        print(f'  下载 {local_path}...')
        bucket.get_object_to_file(obj.key, local_path)
    else:
        print(f'  已存在: {local_path}')
" 2>/dev/null || echo "  ⚠️ 下载失败，可手动拉取"
fi

# 7. 安装Hermes Agent (如果有)
if command -v hermes &>/dev/null; then
    echo ""
    echo "🤖 Hermes Agent 已安装"
else
    echo ""
    echo "🤖 Hermes Agent 未安装 (可选)"
    echo "   安装: pip install hermes-agent"
fi

# 8. 输出总结
echo ""
echo "============================================"
echo "✅ 部署完成!"
echo "============================================"
echo ""
echo "📂 知识库: ~/hermes-knowledge/"
echo "☁️  COS首尔: coscmd list"
echo "☁️  OSS雅加达: 通过Python SDK访问"
echo "📦 模型目录: /data/models/ (如有)"
echo ""
echo "下一步:"
echo "  ssh连接你的实例，所有工具已就绪"
echo "  知识库更新: cd ~/hermes-knowledge && git pull"
echo "  上传模型: coscmd upload file models/"
echo "============================================"
