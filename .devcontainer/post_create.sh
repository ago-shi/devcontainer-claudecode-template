#!/bin/bash
set -e

sudo chown -R vscode:vscode /home/vscode/.claude

# glab (GitLab CLI) — GitLab リリース API から .deb を直接インストール
# （gh (GitHub CLI) は devcontainer.json の feature でインストールされる）
GLAB_TAG=$(curl -fsSL "https://gitlab.com/api/v4/projects/34675721/releases" \
  | python3 -c "import json,sys; print(json.load(sys.stdin)[0]['tag_name'])")
GLAB_VER="${GLAB_TAG#v}"
curl -fsSLo /tmp/glab.deb \
  "https://gitlab.com/gitlab-org/cli/-/releases/${GLAB_TAG}/downloads/glab_${GLAB_VER}_linux_amd64.deb"
sudo dpkg -i /tmp/glab.deb
rm /tmp/glab.deb

# pre-commit フック（プロジェクトで .pre-commit-config.yaml を用意し、pre-commit を導入した場合のみ）
if [ -f .pre-commit-config.yaml ] && command -v pre-commit >/dev/null 2>&1; then
  pre-commit install
fi
