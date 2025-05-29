#!/bin/bash

: <<'END'
자동 GitHub 리포지토리 클론 스크립트

사용법:
  ./git-clone-ssh.sh

설정해야 할 변수:
  - REPO_SSH: 클론할 Git 리포지토리의 SSH 주소
  - TARGET_DIR: 리포지토리를 클론할 로컬 디렉토리 경로
  - GIT_EMAIL: GitHub 계정에 등록된 이메일 주소

기능:
  - SSH 키가 없을 경우 자동 생성 (expect 사용)
  - 공개 키 출력 (GitHub에 등록 필요)
  - SSH 연결 성공 시 자동으로 리포지토리 클론

주의:
  - 'expect' 명령어가 설치되어 있어야 함
  - GitHub에 공개 키를 등록한 뒤 30초 대기
END

REPO_SSH="git@github.com:khangte/.git"
TARGET_DIR=""
GIT_EMAIL="minhyuk00321@gmail.com"
SSH_KEY_PATH="$HOME/.ssh/id_ed25519"

function setup_ssh_key() {
    if [ -f "$SSH_KEY_PATH" ]; then
        echo "SSH 키가 이미 존재합니다: $SSH_KEY_PATH"
    else
        echo "SSH 키가 없어서 새로 생성합니다..."

        # 자동으로 "n" 입력해서 기존 파일 덮어쓰기 방지
        expect <<EOF
spawn ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY_PATH"
expect "Overwrite (y/n)?"
send "n\r"
expect eof
EOF
    fi

    eval "$(ssh-agent -s)"
    ssh-add "$SSH_KEY_PATH"

    echo ""
    echo "아래 공개키를 GitHub > Settings > SSH and GPG keys 에 등록하세요:"
    echo "────────────────────────────────────────────"
    cat "$SSH_KEY_PATH.pub"
    echo "────────────────────────────────────────────"

    echo ""
    echo "30초 동안 SSH 키 등록 시간을 드릴게요..."
    for i in {30..1}; do
        echo -ne "\rSSH 키 등록까지 남은 시간: ${i}초 "
        sleep 1
    done
    echo -e "\n시간이 끝났습니다!"
}

function try_github_connection() {
    ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"
}

function clone_repo() {
    echo "GitHub에서 리포지토리 클론 중..."
    if [ ! -d "$TARGET_DIR" ]; then
        git clone "$REPO_SSH"
    else
        echo "이미 클론되어 있음: $TARGET_DIR"
    fi
}

# 메인 실행
if try_github_connection; then
    echo "SSH 연결 성공!"
else
    echo "SSH 연결 실패! 키를 설정해야 합니다."
    setup_ssh_key
fi

# 최종 시도 및 클론
clone_repo
