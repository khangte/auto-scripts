#!/bin/bash

: <<'END'
📄 git-auto-commit.sh

🧾 설명:
- 현재 디렉토리의 모든 변경사항을 Git에 추가하고,
- 사용자로부터 커밋 메시지를 입력받아,
- 날짜(KST), 운영체제 정보와 함께 커밋한 후,
- 원격 저장소에 푸시합니다.

✅ 사용법:
  ./git-auto-commit.sh

📝 커밋 메시지 예시:
  작업 완료 | 2025-05-29 17:30:00 (KST) | Ubuntu 22.04.4 LTS

📦 기능 요약:
1. 커밋 메시지 입력 요청
2. 현재 시간 (한국 시간대) 자동 추가
3. OS 정보 자동 감지 (Linux/macOS/Windows 등)
4. `git add .`, `git commit`, `git push` 자동 실행

⚠️ 사전 조건:
- Git 초기화 및 원격 저장소 설정이 완료되어 있어야 함
- Git 로그인/토큰 인증 설정 필요
END

# 커밋 메시지 입력 받기
read -p "커밋 메시지를 입력하세요: " user_message

# 현재 시간 (KST)
current_time=$(TZ=Asia/Seoul date "+%Y-%m-%d %H:%M:%S")

# 운영체제 및 버전 감지
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/os-release ]; then
        # Ubuntu 또는 다른 리눅스 배포판 이름 추출
        . /etc/os-release
        os_type="$NAME $VERSION"
    else
        os_type="Linux (Unknown Version)"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    os_type="macOS $(sw_vers -productVersion)"
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # Windows Git Bash 또는 WSL일 가능성 있음
    if command -v systeminfo &> /dev/null; then
        win_version=$(systeminfo | grep -E "^OS Name|^OS Version" | tr '\n' ' ' | sed 's/^.*OS Name: //; s/ OS Version:/ \(/; s/$/\)/')
        os_type="Windows $win_version"
    else
        os_type="Windows (Version Unknown)"
    fi
else
    os_type="Unknown OS"
fi

# 커밋 메시지 구성
commit_message="$user_message | $current_time (KST) | $os_type"

# Git 명령어 실행
git add .
git commit -m "$commit_message"
git push