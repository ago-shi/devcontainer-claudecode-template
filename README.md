# devcontainer-claudecode-template

Claude Code を使ったドキュメント駆動開発のための devcontainer テンプレートです。

## 概要

このテンプレートは以下を提供します：

- **devcontainer 設定**: Claude Code がすぐに使える開発コンテナ
- **CLAUDE.md**: Claude Code の行動ルールと開発プロセスの定義
- **スキル / コマンド / エージェント**: ドキュメント駆動ワークフローを支援する Claude Code 拡張

## 使い方

### 1. テンプレートを clone する

```bash
git clone https://github.com/<your-username>/devcontainer-claudecode-template.git <your-project>
cd <your-project>
```

### 2. VS Code で devcontainer を開く

VS Code で「Reopen in Container」を選択します。Claude Code が利用可能な環境が自動的に構築されます。

### 3. CLAUDE.md をカスタマイズする

テンプレートの CLAUDE.md には `TODO` コメントが含まれています。以下の箇所をプロジェクトに合わせて書き換えてください。

#### A1: 概要節

```markdown
## 概要
<!-- TODO: このリポジトリの目的・対象システムを記述する -->
```

プロジェクトの目的・対象システム・技術的前提を記述します。

#### A2: `docs/` のファイル構成

`docs/` テーブルはサンプル構成です。プロジェクトの性質（ウェブアプリ・CLI・インフラ等）に合わせてファイルを追加・削除してください。すべてのファイルを作成する必要はありません。

#### A3: スキルの追加

`作業の進め方` テーブルには、実装済みのスキル・コマンドのみを記載してください。存在しないスキルへの参照は Claude Code を混乱させます。独自スキルを追加した場合はテーブルに追記します。

#### B5: リント・型チェックコマンド

```markdown
- コード変更後は必ずリント・型チェックを実施する。
  <!-- TODO: プロジェクトに合わせてコマンドを記入する -->
```

使用する言語・ツールに合わせて具体的なコマンドを記入します（例: `npm run lint && npm run typecheck`、`make lint`）。

### 4. `.claude/memory/` の扱いを決める

`.claude/memory/` はセッション間の記憶をリポジトリで管理するディレクトリです。

#### B6: 公開リポジトリ・チーム利用時の注意

`.claude/memory/` の内容はコミット・push されます。以下の点に注意してください：

- 個人情報・認証情報・機密情報を記録しない
- **パブリックリポジトリで利用する場合**は `.gitignore` に追加することを推奨します：

```
# .gitignore
.claude/memory/
```

チームで共有する場合は、記録内容を事前に合意しておくことを推奨します。

## 含まれるファイル

```
.
├── .claude/
│   ├── agents/
│   │   └── doc-reviewer.md       # ドキュメント整合性レビュー用サブエージェント
│   ├── commands/
│   │   ├── resume.md             # /resume: 作業再開（メモリ読込）
│   │   ├── review-doc.md         # /review-doc: ドキュメントレビュー委譲
│   │   └── suspend.md            # /suspend: 作業中断（メモリ記録・commit&push）
│   ├── skills/
│   │   └── steering-workflow/
│   │       └── SKILL.md          # ドキュメント駆動ワークフローの手順定義
│   └── settings.json             # Claude Code 設定
├── .devcontainer/
│   ├── devcontainer.json         # devcontainer 設定
│   ├── devcontainer-lock.json    # 依存バージョンロック
│   └── post_create.sh            # コンテナ起動後の初期化スクリプト
├── .gitattributes
├── CLAUDE.md                     # Claude Code の行動ルール定義（要カスタマイズ）
└── README.md                     # このファイル
```

## 動作要件

- [Claude Code](https://claude.ai/code) （skills / agents / commands 機能を含むバージョン）
- [VS Code](https://code.visualstudio.com/) + [Dev Containers 拡張](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- Docker

## ライセンス

MIT
