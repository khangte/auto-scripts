#!/bin/bash

: <<'END'
📄 git-init-push.sh

🔧 역할:
- 현재 디렉토리를 Git 리포지토리로 초기화하고
- 지정한 GitHub 원격 저장소에 첫 커밋을 푸시합니다.

✅ 사용법:
  ./git-init-push.sh <GitHub_리포_URL> [브랜치명]

🔁 예시:
  ./git-init-push.sh https://github.com/kmh1234/my-repo.git main

📝 기능:
1. Git 초기화 및 브랜치명 설정 (기본: main)
2. .gitignore 파일 자동 생성
3. 파일 스테이징 및 첫 커밋 수행
4. 원격 저장소 등록 및 푸시

⚠️ 주의:
- 로컬에 Git이 설치되어 있어야 하며,
- GitHub 리포지토리는 미리 생성되어 있어야 합니다.
END

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
