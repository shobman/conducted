#!/usr/bin/env bash
# Regenerates docs/ledger/ROLLUP.md from docs/ledger/*.md (excluding ROLLUP.md itself).
set -euo pipefail
shopt -s nullglob
OUT="docs/ledger/ROLLUP.md"
{
  echo "# Ledger rollup (generated — do not edit)"
  echo
  echo "| node | sized | predicted | actual | closed |"
  echo "|------|-------|-----------|--------|--------|"
  for f in docs/ledger/*.md; do
    [[ "$(basename "$f")" == "ROLLUP.md" ]] && continue
    node=$(awk '/^# Ledger:/{sub(/^# Ledger: /,"");print;exit}' "$f")
    sized=$(awk '/^sized-as:/{sub(/^sized-as: /,"");print;exit}' "$f")
    pred=$(awk '/^predicted:/{sub(/^predicted: /,"");print;exit}' "$f")
    act=$(awk '/^actual:/{sub(/^actual: /,"");print;exit}' "$f")
    closed=$(awk '/^closed:/{sub(/^closed: /,"");print;exit}' "$f")
    echo "| ${node:-?} | ${sized:-?} | ${pred:-?} | ${act:-?} | ${closed:-open} |"
  done
} > "$OUT"
echo "wrote $OUT"
