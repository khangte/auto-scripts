import os

# 삭제할 파일 경로 (예: README.md)
file_to_delete = ""

# 파일 존재 여부 확인 후 삭제
if os.path.exists(file_to_delete):
    os.remove(file_to_delete)
    print(f"✅ 파일 삭제됨: {file_to_delete}")
else:
    print(f"❌ 파일이 존재하지 않음: {file_to_delete}")

# Git 명령어 실행
os.system(f"git rm {file_to_delete}")
os.system('git commit -m "delete: removed file from repo"')
os.system('git push origin main')  # 필요 시 main → 현재 브랜치로 변경
