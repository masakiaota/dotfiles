---
name: commit-message
description: Generate descriptive Japanese commit messages by analyzing git diffs with Conventional Commits. Use when the user asks for help writing commit messages, reviewing staged changes, or preparing a commit command.
---

# コミットメッセージ生成

git diffを分析して、Conventional Commits準拠の日本語コミットメッセージを生成する。

## ワークフロー

### ステップ1: 変更内容を確認

```bash
git status
git diff --cached  # ステージング済み
# または
git diff           # ステージング前
```

### ステップ2: 変更を分析

以下の観点から評価：

- **変更の種類**: 新機能、バグ修正、リファクタリング、ドキュメント等
- **変更の範囲**: 影響するモジュール/コンポーネント
- **変更の意図**: 何を解決しようとしているか

### ステップ3: コミットメッセージを生成

以下の形式で日本語のコミットメッセージを作成：

```
<type>: <subject>

<body>
```

- **1行目**: 50文字以内で変更の要約
- **2行目**: 空行
- **3行目以降**: 必要に応じて詳細な説明

### ステップ4: commit 実行（必要なら push も）

ユーザーが commit を明示的に依頼した場合、commit を実行：

```bash
git commit -m "$(cat <<'EOF'
<生成したコミットメッセージ>
EOF
)"
```

`git push` をユーザーが依頼している場合はそれも実行する。

## タイプ一覧


| タイプ         | 用途                      |
| ----------- | ----------------------- |
| `feat:`     | 新機能追加                   |
| `fix:`      | バグ修正                    |
| `refactor:` | リファクタリング（機能に影響しないコード改善） |
| `chore:`    | 雑務・メンテナンス（依存関係更新、設定変更等） |
| `docs:`     | ドキュメント更新                |
| `test:`     | テスト追加・修正                |
| `perf:`     | パフォーマンス改善               |
| `security:` | セキュリティ修正                |
| `style:`    | コードフォーマット（機能に影響しない変更）   |


## メッセージ作成のガイドライン

- 具体的で分かりやすい表現を使用
- 「何を」「なぜ」を明確にする
- 技術的な詳細は必要に応じてbody部分に記載

## 例

詳細な例は[examples.md](examples.md)を参照。
