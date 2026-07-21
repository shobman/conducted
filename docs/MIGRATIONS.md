# Doctrine migrations — the version ledger

Append-only, like DECISIONS. The doctrine evolves; every adopted repo must have a coherent path
from ANY older version to current. This ledger IS that path: the entries after a repo's version,
applied in order, are its migration (see `/principal` → Migrate). Never skip, never reorder.

**Contributor rule (non-negotiable):** any change to `seed/` or `skills/` that an adopted repo
must react to bumps the doctrine version and appends an entry here — in the SAME commit/PR as the
change. A doctrine change without a migration entry strands every live project on an orphan
version.

Entry format: **what changed · why · ritual** (what a migrating Principal does inside the adopted
repo — written as idempotent checks: "ensure X", not "add X", so partially-current repos migrate
cleanly) **· conflicts** (what must go to the owner as a ruling rather than be auto-applied).

---

## Genericization glossary (public export)

Conducted's doctrine is proven on evidence from a private estate. For public release the estate's
identifiers are replaced with story-preserving generic labels — the narratives stay true and
legible, only the private names are removed. The mapping, applied throughout this repo:

| In the field (private) | Public label |
|---|---|
| the first pilot game repo | **the game project** |
| the queue-management app repo | **the queue app** |
| the booking app repo | **the booking app** |
| the companion Desk app / its vault / its infra repo | **the companion Desk app** / **its vault** / **its infra repo** |
| the shared estate auth service | **the shared auth service** |
| an outside contributor's ported portfolio | **an external contributor** / **their fleet** |
| the author bot / the clerk reviewer accounts | read from `docs/BOT.md` at runtime — generic in text |
| the owner's personal handle | **owner/** in examples (the public repo's own clone URL is kept as-is) |
| absolute machine paths (`<drive>:\…`) | repo-relative paths |
| private-repo PR/issue numbers | dropped; RED/GREEN-pair narratives kept, labelled PR-1 / PR-2 |
| personal spend figures | generalized to bands |

The evidence is unchanged; only the labels are. Where a doctrine lesson turned on a fact only the
owner could see, the punchline is generalized (e.g. "a physical-world check that resolved to a
benign external cause") without losing the lesson.

---

## v0 — the pre-versioned prototypes (anything before 2026-07-18)

Not a release. Any repo carrying conducted-style law with **no "Doctrine version" line** is v0:
the pre-genesis prototypes (the queue-app/booking-app class — owner/conductor/fleet roles in
CLAUDE.md, "the conductor does not play", superpowers spec/plan trails) AND early seed copies that
predate versioning (the game-project class). v0 repos vary too much for a scripted ritual, so v0→v1 is
**evidence-based**: scout the repo's actual law, diff it against the current seed, and apply the
Migrate steps — supersede the old doctrine block (never leave two laws readable side by side), map
existing concepts to current ones (specs/plans → briefs/plan.md; existing roadmap/decision files
absorbed, not duplicated; what plays the ledger), and add the version line. The closer the old law
is to the current seed, the smaller the diff — a game-project-class repo may need only the version
line and the v1 ritual below.

**Conflicts to the owner:** any local rule that contradicts current doctrine — e.g. a v0 guarded
self-merge rule vs "conductors commit; only gates merge" — is a batched conflict ruling, never an
auto-overwrite. Local DECISIONS law always survives until the owner rules.

## v1 — 2026-07-18 — versioned baseline

**What changed:** first versioned seed. Genesis/adoption/wake modes; vision lifecycle — VISION.md
must end with a falsifiable "we have won when…" clause; wake gains the empty-frontier →
`achieved-pending-ruling` outcome (inventing work to fill a board is forbidden); owner-ruled
Succession ritual with `docs/visions/` archive; doctrine version line in CLAUDE.md.

**Why:** doctrine now changes over time and completion/succession are real lifecycle states.

**Ritual:** ensure the doctrine block in CLAUDE.md carries `Doctrine version: v1 (2026-07-18)` ·
ensure VISION.md (if present) ends with a "we have won when…" clause — draft it from ROADMAP
evidence and confirm with the owner; the clause is a vision change, so it lands via a docs PR ·
ensure `docs/DECISIONS.md` records the migration as a ruling.

**Conflicts:** the win-condition clause itself (the owner must recognize it as theirs).

## v2 — 2026-07-18 — first field backport (the game project's end-to-end run)

**What changed:** everything in `docs/field-reports/2026-07-18-first-e2e.md`, backported.
Gates workflow: `permissions:` block (gitleaks 403) · trailerless PRs must be docs-only (omitting
the trailer no longer skips the territory gate) · brief existence checked on the base ref ·
non-executable or missing-suite test runs FAIL instead of skipping. `manifest-check.sh` rewritten:
**territory is law as of the base ref** (brief + deltas read via `git show`, never the working
tree; ~150 lines of authority heuristics deleted; Principal law files carved out of node
territory; nodes always own `work/<node>/` + `docs/findings/**` + `docs/ledger/**` — not `docs/**`
wholesale). Brief template: countersign placeholders → "pending" wording (placeholder-gate
contradiction) + new Inherited debt section. Evaluator + `/conduct`: DoD-binary verdicts, advisory
tier with stable EV- ids and sticky severity, committed reports under `work/<node>/evaluations/`,
**stopping rule** — close on two consecutive all-DoD-pass evaluations. `/conduct`: ledger born at
dispatch 1, appended per dispatch. `/principal`: one eval-fail cycle priced into every estimate;
closed nodes' advisory findings folded into next briefs as inherited debt.

**Why:** first real e2e run — three seed self-contradictions failed the project's first docs-only
PR three times; three evaluator defeats of the territory gate; 20–25% of node spend in a
non-terminating hygiene loop over self-authored prose.

**Ritual (idempotent — repos that applied field fixes will mostly no-op):** ensure the gates
workflow has the permissions block, docs-only enforcement on trailerless PRs, base-ref brief
check, and hard-fail on non-executable/missing test suite · ensure `manifest-check.sh` is the
base-ref version (if the repo hand-patched a v0/v1 parser, replace it with the seed's) · ensure
seed-derived scripts carry executable mode bits in the git index (`git ls-files -s scripts/` shows
100755) · ensure the doctrine block states the base-ref territory law and the evaluation stopping
rule · ensure `status.json` templates/live files carry `consecutive_dod_passes` + `reports` ·
ensure open briefs are untouched — in-flight nodes finish under countersigned law (Migrate rule 5);
the stopping rule and debt mechanism apply from the next evaluation/brief forward · bump the
version line.

**Conflicts:** a repo whose local law relied on trailerless PRs skipping the territory gate, or on
`docs/**` being node-writable, must re-rule that explicitly — both were the field exploit surface.

## v3 — 2026-07-19 — tri-project field evidence (the game project's ratchet · the queue app's consolidation · the booking app's premise)

**What changed:** Evaluation stopping rule is now TREE-ANCHORED: passes attach to (clause,
evaluated commit); later commits invalidate only touched clauses' passes; close = every clause
twice-passed on unchanged territory, with a one-full-depth-final-pass exception for fix-dispatch
invalidations; disagreement on unchanged territory = adjudication, never a reset; confirmation
rounds are scoped; evaluator briefs committed pre-dispatch; advisory re-escalation needs NEW
evidence (not necessarily a new diff). NEW: the observation rule (no defect filed / fix dispatched
without a direct observation; non-runnable premises need an independent primary source; blocked
reads escalate; red results are also claims — check causes). Session end gains self-falsification
("attack your own handoff claim"). Consolidation pass is law (seed `docs/CONSOLIDATION.md`; wake
trigger when branches outnumber the frontier). Findings gain `status: lead`. Field-notes channel
(`docs/field-notes/` + seed template; capture locally, harvest centrally — CONTRIBUTING.md).
Adoption gains the memory-drain step + doctrine memory-hygiene line. status.json: per-clause
`passes`, `evaluator.rounds` (with `evaluated_commit`), `evaluator.advisory` resolution tracking,
`gates` block flipped at gate time, `paused`/`abandoned` phases. Showcase gains the tour section.

**Why:** evidence report `docs/field-reports/2026-07-19-v3-evidence.md`. The game project: the v2 counter
reset to zero at 3.39M tokens against a tree 674 lines newer than its last pass — reset-on-any-
fail is a stochastic ratchet, and its "consecutive" passes weren't anchored to any tree. The booking app:
a fabricated premise fix-dispatched with zero observations took a dev environment down for
35 min; the countersign structurally cannot catch mid-execution premises. The queue app: a session's honest handoff
claim was falsified by one category (the consolidation's judgment lived only in the session), and
76→1 branch GC ran with zero doctrine coverage.

**Ritual (idempotent):** ensure the doctrine block carries the tree-anchored stopping rule, the
observation rule, the self-falsification session-end step, the memory-hygiene line, and the
field-notes + consolidation bullets · ensure `docs/CONSOLIDATION.md` and a field-note template
exist · ensure `status.json` templates carry per-clause `passes`, `evaluator.rounds`/`advisory`,
`gates`, and the `paused`/`abandoned` phases (migrate live files: a v2 `consecutive_dod_passes`
value maps to its rounds history; do not invent per-clause history that was never recorded —
start anchoring from the next round) · ensure the evaluator agent file is the v3 text (committed
briefs, evaluated-commit, scoped confirmation) · ensure `docs/field-notes/` exists · in-flight
nodes finish under countersigned law — a live node adopts the v3 stopping rule ONLY by an
explicit owner-ruled delta appended to its brief on the base branch (the game project's vertical-slice
pause is the worked example) · bump the version line LAST.

**Conflicts:** the owner rules on applying the v3 stopping rule to any in-flight node (per-node
delta, never silent) · any local law that treats session memory as project state (the drain
changes the owner's workflow — walk them through it) · any local "always full re-evaluation"
rule vs scoped confirmations.

## v4 — 2026-07-19 — the identity harvest (first harvest of the field-notes channel)

**What changed:** The IDENTITY LAW: the owner's identity carries exactly two things — rulings and
approvals, clicked or typed by the human, never by a session. Every agent session (Principal and
conductor alike) authenticates to GitHub as the bot; all agent speech — commits, branches, PRs,
comments — is bot-authored; agents may quote the owner (with a DECISIONS pointer), never speak as
the owner. TWO MODES, ruled at genesis/adoption and recorded in `docs/BOT.md`: BOT mode
(mechanical merge gate) and SOLO mode (agents act under the owner's credentials by explicit
DECISIONS ruling — the sane default for a first project; all other identity rules still bind,
and every wake board carries "merge gate: ceremonial (solo)"). AUTH PREFLIGHT (hard stop):
before any GitHub write, `gh api user --jq .login` must match the ruled mode — bot mode: the bot
and nothing else; expired/missing/wrong auth is a full stop surfaced to the owner, and falling
back to the owner's credentials is forbidden (a push as the owner is worse than no push); solo
mode: the owner's login is expected; an unruled mode is bot mode. New seed `docs/BOT.md` records
mode + plumbing + PAT expiry; wake gains a mode-aware MERGE-GATE CHECK (bot mode: bot has write,
main requires 1 approval, recent node PRs bot-authored, pat-expires >14 days out — else renewal
on HELD FOR OWNER; an unruled or accidentally-ceremonial gate is a board-blocking fix). Session-end items 1–3 are now
VERIFIED, NOT ASSERTED (`git status --porcelain` / `git ls-remote` per kept branch — committed
alone is not durable / `git worktree list` vs the expected set, outputs quoted in the handoff).
Genesis/adoption point at `ops/setup-project-repo.ps1`; adoption's copy list gains
`docs/CONSOLIDATION.md` + `docs/BOT.md` (v3 omission).

**Why:** three repos, one week — the receipts: the game project
`docs/field-notes/2026-07-19-session-end-asserted-not-verified.md` (18 commits local-only for a
node's entire life; a closed node's worktree mounted across two sessions; both sessions had
"completed" the checklist). The queue app: a conductor hit "open PRs via the bot identity" with zero
mechanics existing anywhere — no auth, no token pattern, no expiry story. The booking app's PR: agent
comments posted under the owner's identity "for the owner" — the one sensor the system cannot
replace (the owner) made forgeable by the party it measures. The stopping-rule rationale from the
game project's pause-debrief ("the incentive runs backwards — doing the right thing cost a round") is
cited here as v3's validating rationale; no law change.

**Ritual (idempotent):** ensure the doctrine block carries the Identity law + preflight · ensure
`docs/BOT.md` exists WITH REAL VALUES (bot login, actual pat-expires date) · ensure both skills'
copies in use carry the preflight and the wake merge-gate check (machine-level skills update via
the conducted installer) · ensure session-end items are the verified forms · run
`ops/setup-project-repo.ps1 -Repo <owner/name>` once (bot collaborator + 1-approval protection) ·
existing PRs/comments authored as the owner are HISTORY — never rewritten; but any owner-attributed
decision that lives only in a PR thread gets landed in DECISIONS with honest attribution ("ruled
in session, recorded late") · bump the version line LAST.

**Conflicts:** the mode itself is an owner ruling — solo vs bot, recorded in DECISIONS and
`docs/BOT.md` (an existing no-bot repo migrating to v4 chooses explicitly; nothing is assumed) ·
repos with a non-main promotion flow (e.g. develop-first) apply the identity law on their
integration branch · in bot mode, the PAT renewal cadence (90 days) is an owner-workflow
commitment — confirm the owner accepts the hard stop when it lapses.

## v5 — 2026-07-19 — external field fixes (an external contributor's port review, the first outside contributor)

**What changed:** TERRITORY GLOB SEMANTICS: `*` matches within one path segment; `**` crosses
segments. The old matcher (bash `case`) let `*` match `/`, so `src/*` silently granted `src/**` —
territory wider than the brief author wrote. `manifest-check.sh` now compiles globs to anchored
regexes (test matrix in the v5 PR). Gates workflow ships with its script path resolved to
`scripts/` at source (the placeholder-rewrite-at-genesis step is gone — same seed-bug class as the
v2 field report). Seed gains `.gitattributes` (`*.sh text eol=lf`) — a CRLF'd gate script dies as
`bad interpreter`, and a gate that doesn't run is a FAIL by doctrine; genesis/adoption copy lists
updated. Doctrine gains the PINNED-INPUTS adoption precondition: if a sibling repo's checked-out
branch can change this repo's build, fix that before adopting — a gate over unpinned inputs
reports green against a build nobody can reproduce. Skills and seed doctrine are now
SELF-CONTAINED LAW — the private spec-of-record pointer is demoted to provenance and no external
note outranks the committed text. The ADVERSARIAL DIFF REVIEW gate is restated as an INVARIANT,
not a tool: a fresh context that never saw the build reviews the diff (`/code-review` where the
session has it, else a dispatched fresh-context reviewer), report committed to
`work/<node>/code-review.md` — a gate bound to user-triggered tooling was unrunnable by the
sessions it binds (the queue app's gates-proof escalation). `docs/field-notes/**` added to the manifest
checker's always-allowed globs — v3 mandated filing field notes while this gate rejected them
(same escalation; every v3+ node hit it). (Also this cycle, outside the seed: the one-time bootstrap
script `ops/setup-github.ps1` was deleted from the conducted repo — its silent public-flip was a
port hazard.)

**Why:** the external port review (2026-07-19, an external contributor's fleet — conducted's first outside
contributor): defeated-glob demonstration confirmed locally within minutes; CRLF gate-death cost
their port a commit; the unresolvable spec-of-record pointer and the placeholder workflow path
were both first-hour port friction; the pinned-inputs line is their addendum's own precondition
sentence, adopted nearly verbatim from a 22-repo portfolio that could not build reproducibly.

**Ritual (idempotent):** ensure `manifest-check.sh` is the v5 regex-based matcher · AUDIT LIVE
BRIEFS for `*` globs written under the old recursive-by-accident semantics — each becomes an
explicit `**` via a Principal-appended Manifest delta + ruling on the base branch BEFORE the new
matcher lands, or the node's next push fails on territory it legitimately holds · ensure the gates
workflow calls `scripts/manifest-check.sh` directly (no placeholder) · ensure `.gitattributes`
carries `*.sh text eol=lf` (append) and re-normalize (`git add --renormalize .`) if any .sh is
CRLF in the index · ensure the doctrine block carries the pinned-inputs precondition and the
self-contained-law wording · bump the version line LAST.

**Conflicts:** any live brief whose author INTENDED recursive `*` (the audit is a per-brief
owner/conductor confirmation, not a mechanical rewrite) · repos whose build inputs cannot yet be
pinned must record that as an explicit accepted-risk ruling in DECISIONS, or defer adoption.

## v6 — 2026-07-19 — gate integrity (contradicts-class only; freeze-compatible)

**What changed:** New doctrine law: **gates never reject what doctrine mandates** — every gate is
checked against the artifacts the doctrine requires committing; a gate that can reject a mandated
artifact is a seed bug (fix the gate, never the artifact). Corollary codified from field behavior:
**the measured party never edits its measurers' artifacts** — a red gate caused by an evaluator's
or reviewer's report is an escalation; leave the PR red. Gate fixes: (1) placeholder scan now
covers ONLY template-derived files (brief/plan/showcase/status/ledger) — measurement documents
(code-review.md, evaluations/*) quote source verbatim and are out of scannable surface entirely,
killing the tampering pressure structurally; regex tightened to `<[A-Z][A-Z0-9_-]+>` (2+ chars,
SCREAMING-CASE — `<T>`, `<Program>`, `List<ServerCandidate>` no longer match; all real template
placeholders still do; fixture-tested both directions; the stray `±` mojibake removed). (2)
Trailerless PRs may now touch root CLAUDE.md (law lands as owner-approved PRs — the game project's ruling
upstreamed) and `work/*/brief.md` (widening deltas MUST land on base; under bot mode the required
owner approval IS the widening ruling). (3) New gate: **bot-mode commit authorship** — mode +
bot-login read from docs/BOT.md ON THE BASE REF; any commit in the PR range not authored by the
bot fails (gh-api preflight measures API identity, not commit authorship; a git merge with the
owner's config slipped five owner-authored commits into a bot-mode node undetected).
`conduct-wrapper.ps1` fixes the cause: bot-mode repos get GIT_AUTHOR/COMMITTER env at session
launch so every git operation is bot-authored, merges included. ops/*.ps1 are ASCII-only and
parse-checked under Windows PowerShell 5.1 (UTF-8-no-BOM em-dashes decoded as cp1252 and died at
parse). Conducted itself gains `selfcheck.yml` CI: gate fixtures both directions, glob fixtures,
ops parse + ASCII checks — the new law made mechanical against this repo's own gates.

**Why:** the queue app's field report 2026-07-19 (work/server-discovery): third instance in one week
of a gate rejecting a doctrine-mandated artifact (v5 fixed field-notes-vs-manifest; a second hit
deltas-vs-trailerless; the third hit generics-vs-placeholder-gate). The instance was a regex; the class
was the law. The conductor's refusal to edit its evaluators' reports to green its own PR
("I'd rather leave the PR red") is the behavior the corollary now requires rather than hopes for.

**Ritual (idempotent):** ensure the doctrine block carries the gates-never-reject law + corollary ·
ensure gates.yml has the scoped placeholder scan + tightened regex, the widened trailerless set,
and the authorship gate · ensure docs/BOT.md `mode:`/`bot-login:` lines are machine-readable (the
authorship gate greps them from base) · bot-mode repos: adopt the wrapper's GIT_* env pattern for
any session launch path that isn't dispatch.ps1 · re-run any showcase PR that was red purely on
measurement-document false positives · bump the version line LAST.

**Conflicts:** owner-authored commits inside an agent PR on a bot-mode repo now FAIL the gate —
where that's intended (owner co-building), the owner rules an explicit waiver per PR or flips the
repo to solo · solo-mode repos: the widened trailerless brief-delta path has no approval gate, so
brief deltas landing trailerless rest on the behavioral no-self-merge rule — owners uncomfortable
with that rule it narrower locally.

## v7 — 2026-07-20 — two-lane approval + dispatch-on-merge (the owner leaves the synchronous path)

**What changed:** New doctrine law: every PR rides exactly ONE of two lanes, derived from its
diff — never from labels or PR text. **Owner lane** (unchanged): showcases, irreversibles,
rulings, and any diff beyond the bookkeeping class — the owner's click stays the only key.
**Bookkeeping lane** (new): a trailerless, bot-authored PR whose entire diff lies inside
`docs/**` minus `docs/VISION.md`, `docs/DECISIONS.md`, `docs/BOT.md` (wake notes, close-outs,
ledger updates, field notes, findings, ROADMAP status) — when gates are green, the new
`bookkeeping-merge` job in gates.yml lands it without owner review. The job runs on
`pull_request_target` (its logic is always the BASE ref's — a PR cannot edit the lane it is
judged by; it executes no PR content), re-derives the class from git objects, waits for the
`gates` check on the exact head SHA, and merges `--match-head-commit` with a credential ONLY the
workflow holds: a dedicated GitHub App (Actions secrets `BOOKKEEPING_APP_ID`/`BOOKKEEPING_APP_KEY`)
listed in branch protection's bypass_pull_request_allowances — an APPROVAL-only bypass; required
status checks still bind server-side, and session tokens gain nothing. Doctrine migrations are
EXPLICITLY not bookkeeping even when docs-only — the version bump touches root CLAUDE.md, outside
the class by construction; migrations keep the owner break-glass path until a
migration-landing-path law exists. Corollary — **dispatch-on-merge**: a bookkeeping merge may
auto-ignite READY board nodes within the ruled cap; the owner's approval click on a showcase IS
the dispatch of what it unblocks. Dispatch board: HELD FOR OWNER is owner-lane only; new
BOOKKEEPING line for red or credential-less lane PRs. ALSO IN v7 (owner ruling 2026-07-20) —
the **sub-agent-models law**: every dispatch uses the CHEAPEST model that can carry the task,
named explicitly on the dispatch (subagents inherit the parent's model — an unstated model is a
decision, not a neutral default). Routing: Principal/brief-shaping/brainstorming → frontier
(fable summoned, opus default) · conductors → opus · fleet subagents → sonnet · mechanical
sweeps → haiku · evaluators → sonnet per round, frontier only for the final top-cut DoD pass.
Fable never does routine implementation. Ledger dispatch entries record the model
(`models:` field in `seed/templates/ledger-entry.md`). Plan of record + enforcement-claims
audit: `docs/plans/2026-07-20-doctrine-v7.md`.

**Why:** the owner-desk discovery, 2026-07-20: all three consumer repos' frontiers were parked on
docs-only wake PRs awaiting owner clicks — the queue app's PR (blocking queue-landing, the owner's own
F1–F6 feedback explicitly ruled "ungated", plus add-media-explore), the game project's PR (blocking
demo-node-2, countersigned with zero work started), the booking app's PR (blocking dev-auth-boot-flap
and with it develop→main promotion). Three of three blockers were bookkeeping; the owner had
become the dispatcher, the ceremony-approver, and the scheduler. Owner ruling R5 (2026-07-20):
v7 lands before the Desk's runner-ignition node — machine auto-merge
becomes legal before a machine performs it. The sub-agent-models law is the owner's 2026-07-20
ruling backed by verified routing economics (explicit role→tier routing
holds ~97% of quality at ~24% of cost; learned routers generalize poorly and were rejected).

**Ritual (idempotent):** ensure the doctrine block carries the two-lane law + dispatch-on-merge
corollary · ensure gates.yml carries the `pull_request_target` trigger + `bookkeeping-merge` job
and the `gates` job is fenced to `pull_request` · OWNER OPT-IN, per repo: create/install the
dedicated GitHub App (contents:write + pull_requests:write), store its id/key as Actions secrets,
and add it to the required-review rule's bypass allowances ONLY (verify required status checks
carry NO bypass actors — a full-ruleset bypass would let the App merge red; never grant it; the
App must be a distinct principal, never the bot account itself, or every session token inherits
the bypass) · unconfigured repos are LEGAL: the job no-ops green and every PR stays owner lane ·
after the migration merges, `gh pr update-branch` (or close/reopen) any parked docs-only PR so it
rides the new lane (stale-snapshot gotcha: re-runs replay old workflows) · ensure the doctrine
block carries the sub-agent-models routing law and the ledger template the `models:` field —
live ledgers record models from the next dispatch forward; never backfill models that were not
recorded · bump the version line LAST.

**Conflicts:** whether `docs/DECISIONS.md` joins the lane (default OUT — rulings are owner
speech; the approving click was the countersign of the quoted ruling) and whether
`docs/ROADMAP.md` stays in it (default IN — Principal-owned status) are owner rulings where
local law differs · repos with a non-main integration branch (develop-first) extend the trigger
by explicit local ruling, per the v4 precedent · solo-mode repos have no bookkeeping lane (the
mode gate requires `mode: bot`) — the owner may keep it that way or upgrade · owners
uncomfortable with auto-ignition rule dispatch-on-merge narrower locally (the corollary is "may
fire", never "must") · a repo whose local law pins different models (e.g. all-frontier fleets)
re-rules that explicitly — the routing table is the default and the owner's spend ruling wins.

## v8 — 2026-07-20 — scope-delta lane + enforcement-claim audit

**What changed:** New doctrine law — the **scope-delta lane** (a new `## Scope deltas` section in
CLAUDE.md). Every escalation NAMES its class: **ROUTING** (capability/scope — resolved in the agent
tier, absorbable by the Principal) vs **JUDGMENT** (values/stakes/budget — the owner, synchronously).
Every brief gains a required **INTENT block** (purpose · testable end-state · bounds-as-constraints ·
named one-way doors · complexity-indexed delta budget) — "no flag means inside stated intent" exists
ONLY where intent is stated; a brief without one has no absorption lane. Three-tier **decision-rights
table** (conductor-cleared / principal-absorbed / owner-required) with **reversibility, not size, as
the primary gate** and one-way doors always interrupting. **Absorption conditions** (ALL must hold:
adds intelligence not re-dispatch · single-threaded writes per territory · right-sized capability gap ·
within the brief's delta budget — exceeding it converts to judgment-class · versioned handoff
contract). **Showcase delta ledger** (every delta: tier · class · decider · reversibility) audited by
the owner via a **risk-scaled SAMPLE** (never volume-scaled; one-way doors are census) with a
**tolerable deviation rate** that flips a slipping node/Principal to 100% review, and **two verdict
classes** kept separate (outside-bounds = violation; inside-intent-but-different-choice = coach the
INTENT, never punished). **Sensors** named (self-widening territory touches; token growth without
artifact progress; escalation-before-retry-budget; repeat-delta same node; handoff-storm counter;
silence sensor; owner-habituation gauges → reduce escalation count, never accelerate approvals).
**Non-delegables** (one-way doors pre-fact · what-a-win-is changes · cross-boundary effects · the
owner's live-fire sample floor). Brief template gains the INTENT skeleton; showcase template gains
the delta-ledger table; `/conduct` names the escalation class and fills the ledger; `/principal`
absorbs routing-class within intent/budget (adds intelligence, delta on the base branch) and parks
judgment-class on HELD FOR OWNER. ALSO in v8 — the **enforcement-claim audit** (the v7-promised
opener): the CLAUDE.md "the gate enforces X" claims were swept against what the gates actually read,
and three overstatements were fixed — (a) "a missing/empty test suite FAILS" reworded (the gate
hard-fails only a non-executable suite; a missing suite is a pre-toolchain grace; emptiness is not
mechanically detected); (b) "a trailerless PR must be docs-only" reworded to the actual
trailerless-legal set (docs/** + root CLAUDE.md + brief deltas, per v6); (c) an honest
mechanical-vs-behavioral split added to the gates list (CI enforces secret scan + test/lint +
territory; adversarial diff review and evaluator verdict are behavioral invariants no gate reads) and
to the repair path (".github/** never node territory" is behavioral — manifest-check hard-excludes
only VISION/ROADMAP/DECISIONS). Plan of record + full audit table:
`docs/plans/2026-07-20-doctrine-v8.md`.

**Why:** the research-backed proposal `docs/plans/2026-07-20-scope-delta-lane-proposal.md`
(owner-accepted 2026-07-20; two Opus research legs — multi-agent failure modes and human-org
delegation science) plus SAME-DAY LIVE RECEIPTS from the companion Desk app's
`work/host-sprint-zero/showcase.md`: the INTENT block + delta ledger were dogfooded successfully the
day they were drafted; the territory gate forced a Principal-granted widening (self-widening
protection, first live receipt); and the permission classifier independently refused a principal's
admin-merge of the owner-lane PR (external confirmation the owner-required tier is real, not
aspirational). The audit is the v7 plan's own commitment applied to the back catalogue.

**Ritual (idempotent):** ensure the doctrine block carries the `## Scope deltas` section (two
classes, INTENT-block requirement, decision-rights table, absorption conditions, delta-ledger audit
ritual, sensors, non-delegables, and the mechanical-vs-behavioral honesty clause) · ensure the brief
template carries the INTENT skeleton and the showcase template the delta-ledger table · ensure both
skills carry the escalation-class handling (conductor names the class + fills the ledger; Principal
absorbs routing-class within intent/budget, judgment-class → HELD FOR OWNER) · ensure the three audit
fixes are present in the gates prose (test-suite wording, trailerless-legal set, the mechanical-vs-
behavioral splits) · in-flight nodes finish under countersigned law — an existing live brief adopts
the INTENT block ONLY by an owner-ruled delta appended on the base branch (never a silent rewrite of
an immutable brief); new briefs get the INTENT block from the template · no gate logic changed, so no
CI/selfcheck step needs updating · bump the version line LAST.

**Conflicts:** the **tolerable deviation rate** threshold and the **live-fire sample floor** size are
owner calibration values — the owner sets them per repo/node (a fresh lane starts tighter) · a repo
whose local law already routes all scope questions to the owner keeps that until the owner rules the
lane in (the lane is permission to absorb, never a mandate) · live briefs written before v8 have no
INTENT block, so they have no absorption lane until the owner appends one as a base-branch delta —
until then every deviation on those nodes escalates, which is the safe default.

## v9 — 2026-07-20 — two-currency budget + observed-not-queried window sensor

**What changed:** The `## Economics` section of CLAUDE.md is rewritten as **two-currency law**. Every
cap and every ledger figure is now LABELLED: **notional** (plan-covered — the 5-hour rolling and
weekly allowance consumed by opus/sonnet/haiku through Claude Code; already paid for; "what I would
have paid") vs **cash** (real money out — fable API tokens plus any pay-as-you-go overflow).
**A node's price is a PAIR, never a single number**; pre-v9 single-number caps are read as NOTIONAL;
**fable time is always cash**. Exhaustion is asymmetric and the difference is the point: notional
exhaustion means **WAIT** (park with a resume timestamp), cash exhaustion means **STOP** and get a
ruling — and spending cash to escape a window wait is forbidden. The per-currency test feeds the v8
absorption law: a delta inside the notional budget that spends unplanned CASH is judgment-class
regardless of size. **Model-tier default (supersedes the v7 routing table's default):**
principal/conductor → **opus** · fleet → sonnet · sweeps → haiku · evaluator → sonnet per round and
**opus** for the final top-cut pass · **fable → owner opt-in ONLY, per invocation, for hard
conceptual work (brainstorming, conceptualising, breaking new ideas into parts, roadmap shaping),
never routine implementation and never long autonomous stretches, recorded in the ledger
(`fable_optin:` → a DECISIONS pointer).** An unstated model remains a decision (subagents inherit).
New **window-sensor law**: the window is **OBSERVED, NEVER QUERIED** — the statusline's
`rate_limits.{five_hour,seven_day}.{used_percentage,resets_at}` is the only automation carrier, it
reports percentages not quotas, it exists only after a session's first API response, and hook
payloads carry no rate-limit fields at all. Sessions persist `{value, observed_at, source,
confidence}`; **absence is a distinct state (`UNKNOWN`) and is NEVER written as 0**; between sessions
readings age forward by deterministic `resets_at` arithmetic; a cheap probe session is the legal way
to refresh before expensive dispatch. Bounded claim, stated in the law: the runner reads the window
when Claude Code reports it, records the reading's AGE, and refuses expensive dispatch when the
reading is missing or stale — it **never** claims to know remaining allowance. **Governor:** dispatch
only while (reading fresh AND above the reserve fraction) AND (cash cap has headroom); on UNKNOWN,
**fail CLOSED for expensive dispatch, OPEN for cheap**; on exhaustion, park with a resume timestamp —
**parked-waiting-for-window is a legal terminal state for a session, not a failure.** The law states
out loud that **the only mechanical cash wall is external** (the plan's `/usage-credits` monthly spend
limit with auto-reload OFF) and that window governance is inherently soft. Four values are **owner
config, never session inference**: reserve fraction · maximum reading staleness · cash ceiling per
period · per-model weekly sub-cap policy (deliberately un-hard-coded — the published docs contradict
themselves on whether the second weekly limit is Opus- or Sonnet-scoped, and the sensor reports one
undifferentiated `seven_day` figure that cannot settle it). Templates: `ledger-entry.md` gains
`window_cost` / `cash_cost` / `fable_optin` / `window_reading` and a two-currency `predicted`;
`status.json` gains `actuals.window_cost_usd` / `actuals.cash_cost_usd` / `actuals.models`, a
null-valued `window_reading` block, and `parked` (`reason` + `resume_after`). `/principal`: the
dispatch board's MONEY line prints BOTH currencies and a new WINDOW line prints the reading with its
AGE (or UNKNOWN), and "Held for Fable" becomes an owner **opt-in queue** where each entry states why
only fable can do it and its estimated cash cost. Plan of record, with the full mechanical-vs-
behavioral audit: `docs/plans/2026-07-20-doctrine-v9.md`.

**Why:** the owner's ruling of 2026-07-20 — Anthropic now bills Fable as paid API tokens, so the
frontier default moved to opus and the single-number budget stopped being honest. **Evidence
integrity note:** this migration was briefed to rest on a field note at
the companion Desk app's `docs/field-notes/2026-07-20-window-sensor-cannot-be-headless.md`, and
its vault's `budgets.yml` already cites that path — but **the file does not exist anywhere in the
estate** (searched by name, directory, and content). Rather than cite an unreadable document, the
sensor clauses were verified against Anthropic's published Claude Code documentation, which confirms
the statusline `rate_limits` payload shape and its subscriber/first-response constraints, confirms
that hook payloads carry no rate-limit data, and confirms the `/usage-credits` spend limit. Two
briefed claims did NOT survive verification unchanged and are recorded weaker in the law: **(a)** "the
statusline does not fire headless" is **UNDOCUMENTED** — the statusline and headless docs are both
silent — so it is carried as a **LEAD**, not a fact, and the doctrine's fail-closed-on-UNKNOWN design
makes being wrong about it cheap; **(b)** "cross-surface consumption is structurally invisible" is
documented only for the `/usage` command (whose figures come from local session history and exclude
other devices and claude.ai), not for the statusline's server-sourced payload — so the law states the
safe form instead: **every reading is an upper bound on headroom, never a measurement of it.**

**Ritual (idempotent):** ensure the doctrine block's `## Economics` section carries the two-currency
law (notional vs cash labels, pre-v9 caps read as notional, asymmetric exhaustion, the ban on
cash-to-escape-a-wait) · ensure it carries the v9 model-tier table and that no older text still names
fable as a default for plan-shaping or "frontier" for the top-cut evaluator pass — the Roles bullets
must point at the table, not restate a superseded one · ensure the sensor clauses are present
INCLUDING the may-claim/may-not-claim boundary and the named LEAD on the headless premise (a repo that
keeps the sensor law but drops the caveat has re-introduced the overclaim v8's audit removed) · ensure
the governor, the external-hard-stop statement, and the four owner-config values are present · ensure
the ledger template carries `window_cost` / `cash_cost` / `models` / `fable_optin` / `window_reading`
and `status.json` the `actuals` currency fields + `window_reading` + `parked` — live ledgers record the
new fields from the next dispatch forward; **never backfill a window reading or a currency split that
was not recorded** (an invented notional/cash split is worse than a missing one) · ensure
`/principal`'s dispatch board prints both MONEY currencies and a WINDOW line with the reading's age ·
OWNER ACTION, once per account, not per repo: set the `/usage-credits` monthly spend limit and turn
auto-reload OFF — this is the only mechanical cash wall and no repo change substitutes for it · OWNER
RULING, per repo: the four config values (reserve fraction, staleness limit, cash ceiling, weekly
sub-cap policy) — a repo with no ruled values has a governor that must ASK, never assume · no gate
logic changed, so no CI/selfcheck step needs updating · bump the version line LAST.

**Conflicts:** the four config values are owner calibration and must never be defaulted by a session —
a session finding none asks for a ruling · **whether notional caps BREAK or merely WARN** is an owner
ruling where local law differs: v9 keeps notional caps as circuit-breakers (they remain a burn-rate
signal and protect a window shared across every repo), but an owner may reasonably rule that only cash
caps break, since a notional cap stops work that costs no money · the **expensive-vs-cheap dispatch
threshold** that the fail-closed/fail-open rule turns on is unruled by design and is the most likely
source of divergent behaviour between sessions until the owner sets it · repos whose local law pins
different models (e.g. all-frontier fleets) re-rule explicitly — the routing table is the default and
the owner's spend ruling wins, exactly as under v7 · the WINDOW is an ESTATE-WIDE resource while
`budgets.yml` scopes are per-repo, so a multi-repo owner should expect the window governor to be
correct globally and the cash caps to be correct locally; reconciling them waits on the (still frozen)
multi-repo extension · if the missing field note is located, the headless premise should be upgraded
from LEAD to confirmed and this entry amended by a follow-up entry, never edited in place.

## v9.1 — 2026-07-20 — the migration landing path (templates in the trailerless lane)

**First patch entry.** The ledger has carried only whole numbers so far; nothing in the contributor
rule requires them, and this change earns a patch rather than a major: it is one pathspec token and
its law text, it removes a prohibition without adding an obligation, and no adopted repo has to
change any artifact it already holds. Read version ordering as `v9 < v9.1 < v10`; a repo on v9
applies this entry and stops. Future doctrine work still bumps the major.

**What changed:** `templates/**` joins the **trailerless-legal set** in the territory gate's
trailerless branch. The pathspec in `seed/.github/workflows/gates.yml` goes from
`-- ':!docs' ':!CLAUDE.md' ':!work/*/brief.md' ':!work/*/*/brief.md'` to
`-- ':!docs' ':!CLAUDE.md' ':!work/*/brief.md' ':!work/*/*/brief.md' ':!templates'`. Nothing else
widens: `.github/**` and `scripts/**` stay outside the lane, and the bookkeeping-merge class is
untouched (`ALLOW='^docs/'` — `templates/**` does not enter it). The doctrine block gains a
**migration landing path** clause stating both the widening and its boundary. Selfcheck gains a
`trailerless lane fixtures` step that builds a scratch repo and runs the gate's literal pathspec
over a fixture population in BOTH directions — `templates/status.json`, `templates/ledger-entry.md`,
`templates/brief.md`, `templates/showcase.md`, `docs/**`, root `CLAUDE.md` and `work/*/brief.md` must
survive the exclusions; `.github/workflows/gates.yml`, `scripts/manifest-check.sh`,
`scripts/rollup.sh`, `work/*/plan.md`, `work/*/showcase.md`, `src/**` and `.claude/agents/**` must
still be rejected — plus a pin that `templates/**` did not leak into the bookkeeping lane.

**Why:** a genuine deadlock, found live rather than reasoned out. Every migration ritual from v7
onward REQUIRES editing templates — v7 adds `models:` to `templates/ledger-entry.md`, v8 the INTENT
skeleton to `templates/brief.md` and the delta-ledger table to `templates/showcase.md`, v9 the
`window_cost`/`cash_cost`/`fable_optin`/`window_reading` fields to `templates/ledger-entry.md` and
the `actuals`/`window_reading`/`parked` blocks to `templates/status.json`. Migrations ride the
trailerless lane (they are not node work; there is no brief on base to give them territory). So
from v7 onward **every doctrine migration was required to commit a file its own territory gate was
required to reject.** Both rules were individually sound and jointly unsatisfiable, which is exactly
the class v6 named a seed bug: *gates never reject what doctrine mandates*. **Field evidence:**
the queue app's Principal hit it during a v6→v9 migration — its migration PR (**PR-1**) went RED on the
territory gate and was unfixable from inside itself (any fix to the gate is `.github/**`, which the same
lane forbids), while a docs-only PR on the same lane (**PR-2**) went GREEN — isolating `templates/**` as the
sole cause. The same collision was waiting, unfired, in the game project and the booking app. This is the
"non-docs migration landing path" queued since v6 and re-deferred at v7 and v8 for want of evidence that
priced it; PR-1/PR-2 are that evidence.

**Why templates and not gates or scripts:** templates are **inert scaffolding** — nothing executes
them, no gate reads them to reach a verdict, and their only consumers are the humans and agents who
copy and fill them in. `.github/workflows/**` and `scripts/**` are the **measuring apparatus**, and
v6's law is that the measured party never edits its measurers' artifacts. A PR able to edit those
could widen the very gate judging it; a PR that edits a template cannot change any verdict about
itself. The narrowest widening that dissolves the deadlock is therefore `templates/**` alone — NOT
`seed/**`, NOT the whole repo root. **The boundary is load-bearing:** a migration whose ritual also
touches gates or scripts (v5's `manifest-check.sh` rewrite, v7's `gates.yml` job) still needs the
owner's admin lane. The gate-repair path is deliberately unchanged, and this entry does not claim to
have fixed it. **Legal is not lane:** `templates/**` becoming trailerless-legal lets a migration go
GREEN; it does not let one merge itself. Migrations remain owner-lane — the version bump touches
root `CLAUDE.md`, outside the bookkeeping class by construction.

**Ritual (idempotent):** ensure `.github/workflows/gates.yml`'s trailerless branch carries
`':!templates'` in its pathspec (and the message text names templates among the legal paths) ·
ensure the doctrine block's territory paragraph lists `templates/**` in the trailerless-legal set
and carries the migration-landing-path clause including the inert-scaffolding-vs-measuring-apparatus
reason and the "legal is not lane" line · ensure the two-lane paragraph no longer says migrations
wait for a migration-landing-path law to exist · repos that carry their own selfcheck-equivalent
gain the both-directions trailerless fixtures; repos without one need no CI change · a repo mid-
migration on a RED PR re-runs its gates AFTER this lands on base (stale-snapshot gotcha: a plain
re-run replays the old workflow — use `gh pr update-branch`, per the RUNBOOK) · bump the version
line LAST.

**Conflicts:** a repo that keeps project source under `templates/` (a template-generator product,
say) must NOT take this widening as written — `templates/**` would then be real territory and the
owner rules a distinct path (e.g. `doctrine-templates/`) rather than granting a source tree the
trailerless lane · a repo whose local law already grants migrations a break-glass admin lane may
keep it; this entry removes the NEED for break-glass on template-only migrations, never the owner's
right to use it · an owner who wants migrations to auto-merge as well as go green is asking for a
different (bookkeeping-lane) change, still unmade and still unpriced — v9.1 deliberately stops at
legality.
## v10 — 2026-07-20 — the owner's attention is the scarce resource

**What changed:** a new `## The owner's attention — the escalation budget (Principal → owner)`
section in CLAUDE.md, sitting beside v8's scope-delta lane and doing at the PRINCIPAL→OWNER boundary
what v8 did at CONDUCTOR→PRINCIPAL. **`HELD FOR OWNER` becomes RESERVED, not default.** Exactly five
classes may be queued to the owner and the list is CLOSED: **irreversibles / one-way doors · value
and taste judgments · money increases and new caps · physical-world or private-knowledge checks
(facts unobservable from the repo) · genuine security or trust-boundary changes** (narrowly: a change
that WIDENS who or what may act without review). **Everything else the Principal decides on its own
judgment and LOGS** — reversibility is the gate, not size or importance, exactly as in v8. The log
reuses v8's delta-ledger shape and v8's sampled-audit machinery one tier up (risk-scaled sample, read
in full, the two verdict classes kept separate, the tolerable deviation rate flipping a slipping
Principal to 100% review) — deliberately NOT a parallel system. Because **a dispatch board is
terminal output, not a committed artifact**, the triage record must be COMMITTED to the wake notes
(`docs/wake/<date>.md`, which already ride the bookkeeping lane and cost the owner no click); the
showcase carries the cycle roll-up in a new template table. **Doctrine defects are never owner
decisions:** a Principal that finds a contradiction in the doctrine files a field note upstream
through the existing harvest channel and applies a logged, reversible local workaround — the owner
cannot rule his way out of a conflict between two of conducted's own gates. **Owner-TUNABLE is not
owner-BLOCKING:** where doctrine flags a value as the owner's to tune, the Principal adopts the
reasoned default, logs it, and keeps working — *a tunable with no default is a stop-work order in
disguise* — and v10 supplies the one that produced the rule: **notional caps WARN, cash caps BREAK**
(v9 left this to a ruling; a breaker on an allowance already paid for halts work that costs no money).
**The board gains a budget of 3 held items** (owner-tunable): over budget forces a RE-TRIAGE BEFORE
EMITTING — but the budget may be met only by absorbing NON-owner-class items, because **owner-class
items are CENSUS**, and **demoting an owner-class item to fit the budget is a violation**.
**Carry-forward expires after 2 wakes** (owner-tunable): a third wake must re-class, decide, or
explicitly abandon with a written reason — a discipline on the Principal, never a deadline on the
owner. **The owner may ignore the board entirely, without penalty:**
parked-because-the-owner-is-living-his-life is a legal, non-degrading state exactly as
parked-waiting-for-window is; nothing may nag, and no work may be marked failed merely because the
owner did not look (pull, not push). **Anti-abdication clause:** the test is **"could ONLY the owner
know or decide this?"** — operationalised as *"is the information needed to decide this OBSERVABLE
FROM THE REPO?"* — and *"would asking be slower"* is explicitly NOT a qualifying reason; deciding an
owner-class item is a **violation**, logged and surfaced as v8 treats acting outside stated bounds;
**in doubt, it is the owner's.** Both poles are measured: an owner queue empty for several wakes on a
moving estate reads as UNDER-escalation, so no Principal can optimise for a score of zero.
`/principal` gains **wake step 7 — triage the owner's queue BEFORE the board is emitted** (classify ·
route doctrine defects upstream · default any unruled tunable · absorb-and-log the rest · apply the
budget · apply the expiry clock · check both poles), a matching doctrine section, and a board that
prints `HELD FOR OWNER <n>/3` with each item's owner-only class named, a `PRINCIPAL DECIDED <m>` line,
and the standing line that the board is a menu, not a demand. Plan of record, with the full
mechanical-vs-behavioral audit: `docs/plans/2026-07-20-doctrine-v10.md`.

**Why:** the owner's ruling of 2026-07-20 — *"yes v10, so I can ignore the principal, and start
over."* The evidence is one board. A **queue-app** Principal wake emitted **SEVEN `HELD FOR OWNER` items
and ZERO ready dispatches**. Triaged afterwards by the owner and the conducted Principal: **one was a
DOCTRINE BUG** — the v7+ migration/templates territory deadlock, blocking the queue app, the game project
AND the booking app, and not a decision at all; **two were rulings with obvious answers the Principal could have reasoned to**
(does a notional cap break or warn — its own money line showed `cash $0` on every row, so the cap was
a breaker wired to the wrong sensor; and "what does the $250 cover" — another project's leg cap,
inherited by confusion); **three were chores and stale carry-forward** (branch deletions, a waiver
question that already carried its own recommendation, items carried across multiple wakes); **one was
a genuine security decision** (install a merge App that bypasses required approval — correctly held).
The seventh was the only truly owner-only item: a physical-world check unobservable from the repo
— and **it resolved to a benign external cause. No defect.** So of seven items ONE needed the owner, and that one turned out
to be nothing, while the frontier sat closed. **A closed frontier alongside a long owner queue is not
a busy estate; it is an over-escalating Principal** — that shape is now named in the law as the
pathology it exists to kill. Note against conducted's own record: item 2 is partly conducted's fault
(the v9 entry lists BREAK-vs-WARN under Conflicts, i.e. doctrine itself called it an owner ruling) —
hence the owner-tunable-is-not-owner-blocking clause; and item 1 is entirely conducted's fault, hence
the doctrine-defects clause. The deadlock's mechanical diagnosis is recorded in the v10 plan doc so
its fix need not rediscover it: an adopted repo receives templates at root `templates/` and scripts at
`scripts/`; the trailerless-legal set is `docs/**` + root `CLAUDE.md` + `work/*/brief.md`; node
territory covers neither — so the v9 ritual's mandated `templates/**` edit has no lane at all.

**Ritual (idempotent):** ensure the doctrine block carries the owner-attention section — the five
owner-only classes as a CLOSED list, the absorb-and-log tier pointing at v8's ledger shape and sampled
audit (never a second system), the committed-triage-record rule with its "the board is ephemeral"
reason, the doctrine-defects-go-upstream clause, the owner-tunable-is-not-owner-blocking clause with
the notional-WARN/cash-BREAK default, the budget with its owner-class-census carve-out, the 2-wake
expiry, the ignore-without-penalty clause, the anti-abdication clause INCLUDING the
observable-from-the-repo test and the explicit non-qualification of "asking would be slower", and both
sensor poles · ensure the section keeps its own mechanical-vs-behavioral audit, whose headline is *no
gate reads a dispatch board* (a repo that keeps the law but drops the audit has re-introduced the
overclaim v8 removed) · ensure `/principal` runs the triage step BEFORE emitting any board, and that
the board prints `HELD FOR OWNER <n>/3` with each item's class · ensure the showcase template carries
the Principal-decisions roll-up table · ensure `docs/wake/<date>.md` exists as the home for the triage
log — it is already bookkeeping-lane, so no gate or lane change is needed · **triage the EXISTING
queue on the first v10 wake**: every currently-held item is re-classed under the admission rule, and
anything that is not owner-class is absorbed, logged with its reversal path, and removed from the
board — this migration's whole value is in that first pass · never backfill a triage log for wakes
that predate v10 (an invented classification is worse than a missing one) · no gate logic changed, so
no CI/selfcheck step needs updating · bump the version line LAST.

**Conflicts:** the two numbers — **board budget (3)** and **carry-forward expiry (2 wakes)** — are
owner calibration, ruled per repo alongside v9's four config values; a repo with ruled values keeps
them, and a session finding none uses the doctrine default and SAYS which it used rather than
inventing a third · the **notional-WARN / cash-BREAK** default reverses what v9 listed as an open
owner ruling, so a repo whose local law already rules notional caps as breakers KEEPS that ruling
until the owner re-rules — v10 changes the default, never a landed ruling · **"genuine security or
trust-boundary change" is the least crisp of the five classes** and the likeliest to be stretched;
the narrowing offered ("it WIDENS who or what may act without review") is itself worth an owner
confirmation · a repo whose local law routes ALL questions to the owner keeps that until the owner
rules the lane in — this law is permission to absorb, never a mandate to · **clause 6 has an accepted
cost:** if the owner may ignore the board indefinitely and nothing may nag, a genuinely owner-class
item can sit forever; v10 accepts this deliberately (the alternative is a nagging system, which the
Desk ruling rejected) and relies on there being so few held items that reading them is cheap · like
v9's window, **attention is ESTATE-WIDE while the budget is per-repo** — three repos each honouring a
budget of 3 present the owner with nine; correct locally, wrong globally, and reconciling it waits on
the (still frozen) multi-repo extension · **the migration/templates deadlock is diagnosed but NOT
fixed here** — v10 rules only how it must be ROUTED (upstream, never to the owner). **It was fixed
upstream, in parallel: v9.1 (the migration landing path) makes `templates/**` trailerless-legal**,
on independent and stronger evidence (the queue app's migration PR — PR-1 in the v9.1 entry — a v6→v9
migration, RED and unfixable from inside itself, beside its docs-only twin (PR-2) GREEN on the same lane —
isolating `templates/**` as the sole cause) and with a distinction v10 did not draw: templates are INERT SCAFFOLDING, while
`.github/workflows/**` and `scripts/**` are the MEASURING APPARATUS and so stay on the owner's admin
lane. v9.1 is therefore the doctrine-defects clause EXECUTED rather than merely illustrated — routed
upstream, fixed on evidence, never queued to the owner. **Ordering:** v9.1 and v10 were drafted in
parallel on branches both cut from v9; apply v9.1 FIRST. A repo migrating from v9 applies both in
that order; a repo already on v9.1 applies only this entry.

**Erratum (v10, no version bump) — the bookkeeping-lane merge mechanism.** The v7 two-lane law and
the seed doctrine originally described the auto-merge landing as *"a dedicated App in Actions
secrets, bypassing the APPROVAL rule alone."* That description is retired: GitHub rulesets do **not**
count App reviews toward a required-approval rule, so an App-approval bypass could never satisfy a
universal review requirement. The implemented and now-documented mechanism is the **clerk-USER
reviewer model**: no credential in the estate can merge without review; a dedicated machine **USER**
(the clerk, whose PAT lives ONLY in Actions secrets, never in a session) records an **APPROVAL
pinned to the exact verified head SHA**, and GitHub's **native auto-merge** then performs the merge
once that approval satisfies the universal review rule. The author bot **must ARM auto-merge** when
it opens the PR — an unarmed bookkeeping PR sits green and unmerged (the missing link found in the
field); neither credential alone lands anything, so a session-held token still merges nothing. This
is a doctrine-text correction to match implemented reality (the enforcement-claim-audit class begun
in v8), not new law — `seed/CLAUDE.md`'s two-lane paragraph and the `gates.yml` comments are updated
to the reviewer model; `gates.yml`'s logic already implemented it.
