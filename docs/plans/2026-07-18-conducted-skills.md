# Conducted Development Skills (/principal + /conduct) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the two user-global Claude Code skills (`/principal`, `/conduct`) plus the repo-seed templates that implement the validated "Conducted development at scale" spec, ready for a genesis session on a new game project repo.

**Architecture:** A source-of-truth repo (`the conducted repo`) holds skill sources under `skills/`, seed templates under `seed/`, and an idempotent installer that copies skills into `~/.claude/skills`. The `/principal` skill has two modes (genesis on an empty repo — interviews the owner and scaffolds the seed; wake on an existing repo — two-ledger pass, brief drafting, menu pricing, dispatch board). The `/conduct` skill runs one node end-to-end: worktree bootstrap → scout with proof-of-work countersign → split-or-plan → fleet → hardened evaluator → showcase PR (top-cut) or fold-up (inner node). Skills carry operational instructions only; doctrine lives in the seed `CLAUDE.md` that genesis copies into each project.

**Tech Stack:** Claude Code skills (SKILL.md markdown + YAML frontmatter), PowerShell (installer), bash (CI scripts for GitHub Actions ubuntu runners), GitHub Actions + `gh` CLI, gitleaks (secret scan).

## Global Constraints

- Spec of record: memento-kb lore note `2026-07-18-conducted-development-at-scale-principal-conductors-fleet-validated-spec`. Where this plan and the spec conflict, the spec wins.
- Skills are USER-GLOBAL: installed to `~/.claude/skills/<name>/SKILL.md`. Source of truth stays in this repo; never edit the installed copy.
- Skill prose must stay tight. State goals and constraints, not enumerated micro-steps — over-ritualized briefing packs measurably degrade frontier-model output (validation finding).
- The seed is PLATFORM-AGNOSTIC. No platform-specific assumptions anywhere (the toolchain spike decides those later).
- Model doctrine strings used verbatim everywhere: Principal default `opus`; plan-shaping escalation `fable`; builders `sonnet`; mechanical work `haiku`.
- Repo-law filenames used verbatim everywhere: `docs/VISION.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/findings/<id>.md`, `docs/ledger/<node-id>.md`, `docs/ledger/ROLLUP.md`, `work/<node>/brief.md`, `work/<node>/plan.md`, `work/<node>/showcase.md`, `work/<node>/status.json`.
- Windows host: installer and local verification commands are PowerShell; CI scripts are bash (GitHub ubuntu runners). Git Bash paths (`/c/...`) in Bash-tool commands.
- Commits in this repo end with the standard Claude Code trailers.

---

### Task 1: Repo scaffold + installer

**Files:**
- Create: `README.md`
- Create: `install.ps1`
- Create: `.gitignore`

**Interfaces:**
- Produces: `install.ps1` copies every `skills/<name>/` directory in this repo to `~/.claude/skills/<name>/` (creating dirs, overwriting files). Later tasks (2, 5, 6, 7) create `skills/principal/SKILL.md`, `skills/conduct/SKILL.md`, and `seed/**` which Task 8 verifies through this installer.

- [ ] **Step 1: Write README.md**

```markdown
# conducted

Source of truth for the **conducted development at scale** tooling: the `/principal` and
`/conduct` Claude Code skills and the repo-seed templates they scaffold.

- Spec of record: Memento lore `2026-07-18-conducted-development-at-scale-principal-conductors-fleet-validated-spec`
- Live showcase of the spec: https://claude.ai/code/artifact/49da1bda-a3b6-454a-ab34-51f935e8fc28

## Layout

- `skills/principal/` — the Principal Conductor skill (genesis + wake modes)
- `skills/conduct/` — the node conductor skill
- `seed/` — templates genesis copies into a new project repo (doctrine CLAUDE.md, brief/showcase
  templates, status.json schema, CI gates)
- `install.ps1` — idempotent: copies `skills/*` into `~/.claude/skills/`

## Install / update

    ./install.ps1

Never edit the installed copies under `~/.claude/skills` — edit here, reinstall.

## One-time GitHub setup per project repo (manual)

GitHub's initiator-can't-approve rule means a PR opened by your own account cannot be approved by
you. Conductor sessions must therefore push PRs via a bot identity so the owner's review counts:
create a machine account (or GitHub App) with write access, store its token as the `CONDUCTED_BOT`
secret, and conductors use `gh auth` with it when opening PRs. Genesis prints these instructions.
```

- [ ] **Step 2: Write install.ps1**

```powershell
# Idempotent installer: copies skills/* from this repo into ~/.claude/skills/
$ErrorActionPreference = "Stop"
$src = Join-Path $PSScriptRoot "skills"
$dst = Join-Path $HOME ".claude\skills"
if (-not (Test-Path $src)) { throw "No skills/ directory found next to install.ps1" }
New-Item -ItemType Directory -Force -Path $dst | Out-Null
Get-ChildItem -Directory $src | ForEach-Object {
    $target = Join-Path $dst $_.Name
    New-Item -ItemType Directory -Force -Path $target | Out-Null
    Copy-Item -Path (Join-Path $_.FullName "*") -Destination $target -Recurse -Force
    Write-Host "installed skill: $($_.Name) -> $target"
}
Write-Host "done."
```

- [ ] **Step 3: Write .gitignore**

```gitignore
*.tmp
.DS_Store
```

- [ ] **Step 4: Verify installer fails cleanly with no skills dir yet**

Run (PowerShell): `cd the conducted repo; ./install.ps1`
Expected: error containing "No skills/ directory found" (skills/ arrives in Task 5).

- [ ] **Step 5: Commit**

```bash
cd /c/code/repos/conducted && git add -A && git commit -m "chore: scaffold conducted repo with installer"
```

---

### Task 2: Seed doctrine — `seed/CLAUDE.md`

**Files:**
- Create: `seed/CLAUDE.md`

**Interfaces:**
- Produces: the doctrine file genesis copies verbatim to a new project repo's root `CLAUDE.md`. `/principal` and `/conduct` (Tasks 5–6) assume every project session has read it; they reference its section names exactly: "Roles", "The work tree", "Repo law", "Gates", "Economics", "Session end".

- [ ] **Step 1: Write seed/CLAUDE.md**

```markdown
# How this repo works — conducted development at scale

This project is run by the **conducted development** model. Spec of record: Memento lore
`2026-07-18-conducted-development-at-scale-principal-conductors-fleet-validated-spec`. This file is
the operational law every session must follow. It is written for agents; the owner does not read code.

## Roles

- **Owner** rules on taste, priorities, irreversibles, and appetite (spend). Reviews the product via
  showcases, never diffs. The owner is a required GitHub reviewer ONLY on top-cut showcase merges and
  irreversibles.
- **Principal** (a role — any session running `/principal`; default model opus, fable for
  plan-shaping) holds the map: VISION, ROADMAP graph, sequencing, ledger, rulings queues. The
  Principal never conducts nodes and never reads code.
- **Conductors** (one session per node, via `/conduct <node-path>`) own everything inside their
  node's countersigned brief. All implementation is done by their worktree-isolated subagent fleet —
  a conductor orchestrates and commits; it does not play.
- **Models:** the Principal defaults to opus (fable is summoned for plan-shaping only); fleet builders default to sonnet; mechanical work runs on haiku. Premium tokens buy map-rewrites, never status checks.
- Every sensor must have a source other than the party it measures: progress claims cite repo state,
  evaluators never share the builder's context, estimates are set by the parent.

## The work tree

Work is a recursive tree of **nodes** under `work/`. Split test: can one conductor hold this node's
whole map while its fleet builds it? If not, cut child briefs (same contract shape). Laws:
- Only top-cut nodes produce `showcase.md` for the owner; inner nodes deliver to their parent.
- Scope only narrows downward. Any widening bubbles up to the level a human approved.
- Prefer flat; splitting to depth ≥3 requires written justification in the parent's plan.md.
- For hard nodes, prefer best-of-N racing (N attempts, one merge) over splitting.
- Node naming: a node's PATH is `work/<a>/<b>`; its SLUG is the path below `work/` with `/`→`-`
  (branch `node/a-b`, ledger `docs/ledger/a-b.md`) — slugs are globally unique by construction.
  Inner-node manifest checks diff against the PARENT branch, not origin/main.

## Repo law (files are the state; conversations are disposable)

- `docs/VISION.md` — the grand prize. Principal-owned.
- `docs/ROADMAP.md` — the TOP-CUT dependency graph. Edge types: merge-gated, findings-gated,
  ruling-gated, independent. Principal-owned.
- `docs/DECISIONS.md` — append-only law. Anyone may append; nobody edits.
- `docs/findings/<id>.md` — evidence, one file per finding, header `status: active` or
  `status: superseded-by: <id>`.
- `docs/ledger/<node-id>.md` — per-node economics: sized-as / predicted / actual tokens+hours / why
  the delta. `docs/ledger/ROLLUP.md` is generated by `scripts/rollup.sh`; never hand-edit.
- `work/<node>/brief.md` — the contract. IMMUTABLE once countersigned; changes are delta blocks
  appended below the original, never edits to it.
- `work/<node>/plan.md` — conductor-owned. The Principal may read headings, never edits.
- `work/<node>/showcase.md` — the deliverable to the owner. Top-cut nodes only; inner nodes deliver to their parent's evaluator instead.
- `work/<node>/status.json` — machine state. Agents may only flip booleans and append actuals.
- Agent-to-agent coordination happens through these files and PR status — never through PR comment
  threads. PR review threads are for the human boundary.

## Gates (never on the menu, at any budget)

Every merge to main requires green: tests · lint/warnings-as-errors · secret scan · territory
manifest check (diff must stay inside the brief's globs) · adversarial diff review (run
`/code-review` at medium+; findings addressed or explicitly waived in the PR description) · for
node-closing PRs, the evaluator verdict recorded in status.json. Conductors commit; only gates
merge. The owner's approval is required only where branch protection says so.

## Economics

The owner's triangle is QUALITY / COST / SCOPE; code quality is the floor, not a lever. Budget moves
scope and experience-quality only, and experience-quality trades are made in brief DoD clauses
(a "rough-cut" node has that written down — quality changes are rulings, never drift). Between
owner rulings, the last ruled spend cap is an absolute circuit-breaker: at the cap, open no new
frontier; route effort to merge-readiness. Record actuals honestly; every actuals claim must cite
its source (transcript/token counts). Briefs carry a minimum viable appetite — "don't build below
$Z" is a legitimate answer.

## Session end (no session ends dirty)

1. Nothing stranded: every worktree merged, PR'd, or abandoned with a written reason.
2. Durable knowledge committed: plan/status/findings/ledger updated so the repo alone can resume.
3. Environment restored; no stray processes (kill by PID, never by pattern).
4. A written handoff in the node's plan.md or the Principal's wake notes: landed / in flight /
   held-for-owner / held-for-fable / next step.
5. Memento journal upserted with a one-line resume pointer.
```

- [ ] **Step 2: Verify file parses as plain markdown (no broken fences)**

Run (PowerShell): `Get-Content seed/CLAUDE.md | Select-String -Pattern '```' | Measure-Object | Select-Object -ExpandProperty Count`
Expected: `0` (doctrine file contains no code fences).

- [ ] **Step 3: Commit**

```bash
cd /c/code/repos/conducted && git add seed/CLAUDE.md && git commit -m "feat(seed): doctrine CLAUDE.md for conducted projects"
```

---

### Task 3: Seed templates — brief, showcase, status.json, ledger, roadmap skeletons

**Files:**
- Create: `seed/templates/brief.md`
- Create: `seed/templates/showcase.md`
- Create: `seed/templates/status.json`
- Create: `seed/templates/ledger-entry.md`
- Create: `seed/docs/ROADMAP.md`
- Create: `seed/docs/DECISIONS.md`
- Create: `seed/.gitignore`

**Interfaces:**
- Consumes: doctrine section names from Task 2.
- Produces: template files that `/principal` fills when drafting briefs (Task 5) and `/conduct` fills when closing nodes (Task 6). Exact placeholder tokens are UPPERCASE-IN-ANGLE-BRACKETS (e.g. `<NODE-PATH>`); skills replace every one — a template token surviving into a real file is a gate failure.

- [ ] **Step 1: Write seed/templates/brief.md**

```markdown
# Brief: <NODE-PATH>

status: draft | countersigned
parent: <PARENT-NODE-PATH-OR-root>
size: <POINTS> (reference class: <CLOSED-NODE-ID-OR-none>)
predicted-spend: $<LOW>–$<HIGH> (confidence: <LOW|MED|HIGH>, basis: <N> closed nodes)
minimum-viable-appetite: $<Z>
quality-tier: <FULL-POLISH | ROUGH-CUT> — tier is expressed in the DoD below, not adjectives

## Objective (product terms)
<WHAT-EXISTS-WHEN-DONE-AND-FOR-WHOM>

## Why now
<POSITION-IN-ROADMAP-AND-WHAT-GATES-CLEARED>

## Territory manifest (globs — CI enforces; diff outside these fails)
- <GLOB-1>
- <GLOB-2>

## Definition of done
- [ ] <TESTABLE-CLAUSE-1>
- [ ] <TESTABLE-CLAUSE-2>

## Showcase requirements
<WHAT-THE-OWNER-MUST-BE-ABLE-TO-DO-AND-SEE; for inner nodes: what the parent's evaluator verifies>

## Out of scope
<EXPLICIT-EXCLUSIONS>

---
## Countersign (conductor appends; the sections above are immutable after this lands)
scouted: <FILES-AND-SURFACES-EXAMINED>
proof-of-work: <ONE-DISCREPANCY-FOUND-AND-RESOLUTION> OR <THREE-SPECIFIC-CHECKS-THAT-HELD>
estimate-adjustment: <±PCT-AND-REASON-OR-none>
countersigned-by: <SESSION-DATE>

## Deltas (append-only; each is a diff against the original, never an edit)
```

- [ ] **Step 2: Write seed/templates/showcase.md**

```markdown
# Showcase: <NODE-PATH>

quality-tier-built-to: <FULL-POLISH | ROUGH-CUT>
evidence-captured: <DATE> against main @ <SHA>   <!-- staleness SLA: recapture if stale vs main -->

## Decisions made on your behalf (read first)
- <DECISION-AND-WHY> (delta ref: <NONE-OR-DELTA-ID>)

## What you can now do
<OUTCOME-FIRST-PRODUCT-LANGUAGE>

## Go use it
<LINK-OR-EXACT-RUN-INSTRUCTION>

## Evidence (captured by the evaluator, driving the real thing from main)
- DoD: <EACH-CLAUSE-WITH-ITS-PROOF>
- Probes run: <COUNT> (negative-path: <COUNT>, off-script: <COUNT>, failures found+fixed: <COUNT>)
- <SCREENSHOT/VIDEO-PATHS-OR-PR-ATTACHMENTS>
- Gates: tests <PASS>, lint <PASS>, secrets <PASS>, manifest <PASS>, diff-review <VERDICT>

## Deliberately not done
- <ITEM-AND-REASON>

## Open rulings for the owner
1. <RULING-NEEDED>

## The road ahead (money)
next review gate ≈ $<Y> | current cap: $<CAP> spent $<ACTUAL>
```

- [ ] **Step 3: Write seed/templates/status.json**

```json
{
  "node": "<NODE-PATH>",
  "phase": "briefed",
  "phases": ["briefed", "countersigned", "planned", "building", "evaluating", "showcased", "merged"],
  "dod": [
    { "clause": "<TESTABLE-CLAUSE-1>", "passes": false, "proof": null }
  ],
  "evaluator": { "verdict": null, "probes_run": 0, "probe_failures": 0, "transcript": null },
  "actuals": { "tokens": 0, "hours": 0.0, "agent_count": 0, "sources": [] },
  "held_for_owner": [],
  "held_for_fable": []
}
```

- [ ] **Step 4: Write seed/templates/ledger-entry.md**

```markdown
# Ledger: <NODE-PATH>

sized-as: <POINTS>
predicted: $<LOW>–$<HIGH>
actual: <TOKENS> tokens · <HOURS> h · <AGENTS> agents · ≈$<COST>
delta-why: <ONE-PARAGRAPH-HONEST-CAUSE>
sources: <TRANSCRIPT-OR-TOKEN-REPORT-REFS>
closed: <DATE>
```

- [ ] **Step 5: Write seed/docs/ROADMAP.md**

```markdown
# ROADMAP — the top-cut graph

<!-- Principal-owned. One block per top-cut node. Edge types: merge-gated | findings-gated |
     ruling-gated | independent. A second dependency on an open ruling converts it to ruling-gated
     (blocking). Frontier nodes have countersigned briefs; beyond-frontier nodes are sketches. -->

## Frontier
<!-- ### <node-name>  · status: ready|in-flight · edges: <type>-><node|ruling|finding> · brief: work/<node>/brief.md -->

## Sketches (deliberately un-fleshed)
<!-- ### <node-name> — one paragraph. edges: ... -->

## Open owner rulings
<!-- - [R1] <question> · asked <date> · depended-on-by: <nodes> (2+ => BLOCKING) -->

## Held for Fable
<!-- - <item> · queued <date> · rubric: genesis|graph-restructure|cross-node-contradiction|second-stall -->
```

- [ ] **Step 6: Write seed/docs/DECISIONS.md**

```markdown
# DECISIONS — append-only law

<!-- Newest at top. Format: ## <date> <title> / ruled-by: owner|principal|fable-consult / <ruling> / why: <reason> -->
```

- [ ] **Step 7: Verify every template placeholder is angle-bracket-uppercase (greppable)**

Run: `cd /c/code/repos/conducted && grep -rEo '<[A-Z][A-Z0-9±$/|.-]*>' seed/templates | wc -l`
Expected: a count ≥ 30 (all placeholders follow the convention; skills grep for leftovers with this same pattern).

- [ ] **Step 8: Commit**

```bash
cd /c/code/repos/conducted && git add seed/ && git commit -m "feat(seed): brief/showcase/status/ledger/roadmap templates"
```

- [ ] **Step 9: Write seed/.gitignore**

```gitignore
.worktrees/
*.tmp
```

---

### Task 4: Seed CI gates — manifest check, rollup script, workflow

**Files:**
- Create: `seed/scripts/manifest-check.sh`
- Create: `seed/scripts/rollup.sh`
- Create: `seed/.github/workflows/gates.yml`

**Interfaces:**
- Consumes: brief.md "Territory manifest" section format from Task 3 (lines starting `- ` under that heading).
- Produces: `manifest-check.sh <node-path> <base-ref>` exits non-zero if the diff vs base touches files outside the brief's globs (plus always-allowed: the node's own `work/<node>/**` and `docs/**`). `rollup.sh` regenerates `docs/ledger/ROLLUP.md`. `gates.yml` wires tests/lint hooks (project-defined), gitleaks, and manifest check into required checks. `/conduct` (Task 6) calls both scripts by these exact paths.

- [ ] **Step 1: Write seed/scripts/manifest-check.sh**

```bash
#!/usr/bin/env bash
# Usage: manifest-check.sh <node-path> <base-ref>
# Fails if the diff vs <base-ref> touches files outside the node brief's territory manifest.
set -euo pipefail
NODE="$1"; BASE="${2:-origin/main}"
NODE="${NODE#work/}"  # accepts both "work/hello" and "hello"
BRIEF="work/$NODE/brief.md"
[[ -f "$BRIEF" ]] || { echo "manifest-check: no brief at $BRIEF" >&2; exit 2; }
# Extract globs: lines beginning "- " between the manifest heading and the next heading
mapfile -t GLOBS < <(awk '/^## Territory manifest/{f=1;next} /^## /{f=0} f && /^- /{sub(/^- /,"");print}' "$BRIEF")
[[ ${#GLOBS[@]} -gt 0 ]] || { echo "manifest-check: brief has an empty territory manifest" >&2; exit 2; }
# Always allowed: the node's own dir and docs/
GLOBS+=("work/$NODE/**" "docs/**")
DIFF_OUT=$(git diff --name-only "$BASE"...HEAD) || { echo "manifest-check: git diff against $BASE failed" >&2; exit 2; }
FAIL=0
while IFS= read -r file; do
  [[ -z "$file" ]] && continue
  ok=0
  for g in "${GLOBS[@]}"; do
    # shellcheck disable=SC2254
    case "$file" in $g) ok=1; break;; esac
  done
  if [[ $ok -eq 0 ]]; then echo "OUTSIDE MANIFEST: $file" >&2; FAIL=1; fi
done <<< "$DIFF_OUT"
exit $FAIL
```

Note: bash `case` matching treats `**` as `*`; that is acceptable here because manifests are directory-prefix globs (`src/lobby/**`). Document this in the brief template if globs get fancier.

- [ ] **Step 2: Write seed/scripts/rollup.sh**

```bash
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
```

- [ ] **Step 3: Write seed/.github/workflows/gates.yml**

```yaml
name: gates
on:
  pull_request:
    branches: [main]
jobs:
  gates:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - name: Secret scan
        uses: gitleaks/gitleaks-action@v2
        env: { GITHUB_TOKEN: "${{ secrets.GITHUB_TOKEN }}" }
      - name: Project tests + lint
        run: |
          if [[ -x ./scripts/test.sh ]]; then ./scripts/test.sh; else echo "no scripts/test.sh yet (pre-toolchain-spike)"; fi
      - name: Territory manifest check
        run: |
          NODE=$(git log --format=%B "origin/${{ github.base_ref }}..${{ github.event.pull_request.head.sha }}" | grep -oP -m1 '(?<=node: ).*' || true)
          NODE="${NODE#work/}"
          if [[ -z "$NODE" ]]; then
            echo "no node trailer; docs-only PR, skipping manifest check"
          elif [[ ! -f "work/$NODE/brief.md" ]]; then
            echo "node trailer '$NODE' present but work/$NODE/brief.md does not exist" >&2
            exit 1
          else
            bash seed_scripts_path_replaced_at_genesis/manifest-check.sh "$NODE" "origin/${{ github.base_ref }}"
          fi
      - name: Leftover template placeholders
        run: |
          CHANGED=$(git diff --name-only "origin/${{ github.base_ref }}...${{ github.event.pull_request.head.sha }}" -- 'work/**' || true)
          FAIL=0
          for f in $CHANGED; do
            [[ -f "$f" ]] || continue
            if grep -nE '<[A-Z±][^>]*>' "$f"; then echo "UNFILLED PLACEHOLDER in $f" >&2; FAIL=1; fi
          done
          exit $FAIL
```

Genesis (Task 5) rewrites `seed_scripts_path_replaced_at_genesis` to `scripts` when copying into the project repo; conductors put a `node: <node-path>` trailer in their merge commit so CI knows which manifest applies.

- [ ] **Step 4: Verify scripts are valid bash**

Run: `cd /c/code/repos/conducted && bash -n seed/scripts/manifest-check.sh && bash -n seed/scripts/rollup.sh && echo OK`
Expected: `OK`

- [ ] **Step 5: Commit**

```bash
cd /c/code/repos/conducted && git add seed/ && git commit -m "feat(seed): CI gates - manifest check, ledger rollup, gates workflow"
```

---

### Task 5: The `/principal` skill

**Files:**
- Create: `skills/principal/SKILL.md`

**Interfaces:**
- Consumes: seed files by exact path (Tasks 2–4) — the skill locates them via its own base directory's sibling `../../seed/` when run from an installed copy is NOT possible; therefore genesis copies come from `seed/` (hardcoded, stated in the skill; acceptable for a single-user tool).
- Produces: genesis scaffolding + wake behavior other tasks verify; the dispatch-board command format `claude --model opus "/conduct work/<node>"` consumed by Task 6's bootstrap assumptions.

- [ ] **Step 1: Write skills/principal/SKILL.md**

```markdown
---
name: principal
description: Become the Principal Conductor for a conducted-development project — genesis mode on an empty repo (interview the owner, scaffold the seed, land VISION + ROADMAP as the first showcase) or wake mode on an existing one (two-ledger pass, draft briefs, price the menu, emit the dispatch board). Use at the start of any Principal session.
---

# /principal — the Principal Conductor

You are now the **Principal** for this repo. Your identity is the ROLE, not this session: everything
you know must be re-readable from the repo, and everything you decide must land in it. Doctrine is
the repo's `CLAUDE.md` ("conducted development"); the spec of record is Memento lore
`2026-07-18-conducted-development-at-scale-principal-conductors-fleet-validated-spec`.

**Cardinal rules — non-negotiable:**
- You never conduct nodes and never read implementation code. If you are reading source files or
  writing task lists for a node, stop — that is the conductor's plan.md, not yours.
- Every progress judgment you make must cite mechanical repo state (merged commits, PR transitions,
  gate results, status.json), never an agent's prose alone.
- You may use in-session subagents freely for scouting/research (they may die with this session).
  Anything that must outlive this sitting is a peer session the owner ignites from your dispatch board.

## Mode select

If `docs/VISION.md` does not exist → **genesis**. Otherwise → **wake**.

## Genesis (an empty or new repo)

1. Copy the seed from `seed/` into the repo root: `CLAUDE.md`, `.gitignore`,
   `docs/`, `scripts/` (from `seed/scripts/`), `.github/`, `.claude/` — fixing the workflow's script
   path to `scripts/`. Create `work/`, `docs/findings/`, `docs/ledger/`. Commit as `chore: conducted seed`.
2. Interview the owner: ONE question at a time, options preferred (use the question tool when
   available). Cover, in order: what the product is and for whom · what "the grand prize" looks like
   (name the project if unnamed) · the first thing the owner wants to hold in their hands · taste
   anchors (products they admire) · platform constraints they already know · appetite for the first
   leg ("$X to a first playable/usable"). Stop interviewing when you can write a vision the owner
   would recognize as theirs — do not interrogate past usefulness.
3. Draft `docs/VISION.md` (the grand prize, in the owner's language) and `docs/ROADMAP.md` (top-cut
   graph: a small frontier — usually one findings-gated toolchain/platform spike plus 1–2 sketches;
   never a long waterfall). Draft the frontier brief(s) from
   `seed/templates/brief.md`, replacing every `<PLACEHOLDER>`.
4. Land it as the project's FIRST SHOWCASE: a docs-only PR whose description follows the showcase
   template's shape (decisions-first, then the plan tour, then open rulings incl. the appetite
   ruling). The plan is the first product. Loop on the owner's review comments until they approve
   and merge. Record the appetite ruling in `docs/DECISIONS.md`.
5. End with the **dispatch board** (see below) and the GitHub setup reminder from the conducted
   README (bot identity for PR approval) if not yet configured.

## Wake (an existing repo)

Run the ritual IN ORDER, before any judgment:
1. Read `docs/VISION.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `docs/ledger/ROLLUP.md`, and the
   `status: active` findings in `docs/findings/`.
2. `gh pr list --state open` + review-request state; read every `work/*/status.json` on the frontier.
3. **Two-ledger pass.** Task ledger (VISION+ROADMAP): revise only on countersigned deltas or owner
   rulings. Progress ledger, per in-flight node, judged ONLY from mechanical state since last wake
   (commits merged, phases advanced in status.json, gates flipped, PR transitions):
   - advanced → note it. No state change → LOOPING by definition, regardless of any prose; first
     offense = replan with the conductor via a delta; second consecutive = append to Held for Fable.
   - gates cleared? merge-gated → mark ready on the dispatch board; findings-gated with findings
     landed → NOW draft the dependent brief(s), absorbing what was learned; ruling landed → convert
     ruling-gated edges and dispatch.
4. **Rulings hygiene.** Any open ruling with 2+ dependent nodes is BLOCKING — mark it in ROADMAP and
   exclude dependents from the board. Batch everything held-for-owner into the next review session;
   never dribble.
5. **Economics.** Compare spend vs the ruled cap (circuit-breaker: at/over cap → the board contains
   only merge-readiness work). Draft the money line for the next review session: "next gate ≈ $Y"
   as a RANGE from ROLLUP history, confidence-labelled ("low — N<10 closed nodes"), or a priced
   menu if the owner asked "what does $X get me" — menu options trade scope and DoD-expressed
   quality tiers, never gates.
6. **Brief drafting.** New frontier briefs from the template: you set size + predicted spend +
   minimum-viable-appetite (the conductor may adjust ±50% with reasons at countersign; more
   escalates back to you). Territory manifests must not overlap another in-flight node's — if they
   must, the edge is merge-gated, not independent.
7. End with the **dispatch board** and, if this is a review-session wake, the batched showcase queue
   (each: PR link, staleness check — evidence older than 7 days vs main gets a recapture request to
   its conductor before the owner sees it).

## The dispatch board (how every /principal session ends)

    READY TO DISPATCH
      work/<node>   →  claude --model opus "/conduct work/<node>"     (new terminal tab, repo root)
    WAITING          <node> ← <edge-type> on <what>
    HELD FOR OWNER   <batched rulings / showcases>
    HELD FOR FABLE   <queued items>       MONEY: spent $A of cap $B · next gate ≈ $Y

## Held for Fable — when to summon the premium model

Append to ROADMAP's "Held for Fable" when (rubric): initial genesis on a big vision · a change
would RESTRUCTURE the top-cut graph · two findings/nodes contradict each other · a node's second
consecutive stall · owner feedback invalidates a VISION assumption. A Fable session runs this same
skill; it works the queue, rewrites the map, records rulings in DECISIONS, and hands back. Fable
consults on a node may READ that node's code and evaluator transcripts (read-only) and must leave a
falsifiable prediction with a deadline in the node's plan.md.

## Session end

Follow doctrine "Session end": nothing stranded, ROADMAP/DECISIONS current, wake notes written
(landed / in flight / held-for-owner / held-for-fable / next step), Memento journal upserted.
```

- [ ] **Step 2: Verify frontmatter parses (name + description present, closed fence count even)**

Run: `cd /c/code/repos/conducted && awk '/^---$/{c++} END{print c}' skills/principal/SKILL.md`
Expected: `2`

- [ ] **Step 3: Commit**

```bash
cd /c/code/repos/conducted && git add skills/principal/ && git commit -m "feat(skills): /principal - genesis + wake modes"
```

---

### Task 6: The `/conduct` skill

**Files:**
- Create: `skills/conduct/SKILL.md`

**Interfaces:**
- Consumes: brief/showcase/status templates (Task 3 paths), `scripts/manifest-check.sh` + `scripts/rollup.sh` (Task 4, as copied into the project repo by genesis), dispatch command format from Task 5.
- Produces: the conductor behavior contract; the `node: <node-path>` commit trailer CI consumes (Task 4).

- [ ] **Step 1: Write skills/conduct/SKILL.md**

```markdown
---
name: conduct
description: Conduct one node of a conducted-development project end-to-end — worktree bootstrap, scout + proof-of-work countersign, split-or-plan, subagent fleet, fresh-context evaluator, then showcase PR (top-cut) or fold-up (inner node). Argument: the node path, e.g. "work/toolchain-spike".
---

# /conduct <node-path> — the node conductor

You are the **Conductor** for exactly one node. Doctrine: this repo's `CLAUDE.md`. Your context is
for the node's MAP; your fleet's context is for its files. The conductor does not play: subagents do
all implementation; you decompose, dispatch, verify, integrate, and commit.

## 0 · Bootstrap

Read, in order: the brief chain (every `brief.md` from `work/` root down to your node — your scope
can never exceed any ancestor's), your `brief.md`, `docs/DECISIONS.md`, active findings. Then create
your worktree from the branch that contains your brief: top-cut nodes base on origin/main (`git
worktree add .worktrees/<node-slug> -b node/<node-slug> origin/main`); inner nodes base on their
parent's branch (`git worktree add .worktrees/<node-slug> -b node/<node-slug> node/<parent-slug>`) —
a parent that dispatches children (rather than conducting them serially in its own worktree) must
commit its child briefs to its branch first. Work only in your worktree. Update `status.json` phase
as you pass each stage.

## 1 · Scout, then countersign (proof-of-work — no rubber stamps)

Before any planning, verify the brief against reality: read the actual surfaces your manifest names,
run what exists, check the DoD clauses are testable as written. Then append the Countersign block to
`brief.md` (template format) containing EITHER one concrete discrepancy you found and how the brief
should change, OR three specific checks you made that held. A countersign with neither is invalid —
if you genuinely found nothing on a nontrivial brief, say so explicitly in the Countersign block —
your own §5 evaluator must then independently spot-check the brief-vs-reality claims as part of its
probes. Estimate adjustments beyond ±50% escalate to the Principal instead of
countersigning. The original brief sections are IMMUTABLE from this moment; all later changes are
appended Delta blocks (each a stated diff against the original). If a delta would weaken an original
DoD clause or widen scope, it goes UP (parent, or Principal at top cut) before you act on it.

## 2 · Split or plan

Split test: can you hold this whole node's map while your fleet builds it? If yes, write `plan.md`
(territories, wave order, per-task briefs for your fleet). If no: you are now a mini-Principal —
cut child briefs from the template (children strictly partition YOUR scope), and either conduct the
children serially yourself or emit dispatch commands for the owner. Depth ≥3 below top cut requires
a written justification in your plan.md (you are the parent doing the splitting). Before splitting,
consider best-of-N racing instead: N subagent
attempts at the hard part, comparative judging, one merge.

## 3 · Fleet

Dispatch worktree-isolated subagents (default model sonnet; haiku for mechanical work) with
contract-shaped briefs: objective, files to read first, exact interfaces, what NOT to touch, the
finishing gate, "report deviations and failed approaches". One writer per territory — enforce it.
Verify every returned artifact yourself against reality (run it); never accept a report alone.
You are the only one who commits. Commit messages for node work carry the trailer `node: <node-path>`.

## 4 · Gates + adversarial diff review

Before evaluation: full test suite green in the worktree · `bash scripts/manifest-check.sh
<node-path> <base>` (base = origin/main for top-cut nodes, the parent branch for inner nodes) clean ·
run `/code-review` (medium or higher); address or explicitly waive each finding in writing.

## 5 · Evaluation (fresh context — the showcase gate)

Dispatch a FRESH subagent (opus) that has seen none of the implementation conversation. Hard rules,
in its brief verbatim:
- Derive your probe list from `brief.md` (original + deltas) BEFORE looking at any build output or
  evidence the conductor prepared.
- Stand the system up from the node branch as merged against main — not from any prepared state.
- Run at least one negative-path and one off-script probe per DoD clause. Attest explicitly that no
  delta weakens an original DoD clause.
- If the product has a user surface, drive it as a user (black-box), capturing screenshots/video as
  you go; also scrutinize implementation quality separately. Record verdict + probe counts in
  `status.json.evaluator` with a transcript pointer.
A pass with zero probe failures on a nontrivial node is suspicious — say so in the verdict rather
than celebrating. If the evaluator fails you: fix and re-evaluate with a NEW fresh evaluator. Do not
argue with the verdict in the evaluator's session.

## 6 · Close

- **Inner node:** merge to the PARENT's branch (single writer: the parent pulls, you never push over
  siblings), hand your evaluator verdict + status.json up. No showcase.
- **Top-cut node:** fill `showcase.md` (every `<PLACEHOLDER>` replaced; decisions-first; evidence
  from the EVALUATOR, not you; the money line from the Principal's last board). Open the PR to main
  via the bot identity, description = the showcase, commit trailer `node: <node-path>`. Request the
  owner's review. Do not self-merge: gates + owner approval merge it.
- Either way: write `docs/ledger/<node-id>.md` (honest actuals with sources), run
  `bash scripts/rollup.sh`, update `status.json`, then doctrine "Session end" (nothing stranded,
  handoff written, journal upserted).
```

- [ ] **Step 2: Verify frontmatter parses**

Run: `cd /c/code/repos/conducted && awk '/^---$/{c++} END{print c}' skills/conduct/SKILL.md`
Expected: `2`

- [ ] **Step 3: Commit**

```bash
cd /c/code/repos/conducted && git add skills/conduct/ && git commit -m "feat(skills): /conduct - node conductor end to end"
```

---

### Task 7: Evaluator agent template (seed)

**Files:**
- Create: `seed/.claude/agents/evaluator.md`

**Interfaces:**
- Consumes: probe rules from Task 6 §5 (must match verbatim in spirit; this file is the reusable agent definition conductors may dispatch instead of inlining the brief).
- Produces: agent type `evaluator` available in seeded project repos.

- [ ] **Step 1: Write seed/.claude/agents/evaluator.md**

```markdown
---
name: evaluator
description: Fresh-context node evaluator for conducted-development repos. Judges a built node against its countersigned brief with probes derived before seeing any build evidence. Dispatch one per node evaluation; never reuse a session that saw the implementation.
model: opus
tools: Read, Bash, Grep, Glob
---

You are the fresh-context Evaluator for one node. You have not seen the implementation conversation
and you must not ask for it. Sequence is law:
1. Read the node's `brief.md` (original + delta chain) and NOTHING else first. Write your probe
   list now: at least one happy-path, one negative-path, and one off-script probe per DoD clause.
   Attest whether any delta weakens an original DoD clause (weakening = automatic fail, escalate). If the node's Countersign block flagged a nothing-found scout, independently spot-check the brief-vs-reality claims as part of your probes.
2. Stand the system up yourself from the node branch merged against main. If you cannot stand it up
   from repo instructions alone, that is a FINDING, not an obstacle to work around.
3. Execute your probes against the real running thing. If there is a user surface, drive it as a
   user; capture screenshots/video for the showcase evidence.
4. Verdict: pass/fail per DoD clause with proof, probe counts, failures found. Zero probe failures
   on a nontrivial node is itself reportable as suspicious. Your transcript pointer and verdict go
   in `status.json.evaluator`. You judge; you never fix.
```

- [ ] **Step 2: Verify frontmatter has model and tools lines**

Run: `cd /c/code/repos/conducted && grep -c -E '^(model|tools):' seed/.claude/agents/evaluator.md`
Expected: `2`

- [ ] **Step 3: Commit**

```bash
cd /c/code/repos/conducted && git add seed/.claude/agents/ && git commit -m "feat(seed): fresh-context evaluator agent definition"
```

---

### Task 8: Install + genesis smoke test (sandbox)

**Files:**
- Modify: none (verification task; sandbox repo under the session scratchpad)

**Interfaces:**
- Consumes: installer (Task 1), all seed files (Tasks 2–4, 7), `/principal` (Task 5).

- [ ] **Step 1: Install skills**

Run (PowerShell): `cd the conducted repo; ./install.ps1`
Expected: `installed skill: conduct ...` and `installed skill: principal ...` then `done.`

- [ ] **Step 2: Create a sandbox repo**

Run: `mkdir -p "$CLAUDE_SCRATCHPAD/sandbox-genesis" 2>/dev/null; cd "$CLAUDE_SCRATCHPAD/sandbox-genesis" && git init -b main && git commit --allow-empty -m init && echo OK`
(Substitute the session scratchpad path literally if `$CLAUDE_SCRATCHPAD` is unset.)
Expected: `OK`

- [ ] **Step 3: Headless genesis scaffold check**

Run: `cd "<sandbox>" && claude -p --model opus "/principal — genesis mode. The owner is unavailable: perform ONLY step 1 of genesis (copy the seed, create directories, commit), then stop and list created paths." --output-format text`
Expected output mentions: `CLAUDE.md`, `docs/ROADMAP.md`, `docs/DECISIONS.md`, `scripts/manifest-check.sh`, `.github/workflows/gates.yml`, `work/`, and a commit `chore: conducted seed`.

- [ ] **Step 4: Verify the scaffold on disk**

Run: `cd "<sandbox>" && ls CLAUDE.md docs/ROADMAP.md docs/DECISIONS.md scripts/manifest-check.sh .github/workflows/gates.yml && git log --oneline | head -2`
Expected: all five paths listed; top commit is the seed commit.

- [ ] **Step 5: Record result**

Append one line to `docs/STATUS.md` (create if missing): `2026-07-18: genesis smoke test passed in sandbox` — then commit:

```bash
cd /c/code/repos/conducted && git add docs/STATUS.md && git commit -m "test: genesis smoke test passed"
```

---

### Task 9: Conduct smoke test (sandbox, trivial node)

**Files:**
- Modify: `docs/STATUS.md`

**Interfaces:**
- Consumes: sandbox repo from Task 8, `/conduct` (Task 6), evaluator (Task 7), manifest-check (Task 4).

- [ ] **Step 1: Plant a trivial countersigned brief in the sandbox**

In the sandbox repo create `work/hello/brief.md` from the template with: objective "a `hello.txt` at repo root containing exactly `hello, conducted`"; manifest glob `hello.txt`; one DoD clause "hello.txt exists with exact content, verified by `cat`"; size 1; predicted $1–$2; minimum-viable-appetite $0; a filled Countersign block (proof-of-work: three checks). Create `work/hello/status.json` from the template. Commit both.

- [ ] **Step 2: Run the conductor headless**

Run: `cd "<sandbox>" && claude -p --model opus "/conduct work/hello — the brief is already countersigned; skip PR creation (no remote): stop after evaluation and print the evaluator verdict and status.json." --output-format text`
Expected: output shows a worktree/branch created, a fleet or direct subagent producing `hello.txt`, manifest check passing, an evaluator verdict with probes_run ≥ 2, and `status.json` phase `evaluating` or later with `dod[0].passes: true`.

- [ ] **Step 3: Verify mechanically**

Run: `cd "<sandbox>" && git -C .worktrees/hello show node/hello:hello.txt 2>/dev/null || git show node/hello:hello.txt; python -c "import json;d=json.load(open('work/hello/status.json'));print(d['dod'][0]['passes'], d['evaluator']['probes_run'])" 2>/dev/null || cat work/hello/status.json`
Expected: `hello, conducted` and `True` with probes ≥ 2 (or the equivalent visible in the JSON).

- [ ] **Step 4: Record + commit**

Append to STATUS.md: `2026-07-18: conduct smoke test passed (work/hello, evaluator gated)` — commit as in Task 8 Step 5 with message `test: conduct smoke test passed`.

---

### Task 10: Finish line

**Files:**
- Modify: `README.md` (add "Status: pilot-ready" line + pilot next-step)

**Interfaces:**
- Consumes: everything prior.

- [ ] **Step 1: Update README status**

Add under the title: `**Status:** pilot-ready — next step is the genesis session on the game project repo (create empty repo, open terminal, run /principal with model fable).`

- [ ] **Step 2: Final commit + journal**

```bash
cd /c/code/repos/conducted && git add -A && git commit -m "docs: pilot-ready status"
```

Then upsert the Memento session journal (session_log) with: skills built + smoke-tested; next step = the game project's genesis session.

---

## Self-review notes (completed)

- **Spec coverage:** roles/doctrine → Task 2; tree+laws → Tasks 2, 6 §2; scout-proof-of-work + immutable briefs + deltas → Tasks 3, 6 §1; sensors (manifest CI, secret scan, diff review via /code-review, hardened evaluator, probes-first, from-main, two species folded into evaluator brief) → Tasks 4, 6 §4–5, 7; showcase decisions-first + staleness → Tasks 3, 5 wake §7; economics/appetite/menu/circuit-breaker/min-appetite → Tasks 3, 5 §5; ruling-gated edges + batching → Task 5 §4; mechanical stall + held-for-Fable + consult accountability → Task 5 §3, §Held-for-Fable; dispatch board + lifetime rationale → Task 5 §board; bot-identity workaround → Tasks 1 (README), 5 genesis §5; sharded ledger/findings + rollup → Tasks 3, 4. **Deferred by ruling (not gaps):** auditor node cadence, risk-scored auto-merge routing, @claude Action ignition — phase 1.5, after the pilot proves the loop.
- **Placeholder scan:** template `<TOKENS>` are deliberate template content, not plan placeholders; no TBD/TODO in plan steps.
- **Consistency:** node path format `work/<node>`, commit trailer `node: <node-path>`, model strings, and script paths match across Tasks 3–9.
