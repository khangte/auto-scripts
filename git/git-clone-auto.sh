#!/bin/bash

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
