#!/bin/bash

# 사용 예: ./git-init-push.sh <GitHub_리포_URL> <브랜치명>
# 예시: ./git-init-push.sh https://github.com/kmh1234/my-repo.git main

# 인자 체크
if [ $# -lt 1 ]; then
  echo "❗ 사용법: $0 <GitHub_리포_URL> [브랜치명]"
  exit 1
fi

REPO_URL=$1
BRANCH_NAME=${2:-main}

# 1. Git 초기화
git init

# 2. 브랜치 이름 변경 (기본: main)
git branch -m $BRANCH_NAME

# 3. 원격 저장소 등록
git remote add origin "$REPO_URL"

# 4. 기본 .gitignore 생성 (옵션)
echo -e "# 기본 Git 무시 파일\n__pycache__/\n*.pyc\n.env\n*.sqlite3\n*.log\n" > .gitignore

# 5. 모든 변경사항 스테이지에 추가
git add .

# 6. 첫 커밋
git commit -m "Initial commit"

# 7. 원격 저장소로 푸시
git push -u origin "$BRANCH_NAME"

echo "✅ Git 초기화 및 푸시 완료!"
