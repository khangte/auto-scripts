#!/bin/bash

# ✅ uv + Python 3.11 기반 가상환경 자동 설치 및 진입

echo "🔎 [INFO] uv 기반 가상환경 자동 설정 스크립트 실행 중..."

# 1. uv 설치 확인
if ! command -v uv &> /dev/null; then
    echo "⚠️ [WARN] uv가 설치되어 있지 않습니다. 설치를 시작합니다..."
    curl -Ls https://astral.sh/uv/install.sh | bash
    export PATH="$HOME/.cargo/bin:$PATH"  # uv 경로 추가 (필요시 .bashrc에 추가)
fi

# 2. .venv 존재 여부 확인
if [ ! -d ".venv" ]; then
    echo "📦 [SETUP] .venv이 없어 생성합니다 (Python 3.11 사용)..."
    uv venv --python 3.11 .venv
fi

# 3. 가상환경 진입
if [ -f ".venv/bin/activate" ]; then
    echo "✅ [ACTIVATE] .venv/bin/activate 진입"
    source .venv/bin/activate
elif [ -f ".venv/Scripts/activate" ]; then
    echo "✅ [ACTIVATE] .venv/Scripts/activate 진입"
    source .venv/Scripts/activate
else
    echo "❌ [ERROR] activate 파일이 존재하지 않습니다."
    exit 1
fi
