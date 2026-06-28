---
description: 作業を中断する（ワークスペースのメモリに記録 → commit & push を承認不要で実行）
allowed-tools: Bash(git status:*), Bash(git add:*), Bash(git commit:*), Bash(git push:*), Bash(git checkout:*), Bash(git switch:*), Bash(git branch:*), Bash(git rev-parse:*), Bash(git symbolic-ref:*), Bash(git log:*), Bash(git diff:*), Read, Write, Edit
---

作業を中断します。以下を **ユーザーへの確認を挟まず自律的に** 実行してください。

## 1. ワークスペースのメモリに記録

CLAUDE.md「セッション記憶（Memory）」のルールに従い、今回の会話で生じた次の情報を
**リポジトリルート直下の `.claude/memory/`** に書き込む（`~/.claude/projects/...` には書かない）。

- 確定した決定事項・方針（`project` / decisions）
- ユーザーから受け取ったフィードバック・好み（`feedback`）
- 作業状況・次回の再開ポイント・未決論点（`project`）

手順:
1. `.claude/memory/MEMORY.md` を読み、既存の記憶ファイルを確認する。
2. 既存ファイルに該当があれば**更新**、無ければ新規作成（重複を作らない）。相対日付は絶対日付に変換する。
3. 新規ファイルを作った場合は `MEMORY.md` にインデックス行（`- [Title](file.md) — hook`）を1行追加する。
4. 書き込み先パスが `~/.claude` を含まないことを確認する。

## 2. commit & push（承認不要）

メモリ更新を含む作業ツリーの変更を commit & push する。

1. `git status --short` と現在ブランチ（`git rev-parse --abbrev-ref HEAD`）を確認する。
2. **デフォルトブランチ（main）にいる場合は先にブランチを切る**。
   作業内容に即した名前を付ける（例 `feature/<topic>` / `docs/<topic>` / `chore/wip-YYYYMMDD`）。
   既に feature ブランチ上ならそのまま使う。
3. 変更をステージ（`git add -A`）してコミットする。
   - メッセージはリポジトリの慣例（Conventional Commits・日本語）に合わせ、今回の作業を簡潔に要約する。
   - 末尾に必ず次のトレーラーを付ける:
     ```
     Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
     ```
4. `git push -u origin <ブランチ名>` でリモートへ push する。
5. 失敗時（push 拒否・コンフリクト等）は無理に上書きせず、状況をそのまま報告する。

## 3. 報告

- 記録／更新したメモリファイル
- 作成・使用したブランチ名、コミットハッシュ、push 結果（リモートURL / MR 作成リンクがあれば）

> 注意: machine-local な設定（例 `.claude/settings.local.json`）が変更に含まれる場合は、
> コミット対象に含めてよいか判断に迷えば、その旨を報告に明記する（独断で除外しない・含めない、を曖昧にしない）。
