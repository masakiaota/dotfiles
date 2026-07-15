#!/bin/sh

set -eu

usage() {
  cat <<'EOF'
Usage:
  delegate_worker.sh [OPTIONS] --task "TASK"
  printf '%s\n' "TASK" | delegate_worker.sh [OPTIONS]

Options:
  --model MODEL          Model for a new worker (default: gpt-5.6-luna)
  --effort LEVEL         Reasoning effort for a new worker (default: xhigh)
  -C, --cwd DIR          New-worker directory (default: current directory)
  -o, --output FILE      Also retain the final worker message in FILE
  --persist              Persist a new worker so it can be resumed
  --session-id-file FILE Write the persistent session ID to FILE
  --resume SESSION_ID    Resume an existing persistent worker
  --load-user-config     Load $CODEX_HOME/config.toml (ignored by default)
  --ignore-user-config   Explicitly keep the default isolated configuration
  --allow-non-git        Allow execution outside a Git repository
  --verbose              Stream Codex progress and diagnostics to stderr
  -t, --task TASK        Task text; otherwise read it from stdin
  -h, --help             Show this help

Environment:
  CODEX_BIN              Codex executable path or name (default: codex)
EOF
}

require_value() {
  if [ "$#" -lt 2 ] || [ -z "$2" ]; then
    echo "delegate_worker.sh: $1 requires a value" >&2
    exit 2
  fi
}

model=gpt-5.6-luna
effort=xhigh
model_set=false
effort_set=false
cwd=$(pwd)
cwd_set=false
output=
task=
task_set=false
persist=false
session_id_file=
resume_id=
ignore_user_config=true
allow_non_git=false
verbose=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --model)
      require_value "$@"
      model=$2
      model_set=true
      shift 2
      ;;
    --effort)
      require_value "$@"
      effort=$2
      effort_set=true
      shift 2
      ;;
    -C|--cwd)
      require_value "$@"
      cwd=$2
      cwd_set=true
      shift 2
      ;;
    -o|--output)
      require_value "$@"
      output=$2
      shift 2
      ;;
    --persist)
      persist=true
      shift
      ;;
    --session-id-file)
      require_value "$@"
      session_id_file=$2
      persist=true
      shift 2
      ;;
    --resume)
      require_value "$@"
      resume_id=$2
      persist=true
      shift 2
      ;;
    --load-user-config)
      ignore_user_config=false
      shift
      ;;
    --ignore-user-config)
      ignore_user_config=true
      shift
      ;;
    --allow-non-git)
      allow_non_git=true
      shift
      ;;
    --verbose)
      verbose=true
      shift
      ;;
    -t|--task)
      require_value "$@"
      task=$2
      task_set=true
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      if [ "$#" -gt 0 ]; then
        task=$*
        task_set=true
      fi
      break
      ;;
    *)
      echo "delegate_worker.sh: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$effort" in
  low|medium|high|xhigh|max) ;;
  ultra)
    echo "delegate_worker.sh: ultra is prohibited because it can recursively delegate" >&2
    exit 2
    ;;
  *)
    echo "delegate_worker.sh: unsupported reasoning effort: $effort" >&2
    exit 2
    ;;
esac

if [ -n "$resume_id" ] && [ "$cwd_set" = true ]; then
  echo "delegate_worker.sh: --cwd cannot be used with --resume; the saved workspace is reused" >&2
  exit 2
fi

if [ -z "$resume_id" ] && [ ! -d "$cwd" ]; then
  echo "delegate_worker.sh: directory does not exist: $cwd" >&2
  exit 2
fi

if [ -n "$session_id_file" ]; then
  session_id_dir=$(dirname "$session_id_file")
  if [ ! -d "$session_id_dir" ]; then
    echo "delegate_worker.sh: session ID directory does not exist: $session_id_dir" >&2
    exit 2
  fi
  if [ "$verbose" = true ] && [ -z "$resume_id" ]; then
    echo "delegate_worker.sh: --verbose cannot be combined with a new --session-id-file run" >&2
    exit 2
  fi
fi

if [ "$task_set" = false ] && [ -t 0 ]; then
  echo "delegate_worker.sh: provide a non-empty task with --task or stdin" >&2
  exit 2
fi

codex_bin=${CODEX_BIN:-codex}
if ! command -v "$codex_bin" >/dev/null 2>&1; then
  echo "delegate_worker.sh: Codex executable not found: $codex_bin" >&2
  exit 127
fi

if [ -n "$resume_id" ]; then
  set -- "$codex_bin" exec resume \
    --config 'approval_policy="on-request"' \
    --config 'approvals_reviewer="auto_review"' \
    --config 'sandbox_mode="workspace-write"'
  if [ "$model_set" = true ]; then
    set -- "$@" --model "$model"
  fi
  if [ "$effort_set" = true ]; then
    set -- "$@" --config "model_reasoning_effort=\"$effort\""
  fi
else
  set -- "$codex_bin" exec \
    --model "$model" \
    --config "model_reasoning_effort=\"$effort\"" \
    --config 'approval_policy="on-request"' \
    --config 'approvals_reviewer="auto_review"' \
    --sandbox workspace-write \
    --cd "$cwd"
  if [ "$persist" = false ]; then
    set -- "$@" --ephemeral
  fi
fi

if [ "$ignore_user_config" = true ]; then
  set -- "$@" --ignore-user-config
fi
if [ "$allow_non_git" = true ]; then
  set -- "$@" --skip-git-repo-check
fi
last_message=$output
cleanup_last_message=false
if [ -z "$last_message" ]; then
  last_message=$(mktemp "${TMPDIR:-/tmp}/delegate-worker-last-message.XXXXXX")
  cleanup_last_message=true
fi
set -- "$@" --output-last-message "$last_message"
if [ -n "$resume_id" ]; then
  set -- "$@" "$resume_id"
fi

run_worker() {
  if [ "$task_set" = true ]; then
    printf '%s' "$task" | "$@" -
  else
    "$@" -
  fi
}

cleanup() {
  if [ -n "${diagnostics:-}" ]; then
    rm -f "$diagnostics"
  fi
  if [ "$cleanup_last_message" = true ]; then
    rm -f "$last_message"
  fi
}

trap cleanup 0 HUP INT TERM

echo "delegate-worker: 作業を開始する（PID: $$）。" >&2
echo "delegate-worker: AIはこのスクリプトが完了まで待機する。PID は確認しない。途中の出力がなくても処理中である。" >&2

ensure_last_message() {
  if [ -s "$last_message" ]; then
    return 0
  fi
  echo "delegate-worker: worker は成功したが、最終メッセージを取得できなかった" >&2
  return 1
}

if [ "$verbose" = true ]; then
  if run_worker "$@"; then
    ensure_last_message
    if [ -n "$session_id_file" ] && [ -n "$resume_id" ]; then
      printf '%s\n' "$resume_id" >"$session_id_file"
    fi
    exit 0
  else
    exit $?
  fi
fi

diagnostics=$(mktemp "${TMPDIR:-/tmp}/delegate-worker.XXXXXX")

if run_worker "$@" >"$diagnostics" 2>&1; then
  if ! ensure_last_message; then
    cat "$diagnostics" >&2
    exit 1
  fi
  if [ -n "$session_id_file" ]; then
    if [ -n "$resume_id" ]; then
      session_id=$resume_id
    else
      session_id=$(sed -n 's/^session id: //p' "$diagnostics" | sed -n '1p')
    fi
    if [ -z "$session_id" ]; then
      echo "delegate_worker.sh: worker succeeded but its session ID was not found" >&2
      exit 1
    fi
    printf '%s\n' "$session_id" >"$session_id_file"
  fi
  cat "$last_message"
  exit 0
else
  status=$?
  cat "$diagnostics" >&2
  exit "$status"
fi
