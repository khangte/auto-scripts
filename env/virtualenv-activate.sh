#!/bin/bash

# 현재 쉘이 하위 셸인지 확인 (source로 실행된 경우 $0은 'bash', 아니면 파일명)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "
❗ 이 스크립트는 하위 셸에서 실행되고 있어 가상환경이 현재 셸에 적용되지 않습니다.
👉 반드시 아래와 같이 'source' 또는 '.' 명령으로 실행해야 합니다:

    source setup-virtualenv.sh
    . setup-virtualenv.sh

⛔ 종료합니다.
"
  exit 1
fi

# 가상환경 이름 설정
VENV_NAME="venv"

echo "🔍 virtualenv 설치 여부 확인 중..."
if ! command -v virtualenv &> /dev/null; then
    echo "❌ virtualenv가 설치되어 있지 않습니다. 설치를 진행합니다..."
    pip install virtualenv
else
    echo "✅ virtualenv가 이미 설치되어 있습니다."
fi

# 가상환경 생성
if [ ! -d "$VENV_NAME" ]; then
    echo "🛠️ '$VENV_NAME' 가상환경 생성 중..."
    virtualenv "$VENV_NAME"
else 
    echo "📁 '$VENV_NAME' 폴더가 이미 존재합니다."
fi

# 가상환경 활성화
echo "🚀 가상환경 활성화 시도 중..."

if [ -f "$VENV_NAME/bin/activate" ]; then
    source "$VENV_NAME/bin/activate"      # Linux/macOS
elif [ -f "$VENV_NAME/Scripts/activate" ]; then
    source "$VENV_NAME/Scripts/activate"  # Windows (Git Bash)
else
    echo "❗ activate 스크립트를 찾을 수 없습니다."
    return 1
fi

echo "✅ 가상환경이 활성화되었습니다. (현재: $VIRTUAL_ENV)"
echo ""