---
name: side-chat-to-main
description: "Relay a confirmed decision from a Codex user-facing side chat (side agent) to its existing main chat with send_message_to_thread. Trigger: the current conversation is a side chat and the user asks to tell, send, hand off, synchronize, apply, or reflect an agreed decision in the main agent or main chat. Do not trigger: subagent-to-agent coordination, discussion or summarization that does not request sending a decision, a destination other than the main chat, or work that belongs to internal messaging or followup_task."
---

# Side Chat To Main

ユーザーと side chat で確定した決定を main chat の作業へ反映する。side chat はユーザーが直接議論する会話であり、subagent ではない。side chat から main chat への引き継ぎは、アプリの thread 間メッセージとして扱う。

## 送信チャネルを選ぶ

- side chat で合意した決定を main chat へ渡すときは、`send_message_to_thread` を使う。
- `send_message` を代用しない。これは agent 木の内部連絡であり、main chat の follow-up prompt を作らない。
- `followup_task` を root agent 宛てに試さない。root agent は対象外であり、この経路は side chat の決定を main chat へ渡す用途ではない。
- 送信要求が「main agent に決定事項を伝えて」「main chat に反映して」「この方針を本体へ渡して」の意味なら、ユーザーに main chat 側で再入力させず、以下の手順を実行する。

## 実行手順

1. 決定を確定する。side chat 内で単なる検討中の案しかない場合は、送るべき決定を短く確認する。確定している場合は確認を挟まない。
2. main chat 向けの自己完結した prompt を作る。少なくとも「決定」「それが適用される範囲」「理由または制約」「main chat に依頼する次の行為」を含める。`これ`、`その件`、`上記` のような side chat の文脈にだけ依存する指示を使わない。
3. main chat の `threadId` を解決する。親 thread の情報やユーザー指定の ID があればそれを使う。なければ `list_threads` で候補を取得し、タイトル、要約、作業対象を照合する。候補が複数なら `read_thread` で必要最小限の内容を確認する。
4. 宛先を一意に特定できたら、返答の前に `send_message_to_thread` を呼ぶ。`hostId` が候補情報に含まれる場合は渡す。ユーザーが明示しない限り `model` と `thinking` は指定しない。
5. ツールの成功結果を確認してから、宛先の main chat と送った要点を報告する。main chat が実行中なら、受信時刻や反映完了を推測せず、follow-up prompt を送信した事実だけを述べる。

## 宛先を解決できない場合

`list_threads` と必要な `read_thread` を試す前に、ユーザーへ main chat 側での再入力を求めない。探索後も候補を一意に定められない場合だけ、候補のタイトルなどを示して宛先を一つ質問する。

`send_message_to_thread` が利用できない、または送信に失敗した場合は、送信していないことと失敗理由を明示する。内部メッセージを送っただけで「main agent へ送信した」「反映した」と報告しない。

## 完了報告の基準

- 成功時は「main chat `<title>` へ決定を含む follow-up prompt を送信した」と報告する。
- main chat が実際に読んだ、採用した、実装したことは、対象 thread の結果を確認するまで報告しない。
- 送信不要なら「main chat の作業へ反映する決定ではないため送信しない」と理由を添える。
