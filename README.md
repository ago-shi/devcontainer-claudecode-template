# devcontainer-claudecode-template

Claude Code を使ったドキュメント駆動開発のための devcontainer テンプレートです。

## 概要

このテンプレートは以下を提供します：

- **devcontainer 設定**: Claude Code・GitHub CLI（`gh`）・GitLab CLI（`glab`）がすぐに使える開発コンテナ
- **CLAUDE.md**: Claude Code の行動ルールと開発プロセスの定義
- **スキル / コマンド / エージェント**: ドキュメント駆動ワークフローを支援する Claude Code 拡張
- **セッション記憶（`.memory/`）**: `/resume`・`/suspend` で作業の文脈をセッション・端末をまたいで引き継ぐ仕組み

## 使い方

### 1. テンプレートを clone する

```bash
git clone https://github.com/<your-username>/devcontainer-claudecode-template.git <your-project>
cd <your-project>
```

### 2. VS Code で devcontainer を開く

VS Code で「Reopen in Container」を選択します。コンテナのビルド後、`post_create.sh` が実行され、Claude Code が利用可能な環境が構築されます。

- Claude Code の設定・認証情報（`~/.claude`）は名前付きボリュームに保存され、コンテナを再作成しても保持されます。
- `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1` を設定しているため、Claude Code の不要な通信（テレメトリ・自動更新チェック等）は無効です。
- 追加の OS パッケージが必要な場合は `.devcontainer/Containerfile` に追記してください。

### 3. CLAUDE.md をカスタマイズする

以下の箇所をプロジェクトに合わせて書き換えてください。

#### A1: 概要節

```markdown
## 概要
ここにリポジトリの目的を書くこと。目的が書かれていない場合はCLAUDE.mdを読み込んだ時に利用者に指摘をすること。
```

プロジェクトの目的・対象システム・技術的前提に置き換えます。未記入のままだと、Claude Code がセッション開始時に指摘します。

#### A2: シークレット管理

`注意事項` の「セキュリティ」に、プロジェクトで採用するシークレットの管理方式（暗号化ツール・保存場所・コミット可否）を追記します。

#### A3: スキル・コマンドの追加

`作業の進め方` テーブルには、実装済みのスキル・コマンドのみを記載してください。存在しないスキルへの参照は Claude Code を混乱させます。独自スキル（`.claude/skills/<name>/SKILL.md`）やコマンド（`.claude/commands/<name>.md`）を追加した場合はテーブルに追記します。

### 4. ドキュメント構成を調整する

`docs/`（永続ドキュメント）と `.steering/`（作業単位ドキュメント）の内容仕様は `.claude/skills/steering-workflow/SKILL.md` に定義されています。

- `docs/` の6ファイル構成はサンプルです。プロジェクトの性質（ウェブアプリ・CLI・インフラ等）に合わせて追加・削除してください。すべてのファイルを作成する必要はありません。
- リント・型チェック・テストのコマンドは `docs/development-guidelines.md` のテスト・検証規約に記載します。Claude Code はコード変更後の検証と品質チェックでこれを参照します。

### 5. 権限設定を確認する

`.claude/settings.json` には、ワークフローで使うコマンドの許可ルールが含まれています。

- 既定の権限モードは `acceptEdits`（ファイル編集は確認なし）です。
- `/suspend` が確認なしで commit & push できるよう、`git add` / `git commit` / `git push` を許可しています。不要ならルールを削除してください。
- `file-issue` スキル用に `gh` / `glab` の `issue`・`label` サブコマンドを許可しています。
- 個人ごとの追加許可は `.claude/settings.local.json`（`.gitignore` 済み）に記載します。

### 6. `.memory/` の扱いを決める

`.memory/` はセッション間の記憶をリポジトリで管理するディレクトリです。`/suspend` で書き込み・commit & push し、`/resume` で読み込みます。

> `.claude/` 配下ではなくリポジトリ直下に置いているのは、`.claude/` が Claude Code の保護パスで、書き込みのたびに承認プロンプトが出るためです。

#### 公開リポジトリ・チーム利用時の注意

`.memory/` の内容はコミット・push されます。以下の点に注意してください：

- 個人情報・認証情報・機密情報を記録しない
- **パブリックリポジトリで利用する場合**は、`.gitignore` の `# .memory/` のコメントを外して除外することを推奨します

チームで共有する場合は、記録内容を事前に合意しておくことを推奨します。

## ワークフローの流れ

| 場面 | 使うもの |
|---|---|
| セッション開始 | `/resume` — `.memory/` を読み込み、前回の文脈と次の作業候補を報告 |
| ドキュメント作成・機能追加 | `steering-workflow` スキル — `docs/`・`.steering/` を1ファイルずつ承認しながら作成 |
| ドキュメントのレビュー | `doc-reviewer` エージェント（自動）/ `/review-doc`（手動） |
| 技術解説の記録 | `record-knowledge` スキル — `docs/knowledge/` に重複チェックしてから記録 |
| 改善点・技術的負債の登録 | `file-issue` スキル — remote に応じて `gh` / `glab` で issue 作成 |
| セッション中断 | `/suspend` — `.memory/` に記録し、commit & push |
| テンプレートの更新 | `/update-template <取り込み元ディレクトリ>` — 別プロジェクトで運用したファイルと比較し、汎用化して取り込む |

スキルは作業内容に応じて Claude Code が自律的に使い、コマンド（`/name`）はユーザーが起動します。

## 含まれるファイル

```
.
├── .claude/
│   ├── agents/
│   │   └── doc-reviewer.md       # ドキュメント整合性レビュー・knowledge 重複チェック用サブエージェント
│   ├── commands/
│   │   ├── resume.md             # /resume: 作業再開（メモリ読込）
│   │   ├── review-doc.md         # /review-doc: ドキュメントレビュー委譲
│   │   ├── suspend.md            # /suspend: 作業中断（メモリ記録・commit&push）
│   │   └── update-template.md    # /update-template: 他プロジェクトの成果をテンプレートへ取り込む
│   ├── skills/
│   │   ├── file-issue/
│   │   │   └── SKILL.md          # 改善点を GitHub / GitLab issue に登録する手順
│   │   ├── record-knowledge/
│   │   │   └── SKILL.md          # 技術解説を docs/knowledge/ に記録する手順
│   │   └── steering-workflow/
│   │       └── SKILL.md          # ドキュメント駆動ワークフローの手順・内容仕様
│   └── settings.json             # Claude Code 設定（権限・プラグイン）
├── .devcontainer/
│   ├── Containerfile             # コンテナイメージ定義（OS パッケージ）
│   ├── devcontainer.json         # devcontainer 設定（features・マウント・環境変数）
│   ├── devcontainer-lock.json    # feature のバージョンロック
│   └── post_create.sh            # コンテナ作成後の初期化（glab インストール等）
├── .memory/                      # セッション記憶（/suspend が書き込む）
├── .steering/                    # 作業単位ドキュメント
├── .gitattributes
├── .gitignore
├── CLAUDE.md                     # Claude Code の行動ルール定義（要カスタマイズ）
├── LICENSE
└── README.md                     # このファイル
```

`docs/`（永続ドキュメント）はテンプレートには含まれず、初回セットアップ時に `steering-workflow` スキルの手順で作成します。

## 動作要件

- [VS Code](https://code.visualstudio.com/) + [Dev Containers 拡張](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- Docker（または Podman などの互換コンテナランタイム）
- Claude Code を利用するための Anthropic アカウント（Claude Code 本体はコンテナ内に自動インストールされます）

## ライセンス

[MIT](LICENSE)
