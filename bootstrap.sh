#!/bin/bash
# =========================================================
# Hermes One-Click Bootstrap
# =========================================================
# 注意：敏感凭证已移出版本控制，请通过环境变量注入
# =========================================================

set -e

GITHUB_TOKEN="${GITHUB_TOKEN:-__SET_YOUR_GITHUB_TOKEN__}"
COS_SECRET_ID="${COS_SECRET_ID:-__SET_YOUR_COS_SECRET_ID__}"
COS_SECRET_KEY="${COS_SECRET_KEY:-__SET_YOUR_COS_SECRET_KEY__}"
ALIBABA_AK="${ALIBABA_AK:-__SET_YOUR_ALIBABA_AK__}"
ALIBABA_SK="${ALIBABA_SK:-__SET_YOUR_ALIBABA_SK__}"

GH_REPO="https://jcwb520:${GITHUB_TOKEN}@github.com/jcwb520/hermes-knowledge.git"
COS_BUCKET="jcwb520-models-1251372921"
COS_REGION="ap-seoul"
OSS_BUCKET="jcwb520-models-jkt"
OSS_REGION="oss-ap-southeast-5"

echo "============================================"
echo "Hermes One-Click Bootstrap"
echo "============================================"
echo ""
echo "Set env vars (GITHUB_TOKEN, ALIBABA_AK, etc.) to enable cloud services."
