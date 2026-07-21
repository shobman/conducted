#!/usr/bin/env bash
# Usage: manifest-check.sh <node-path> <base-ref>
# Fails if the diff vs <base-ref> touches files outside the node's territory.
#
# TERRITORY IS LAW AS OF THE BASE REF (doctrine v2; field-proven at the game project —
# see conducted docs/field-reports/2026-07-18-first-e2e.md): the brief —
# including any appended "### Manifest delta" blocks — is read from <base-ref>,
# never from the working tree. A node therefore cannot widen its own scope inside
# the PR that relies on the widening: a widening must first land on the base branch
# (escalate → owner rules → Principal appends the delta + ruling), after which this
# gate sees it. This closes the self-widening hole three evaluators demonstrated in
# the field: the measured party no longer writes the measurement, so in-PR forgery
# of authority is structurally impossible and no in-file authority checking is
# needed at all.
#
# Principal-owned law (docs/VISION.md, docs/ROADMAP.md, docs/DECISIONS.md) is
# never node territory, regardless of globs: rulings are recorded on the base
# branch by the Principal/owner, not inside node PRs. Nodes always get their own
# work/<node>/ dir plus docs/findings/** and docs/ledger/**.
set -euo pipefail
NODE="$1"; BASE="${2:-origin/main}"
NODE="${NODE#work/}"  # accepts both "work/hello" and "hello"
BRIEF="work/$NODE/brief.md"
if ! git cat-file -e "$BASE:$BRIEF" 2>/dev/null; then
  echo "manifest-check: no brief at $BASE:$BRIEF — territory must be law on the base ref before the node's PR" >&2
  exit 2
fi
# Globs: the CONTIGUOUS "- " bullet list under "## Territory manifest" or any
# exact "### Manifest delta" heading, as the brief exists on the BASE ref.
# Collection stops at the first blank line or non-bullet line once bullets have
# started (a heading only arms collection; blank lines before the first bullet
# are skipped) — the parser proven in the toolchain-spike evaluations.
mapfile -t GLOBS < <(git show "$BASE:$BRIEF" | awk '
  /^## Territory manifest/{f=1;started=0;next}
  /^### Manifest delta[[:space:]]*$/{f=1;started=0;next}
  f && /^- /{started=1;sub(/^- /,"");print;next}
  f && /^[[:space:]]*$/{if(started){f=0};next}
  f{f=0}')
[[ ${#GLOBS[@]} -gt 0 ]] || { echo "manifest-check: brief on $BASE has an empty territory manifest" >&2; exit 2; }
# SENSOR HONESTY (v6): any delta-like heading this parser does NOT arm on would be
# silently unenforced — a Principal's narrowing block with a nonmatching heading was
# never read in the field (the queue app) while the gate stayed green. The gate must say
# what it cannot see: fail loudly on unparseable delta-like blocks.
UNSEEN=$(git show "$BASE:$BRIEF" | grep -inE '^###+ .*delta' | grep -vE $'^[0-9]+:### Manifest delta[ \t]*$' || true)
if [[ -n "$UNSEEN" ]]; then
  echo "manifest-check: delta-like heading(s) exist that this gate does NOT parse - they are NOT being enforced. Retitle to exactly '### Manifest delta' or restructure:" >&2
  echo "$UNSEEN" >&2
  exit 2
fi
# Always allowed: the node's own dir, findings, ledger, field-notes (v3 mandates
# filing field notes; v5 fixes the contradiction where this gate rejected them).
# NOT docs/ wholesale.
GLOBS+=("work/$NODE/**" "docs/findings/**" "docs/ledger/**" "docs/field-notes/**")
# Glob semantics (doctrine v5): '**' matches across path segments; '*' matches
# WITHIN one segment only. bash case '*' matches '/' — so the old matcher made
# "src/*" silently grant "src/**", territory wider than the brief author wrote
# (found by an external contributor's port review, 2026-07-19). Globs are compiled to anchored
# regexes: '**'→'.*'  '*'→'[^/]*'  '?'→'[^/]'  everything else literal.
glob_to_regex() {
  local g="$1" out="" i c
  for ((i = 0; i < ${#g}; i++)); do
    c="${g:i:1}"
    case "$c" in
      \*) if [[ "${g:i+1:1}" == "*" ]]; then out+=".*"; ((i++)); else out+="[^/]*"; fi;;
      \?) out+="[^/]";;
      [.^\$+\(\)\{\}\|\[\]\\]) out+="\\$c";;
      *) out+="$c";;
    esac
  done
  printf '%s' "^${out}\$"
}
DIFF_OUT=$(git diff --name-only "$BASE"...HEAD) || { echo "manifest-check: git diff against $BASE failed" >&2; exit 2; }
FAIL=0
while IFS= read -r file; do
  [[ -z "$file" ]] && continue
  case "$file" in
    docs/VISION.md|docs/ROADMAP.md|docs/DECISIONS.md)
      echo "OUTSIDE MANIFEST (Principal-owned law): $file" >&2; FAIL=1; continue;;
  esac
  ok=0
  for g in "${GLOBS[@]}"; do
    if [[ "$file" =~ $(glob_to_regex "$g") ]]; then ok=1; break; fi
  done
  if [[ $ok -eq 0 ]]; then echo "OUTSIDE MANIFEST: $file" >&2; FAIL=1; fi
done <<< "$DIFF_OUT"
exit $FAIL
