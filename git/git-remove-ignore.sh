#!/bin/bash

set -e

read -p "Git에서 제거하고 .gitignore에 추가할 파일명을 입력하세요: " target_file

# 파일 존재 여부 확인
if [ ! -f "$target_file" ]; then
    echo "❌ 오류: '$target_file' 파일이 현재 디렉토리에 존재하지 않습니다."
    exit 1
fi

# .gitignore에 파일명이 없으면 추가
if ! grep -Fxq "$target_file" .gitignore; then
    echo "$target_file" >> .gitignore
    echo "[+] .gitignore에 '$target_file' 추가됨"
else
    echo "[✓] .gitignore에는 이미 '$target_file'이 포함되어 있음"
fi

# Git 추적에서 제거
if git ls-files --error-unmatch "$target_file" > /dev/null 2>&1; then
    git rm --cached "$target_file"
    echo "[+] Git에서 '$target_file' 제거됨"
else
    echo "[✓] Git은 이미 '$target_file'을 추적하지 않음"
fi

# 커밋
git add .gitignore
git commit -m "Remove $target_file from Git and add to .gitignore"
echo "[✓] 커밋 완료됨"

# 푸시 여부 선택
read -p "원격 리포지토리에 푸시하시겠습니까? (y/n): " answer
if [ "$answer" = "y" ]; then
    git push origin main
    echo "[✓] 원격 푸시 완료"
else
    echo "[i] 푸시는 생략됨"
fi
