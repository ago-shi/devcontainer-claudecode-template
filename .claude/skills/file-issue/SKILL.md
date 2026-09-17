---
name: file-issue
description: 作業中に見つけた「今すぐ対応しないが将来対応すべき推奨事項・改善点・技術的負債」を GitHub / GitLab の issue として登録するときに使う。remote に応じた gh / glab CLI での起票手順・本文テンプレート・重複確認・ラベルの注意を含む。
---

作業中に見つけた「今すぐ対応しないが将来対応すべき推奨事項・改善点・技術的負債」は、
**リモートリポジトリ（GitHub / GitLab）の issue として登録する**。ローカルのメモやコミットメッセージに
埋もれさせず、チームで追跡可能な場所に残す。

## 使用する CLI の判定

`git remote get-url origin` のホストで判定する。

| ホスト | CLI |
|---|---|
| `github.com`（または GitHub Enterprise） | `gh` |
| `gitlab.com`（またはセルフホスト GitLab） | `glab` |

判定できない場合はユーザーに確認する。

## 手順

1. 改善点を見つけたら、会話の中でユーザーに登録要否を確認する（例:「この改善点を issue に残しますか？」）。
2. 既存の同種 issue がないか確認し、重複を避ける（`gh issue list` / `glab issue list`）。
3. 登録する場合は判定した CLI で作成する：
   ```bash
   # GitHub
   gh issue create --title "<簡潔なタイトル>" --body "<本文>"
   # GitLab
   glab issue create --title "<簡潔なタイトル>" --description "<本文>"
   ```
4. 本文には最低限、次を含める：
   - **概要**（何が問題か）
   - **影響**（放置した場合のリスク・不便）
   - **対応案**（取りうる選択肢。推奨があれば明示）
   - **参考**（関連ファイル・ドキュメントへのパス）
5. 作成後、issue の URL をユーザーに伝える。

## 注意

- CLI の認証が必要。未認証（`gh auth status` / `glab auth status` で確認）なら `gh auth login` / `glab auth login` をユーザーに依頼する。
- ラベルはプロジェクトに定義済みのもののみ使用する（未定義のラベルは付けない／必要なら作成を相談する）。
  - 一覧は `gh label list` / `glab label list` で確認し、付与は `--label "<ラベル>"` で行う。
  - プロジェクト固有のラベル体系（例: 優先度・種別）があれば、ここに追記して運用を明示する。
