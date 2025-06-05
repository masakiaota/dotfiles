# TODO - dotfiles改善課題

## セキュリティ・プライバシー
- [ ] fish/config.fishのClaude Code環境変数を.envファイルに移動
- [ ] ubuntu/setup.shのGit個人情報をテンプレート化
- [ ] vscode/settings.jsonのローカルPythonパスを汎用化

## シェルスクリプトの安全性
- [ ] すべてのシェルスクリプトに`set -euo pipefail`を追加
- [ ] link.shのバックアップ処理にタイムスタンプを付けて上書き防止
- [ ] 各スクリプトにエラーハンドリングを追加

## 依存関係の更新
- [ ] install.shの`rmtrash`を削除または代替コマンドに変更
- [ ] fish_shell_local_install.shのFishバージョンを最新に更新
- [ ] DockerfileのベースイメージとPythonパッケージを更新
- [ ] tmux.confの`reattach-to-user-namespace`設定を条件分岐化

## ドキュメントの整合性
- [ ] README.mdの`.Brewfile`への参照を削除
- [ ] install.shの実行手順を明確化
- [ ] Python環境構築の推奨方法を統一（uvに統一？）
- [ ] dockerビルドコマンドのパスを修正

## 設定ファイルのクリーンアップ
- [ ] vscode/settings.jsonの廃止された設定を削除
- [ ] 古いPython拡張機能の設定を整理
- [ ] karabinerの自動バックアップファイルの管理方法を検討

## プラットフォーム対応
- [ ] OS別の設定を整理・共通化
- [ ] fishでrmtrashのエイリアスを条件分岐化
- [ ] Linux環境のAnacondaバージョンを更新

## その他
- [ ] .gitignoreに個人設定ファイルを追加
- [ ] 設定ファイルのテンプレート（.example）を作成
- [ ] セットアップ手順の自動化スクリプトを作成
- [ ] CI/CDでシェルスクリプトの構文チェックを実施