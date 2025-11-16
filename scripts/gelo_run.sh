#!/usr/bin/env bash
# Log Smartian runs into gelo-run/<timestamp>_<label>.log

set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <label> <command ...>" >&2
  echo "Example: $0 RE dotnet build/Smartian.dll fuzz -p examples/bc/RE.bin ..." >&2
  exit 1
fi

LABEL="$1"
shift

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$REPO_ROOT/gelo-run"
mkdir -p "$LOG_DIR"

timestamp="$(date '+%Y-%m-%d_%H-%M-%S')"
safe_label="$(echo "$LABEL" | tr -c '[:alnum:]_-' '_')"
log_file="$LOG_DIR/${timestamp}_${safe_label}.log"

{
  echo "Label        : $LABEL"
  echo "Command      : $*"
  echo "Started      : $(date '+%Y-%m-%d %H:%M:%S %Z')"
  echo "Working Dir  : $(pwd)"
  echo "========================================"
} | tee -a "$log_file"

set +e
"$@" 2>&1 | tee -a "$log_file"
status=${PIPESTATUS[0]}
set -e

{
  echo "----------------------------------------"
  echo "Finished     : $(date '+%Y-%m-%d %H:%M:%S %Z')"
  echo "Exit Code    : $status"
} | tee -a "$log_file"

exit "$status"
