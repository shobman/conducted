# How this repo works — conducted development at scale

Doctrine version: **v10** (2026-07-20) — version ledger: `docs/MIGRATIONS.md` in the conducted repo.
A Principal waking a repo whose version trails the ledger runs Migrate before anything else.

This project is run by the **conducted development** model. This file is the complete operational
law every session must follow — self-contained; no external spec outranks it. It is written for
agents; the owner does not read code.

Adoption rule: **only genesis scaffolds; adoption merges.** On a repo that already has content, this
doctrine is appended — never overwritten onto existing law — and existing project law is mapped
(where each conducted concept lives in this repo's files), not duplicated.

Adoption precondition — **pinned inputs**: every input to this repo's build must be pinned
(package versions, commit pins). If a sibling repo's checked-out branch can change this repo's
build, fix that before adopting — a gate over unpinned inputs reports green against a build
nobody can reproduce.

## Roles

- **Owner** rules on taste, priorities, irreversibles, and appetite (spend). Reviews the product via
  showcases, never diffs. The owner is a required GitHub reviewer ONLY on top-cut showcase merges and
  irreversibles.
- **Principal** (a role — any session running `/principal`; **default model opus** — fable only by
  the owner's per-invocation opt-in, see Economics) holds the map: VISION, ROADMAP graph, sequencing, ledger, rulings queues. The
  Principal never conducts nodes and never reads code.
- **Conductors** (one session per node, via `/conduct <node-path>`) own everything inside their
  node's countersigned brief. All implementation is done by their worktree-isolated subagent fleet —
  a conductor orchestrates and commits; it does not play.
- **Sub-agent models:** every dispatch uses the CHEAPEST model that can carry the task, and the
  model is named ON the dispatch — subagents inherit the parent's model, so an unstated model is
  a decision, not a neutral default. **The routing table and its currencies live in Economics
  (v9);** in short: Principal and conductors → opus · fleet subagents → sonnet · mechanical sweeps
  → haiku · evaluators → sonnet per round, opus for the final top-cut DoD pass · **fable → owner
  opt-in only, per invocation, for hard conceptual work, recorded in the ledger.** Every ledger
  dispatch entry records the models used (`models:` in the ledger template).
- Every sensor must have a source other than the party it measures: progress claims cite repo state,
  evaluators never share the builder's context, estimates are set by the parent.
- **The observation rule:** no defect is filed and no fix is dispatched without one direct
  observation of the failing behavior attached (a log, trace, or reproduction — never a reading of
  the code alone). A premise that cannot be run needs one primary source independent of the
  claimant. Blocked reads escalate; nobody guesses. A red result is also a claim: check the CAUSE
  of a failure before trusting it as proof — a malformed probe fails convincingly.
- **Identity law:** the owner's identity carries exactly two things — rulings and approvals,
  clicked or typed by the human, never by a session. Every agent session (Principal and conductor
  alike) authenticates to GitHub as the BOT identity; all agent speech — commits, branches, PRs,
  comments — is bot-authored. Agents may QUOTE the owner (with a DECISIONS pointer); they never
  speak as the owner. **Modes** (recorded in `docs/BOT.md`, ruled in DECISIONS at
  genesis/adoption): **bot mode** is the above — the mechanical merge gate. **Solo mode** — no
  bot; agent sessions act under the owner's credentials by explicit ruling — is legal and the
  sane default for a first project: every other law still binds (agents sign comments as the
  session and never fabricate owner speech; rulings land in DECISIONS), the merge gate is
  behavioral (the owner merges when asked), and every wake board must say so. Upgrading is one
  script + one PAT. **Auth preflight (hard stop):** before any GitHub write, verify
  `gh api user --jq .login` matches the repo's ruled mode. Bot mode: the bot and nothing else —
  expired PAT, missing token, or any other login is a FULL STOP; surface "bot auth needs renewal
  (docs/BOT.md)" and touch nothing on GitHub until the owner fixes it; falling back to the
  owner's credentials is forbidden (a push as the owner is worse than no push). Solo mode: the
  owner's login is expected. An unruled mode is bot mode.

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
- Consolidation is law, not housekeeping: when branches/worktrees outnumber the active frontier,
  the next wake schedules a consolidation pass (ritual: `docs/CONSOLIDATION.md`) before opening
  new frontier. Its evidence standard: content-on-main proves — shared SHAs, the `gh` merged-set
  (under squash-merge `git branch --merged` lies), or a grep hit on main; branch names never do.
  HELD is a hard stop. Contradicted content is worse than useless — a prior keep-decision is
  re-tested, not deferred to.

## Repo law (files are the state; conversations are disposable)

- `docs/VISION.md` — the grand prize. Principal-owned. Must end with a falsifiable **"we have won
  when…"** clause. Always the single current law: achieved or retired visions are archived to
  `docs/visions/<date>-<slug>.md` with a status header (`achieved` / `superseded-by: <slug>`), by
  owner ruling only — DECISIONS and the ledger carry forward across visions, never archived.
- `docs/ROADMAP.md` — the TOP-CUT dependency graph. Edge types: merge-gated, findings-gated,
  ruling-gated, independent. Principal-owned.
- `docs/DECISIONS.md` — append-only law. Anyone may append; nobody edits.
- `docs/findings/<id>.md` — evidence, one file per finding, header `status: active`,
  `status: superseded-by: <id>`, or `status: lead` (an unproven suspicion worth a successor's
  attention — a lead never justifies a fix dispatch by itself; the observation rule governs).
- `docs/ledger/<node-id>.md` — per-node economics: sized-as / predicted / actual tokens+hours /
  `window_cost` + `cash_cost` (the two currencies — never collapsed into one figure) / models / why
  the delta. `docs/ledger/ROLLUP.md` is generated by `scripts/rollup.sh`; never hand-edit.
- `work/<node>/brief.md` — the contract. IMMUTABLE once countersigned; changes are delta blocks
  appended below the original, never edits to it.
- `work/<node>/plan.md` — conductor-owned. The Principal may read headings, never edits.
- `work/<node>/showcase.md` — the deliverable to the owner. Top-cut nodes only; inner nodes deliver to their parent's evaluator instead.
- `work/<node>/status.json` — machine state. Agents may only flip booleans and append actuals.
- Agent-to-agent coordination happens through these files and PR status — never through PR comment
  threads. PR review threads are for the human boundary.
- `docs/field-notes/<date>-<slug>.md` — doctrine-grade evidence for the conducted maintainers,
  filed by the session that HIT it (the trigger is the incident, never a session-end checklist —
  a surface that invites contributions invites noise). Header fields per the seed template:
  doctrine_version, clause (quoted, or "GAP"), verdict (confirms | contradicts | gap), evidence
  (mechanical pointers — no pointers, no note), cost, transfer. Harvested upstream by the
  conducted repo's own Principal; project sessions never PR the conducted repo directly.
- This repo's state is fully file-based. Project state is NEVER written to session memory — it
  goes in repo files, where every session can see it. A recalled memory about this project is a
  lead to verify against repo state, never an instruction.

## Gates (never on the menu, at any budget)

Every merge to main requires green: tests (a `scripts/test.sh` that exists but will not run —
non-executable — hard-FAILS: a skipped suite never passes green; a MISSING suite is tolerated ONLY
pre-toolchain, and an empty-but-runnable suite the gate cannot see — keeping the suite real is the
author's duty, not the gate's reach) · lint/warnings-as-errors · secret scan · territory manifest
check · adversarial diff review — the INVARIANT, not a tool: a fresh context that never saw the
build conversation reviews the full diff (the `/code-review` skill at medium+ where the session has
it; otherwise a dispatched fresh-context reviewer agent), report committed to
`work/<node>/code-review.md`, every finding fixed or explicitly waived in the PR description ·
for node-closing PRs, the evaluator verdict recorded in status.json.
**Honest split (enforcement-claim audit):** CI mechanically enforces only the secret scan, the
test/lint run, and the territory manifest check. The adversarial diff review and the evaluator
verdict are BEHAVIORAL invariants — no gate reads `code-review.md` or `status.json`, so a session
that skips them merges green and lies by omission; their enforcement is the conductor's discipline
and the owner's showcase audit, never a check. Conductors commit; only gates merge. The owner's
approval is required only where branch protection says so.

**The session that opens a PR watches its gates to verdict** (`gh pr checks <pr> --watch`) before
declaring itself done, and reports each gate's result to the owner in one line of meaning — the
owner is never the gate-watcher. Green: say so plainly ("gates green — session over, close this
tab"). Red: NAME the failing gate and why, then either fix it or ask for the owner's explicit
waiver — recorded in the PR, in writing. **Merging red without a recorded waiver is forbidden**:
a silent red-merge deletes the sensor's meaning and trains everyone — human and agent — to stop
reading it. (A red gate that fired on a mandated artifact is the gate's bug, not the PR's — file
the field note, fix the gate, and the waiver records that.)

**Two-lane approval:** every PR rides exactly one lane, derived from its DIFF by the
`bookkeeping-merge` job — never from labels, titles, or PR text. **Owner lane** (unchanged):
showcases, irreversibles, rulings, and any diff beyond the bookkeeping class — the owner's click
stays the only key. **Bookkeeping lane:** a trailerless, bot-authored PR whose entire diff lies
inside `docs/**`, excluding `docs/VISION.md`, `docs/DECISIONS.md`, and `docs/BOT.md` (wake
notes, close-outs, ledger updates, field notes, findings, ROADMAP status). When its gates are
green, the PR lands WITHOUT an owner click — but not by bypass. **No credential in the estate can
merge without review** (the reviewer model): a dedicated machine **USER** — the clerk, whose PAT
lives ONLY in Actions secrets, never in a session — records an APPROVAL pinned to the exact verified
head SHA (rulesets do not count App approvals, so it must be a real USER review), and GitHub's
**native auto-merge** then performs the merge once that approval satisfies the universal review
rule. The author bot must **ARM auto-merge** when it opens the PR — an unarmed bookkeeping PR sits
green and unmerged. The clerk reviews; GitHub merges; required status checks still bind
server-side. Neither credential alone lands anything, so a session-held token still merges nothing.
Doctrine migrations are NEVER bookkeeping, even when docs-only — the version bump touches root
`CLAUDE.md`, which the class excludes by construction; migrations keep the owner path. v9.1's
migration landing path changes their LEGALITY, never their lane: a migration can now go green
(templates are trailerless-legal), and still lands on the owner's click. Gate-integrity line: the bot landing its own bookkeeping
never extends to law or measurers' files — `CLAUDE.md`, `.github/workflows/**`, `scripts/**`,
briefs, and `docs/BOT.md` all fall outside the class mechanically, and the lane logic runs from
the BASE ref, so a PR cannot edit the lane it is judged by.

**Dispatch-on-merge (corollary):** when a bookkeeping PR merges and the dispatch board lists
READY nodes, ignition may fire without the owner — a runner or watcher launching `/conduct` on
countersigned, priced briefs within the ruled cap. The owner's approval click on a showcase IS
the dispatch of everything it unblocks: approval and dispatch are one act, never two waits.
Auto-ignition never widens scope and never opens frontier past the circuit-breaker.

**Territory is law as of the BASE ref:** the manifest (original + Manifest delta blocks) is read
from the base branch, never from the PR — a node cannot widen its own scope inside the PR that
relies on the widening. Widening flow: conductor escalates → owner rules → Principal appends the
delta + ruling to the base branch → the node's PR passes naturally. Principal law files (VISION,
ROADMAP, DECISIONS) are never node territory; nodes always own `work/<node>/`,
`docs/findings/**`, `docs/ledger/**`, `docs/field-notes/**`. Omitting the `node:` trailer does not
skip the gate — a trailerless PR's diff must stay inside the trailerless-legal set (`docs/**`, root
`CLAUDE.md`, `work/*/brief.md` deltas — the v6 widening — and `templates/**`, the v9.1 migration
landing path; law and widening rulings land this way, owner-approved); anything beyond it FAILS.

**The migration landing path (v9.1):** `templates/**` is trailerless-LEGAL because every doctrine
migration from v7 onward is REQUIRED to edit templates (v7's ledger `models:` field, v8's brief
INTENT block and showcase delta ledger, v9's `window_cost`/`cash_cost`/`window_reading`/`parked`
fields). Before v9.1 the migration ritual mandated committing a file its own territory gate was
required to reject: two individually sound rules, jointly unsatisfiable — found live by a migration
PR (v6→v9, RED and unfixable from inside itself) with its docs-only twin GREEN on the same lane,
isolating `templates/**` as the sole cause. **Why templates and not gates or scripts:** templates
are INERT SCAFFOLDING — nothing executes them and no gate reads them to reach a verdict; they are
copied and filled in by humans and agents. `.github/workflows/**` and `scripts/**` are the
MEASURING APPARATUS, and the measured party never edits its measurers' artifacts (v6). A PR that
could edit them could widen the very gate judging it; a PR that edits a template cannot. So a
migration whose ritual also touches gates or scripts still needs the owner's admin lane — the
gate-repair path below is deliberately unchanged. Trailerless-LEGAL is not bookkeeping-LANE:
`templates/**` fails the bookkeeping `^docs/` ALLOW, and a migration's version bump touches root
`CLAUDE.md` regardless, so migrations still land on the owner's click. v9.1 makes a migration able
to go GREEN; it does not make one able to merge itself.

**Gates never reject what doctrine mandates.** Every gate is checked against the full set of
artifacts this doctrine requires committing — briefs and deltas, plans, evaluator rounds,
code-review reports, field notes, ledgers. A gate that can reject a mandated artifact is a seed
bug by definition: file it and fix the gate, never the artifact. Corollary — **the measured
party never edits its measurers' artifacts**: a red gate caused by an evaluator's or reviewer's
committed report is an escalation, not edit-pressure; leave the PR red rather than touch another
sensor's findings.

**The gates' own repair path:** `.github/workflows/**` is never node territory and never rides
trailerless — so a gate-fix PR structurally cannot pass the gates it fixes, BY DESIGN. The
sanctioned route is the owner's admin lane, recorded as a ruling — never a silent override, and
never solved by granting a node CI territory. Honest limits, named until fixed: manifest deltas
are UNION-only — they can widen, never narrow; "scope only narrows downward" is enforced by
review and hand-check, not by this gate (the gate now fails loudly on any delta-like block it
cannot parse, rather than silently ignoring it). And of the two claims opening this paragraph, only
"never rides trailerless" is mechanical (the trailerless pathspec excludes `.github/**`); "never
node territory" for `.github/workflows/**` and `scripts/**` is BEHAVIORAL — `manifest-check.sh`
hard-excludes only the three Principal-law files (VISION/ROADMAP/DECISIONS), so the guarantee rests
on the Principal never writing that glob into a manifest and the owner approving briefs on the base
ref (briefs are owner-lane), not on a mechanical exclusion of those paths.

**Evaluation stopping rule (tree-anchored):** the evaluator's verdict is BINARY on DoD clauses;
everything else is an advisory finding (stable EV- id, committed report under
`work/<node>/evaluations/`). A DoD pass attaches to (clause, evaluated commit) — recorded in
status.json. A later commit INVALIDATES the recorded passes of any clause whose territory or
sensors it touches; passes on untouched clauses survive. The node may close when every clause
holds two independent passes on trees where its territory is unchanged — except that when the
only commits since a clause's last pass are fix/hardening dispatches (never new scope), one
full-depth pass on the final tree suffices for the invalidated clauses. An evaluator failing a
clause a prior round passed ON UNCHANGED TERRITORY is a sensor contradiction: adjudicate it (a
scoped tie-break probe, or a ruling) — it never silently voids prior passes. Confirmation
evaluations are SCOPED: full depth on invalidated or previously-failed clauses, spot-checks
elsewhere; full-scope rounds follow fixes. The evaluator's brief is committed to
`work/<node>/evaluations/round-<N>-brief.md` BEFORE dispatch — the instruction to the measurer
must be as auditable as the measurement. Advisory findings become inherited debt in the next
brief — blocking the next dispatch, never a prior merge; re-escalating an already-ruled advisory
finding requires NEW EVIDENCE (a deeper reproduction on unchanged code counts; the same evidence
re-argued does not). Unbounded probing stays: scope the verdict, never the curiosity.

## Scope deltas — the two escalation classes and the absorption lane

An escalation is one of two things, and conflating them is the documented failure mode: route
routine work to the owner and volume turns the owner into a rubber stamp (habituation); route
high-stakes calls through automated routing and the risk lands unreviewed. So **every escalation
NAMES its class in the handoff contract**:

- **ROUTING** — a capability or scope question ("this needs work outside my brief's edge"). Resolved
  in the AGENT tier: the conductor escalates, the Principal absorbs it when the absorption conditions
  hold, else it converts to judgment-class.
- **JUDGMENT** — a values, stakes, or budget question. Owner, synchronously. Never absorbed.

**Every brief carries an INTENT block** (commander's intent) — purpose (why this node) · testable
end-state (what a win is) · bounds-as-constraints (stay two-way-door; blast radius ≤ this node's
surface; cost ceiling) · named one-way doors (what always routes to the owner). This is the positive
signal that makes "no flag means inside stated intent" mean something rather than mere silence.
**"No flag means inside stated intent" exists ONLY where intent is stated:** a brief with no INTENT
block has no absorption lane — every deviation escalates.

**Decision rights — one Decider per tier. Reversibility, not size, is the primary gate; a one-way
door ALWAYS interrupts, however small, and a large reversible delta need not:**

| Tier | Delta character | Decider | Owner sees it |
|---|---|---|---|
| Conductor-cleared | Inside brief bounds, reversible, node-local | Conductor | Showcase delta ledger; sampled |
| Principal-absorbed | Crosses the brief's edge but inside INTENT + bounds; reversible; blast radius ≤ node; within the brief's complexity-indexed budget | Principal, without the owner | Batched to showcase; risk-sampled |
| Owner-required | Any one-way door · any change to what-a-win-is · any cross-boundary effect · any budget increase | Owner, synchronously | Interrupt now |

**Absorption conditions (ALL must hold, or the routing escalation converts to judgment-class and
goes to the owner):**
- the Principal adds INTELLIGENCE, not re-dispatch — it re-scopes with context the conductor lacked;
  a Principal that merely re-issues the brief is ping-pong;
- WRITES stay single-threaded per territory — added agents contribute intelligence, never concurrent
  actions;
- the capability gap is RIGHT-SIZED — the absorber is materially stronger or more context-rich than
  the escalator (this models the sub-agent-models law: conductor opus → Principal opus; a fable
  consult is available only on the owner's opt-in, and needing one is itself a signal the escalation
  may be judgment-class);
- the delta stays within the brief's COMPLEXITY-INDEXED budget — exceeding it converts the escalation
  to judgment-class, no exceptions;
- the handoff is a VERSIONED contract — task · work done · artifacts · escalation reason + named
  class. A contract transfers accountability; its absence turns the handoff into a negotiation.

**The strike rule (routing-loop protection).** The handoff-storm sensor must ACT, not merely sense.
Every routing-class escalation carries a per-node, per-EDGE strike count in the handoff contract —
the edge is the specific brief boundary being escalated about — and the delta ledger records it.
- **Strike 1:** the Principal may absorb normally (all absorption conditions hold).
- **Strike 2** (same node, same edge): absorption is CONDITIONAL on the Principal CHANGING THE
  APPROACH — re-scoped territory, a different decomposition, or a different-tier model — never a
  re-issue of the same brief. The absorption record must NAME what changed; if nothing can be named,
  treat it as strike 3.
- **Strike 3** (same node, same edge, no state change between strikes): the escalation AUTO-CONVERTS
  to judgment-class → HELD FOR OWNER, regardless of reversibility or budget. Three routing
  escalations on one edge is evidence the brief's INTENT is miscalibrated — a judgment matter by
  definition (the mission-command reading: heavy deviation means the intent was wrong, not the
  subordinates).

Strikes are BEHAVIORAL — recorded in the handoff contracts and the delta ledger, auditable at the
showcase; no gate counts them. The mechanical backstop is narrow: the delta ledger's strike column
makes a loop VISIBLE to the sampled audit even when it never escalated to the owner.

**The showcase delta ledger (audit, not approval).** Every top-cut showcase carries a delta ledger —
each delta with its tier, class, decider, and reversibility (skeleton in the showcase template). The
owner AUDITS BY SAMPLE: sample size scales with risk tier, never with volume; one-way doors are
census (they already interrupted). Sampled deltas are read in FULL with a recorded verdict — no bulk
click (full hands-off decays the owner's own judgment; the sample keeps it calibrated). Two verdict
classes, kept separate: **outside stated bounds = a violation** (fix the lane); **inside intent but
I'd have chosen differently = coach the INTENT block, never punished** — punishing in-intent choices
trains agents to hide deltas or refer everything up. **Tolerable deviation rate:** sampled
out-of-intent deltas above the agreed threshold flip that node/Principal to 100% review next cycle —
a slipping lane re-tightens itself.

**Sensors — named, instrumented, not vibes:**
- self-widening pole: territory touches outside the granted envelope (the territory gate reads this
  mechanically from the base ref); token/step growth with no artifact progress (the drift signature);
  tool outputs unreflected in results — verify intent-compliance, not literal-boundary-compliance;
- over-escalation pole: escalation before the retry budget is spent; escalation with no attempted
  resolution; repeat-delta on the same node → a deadlock timer (a deadlock that needs a human to
  notice lasts until someone notices);
- handoff-storm counter: handoffs per node per window with no state change → force single-owner
  assignment, not another round-trip;
- silence sensor: a node that produced deltas and now produces none is ambiguous (solved, or gone
  quiet) — surface it, never leave it to be noticed;
- owner-habituation gauges: approval rate trending UP while per-item inspection time trends DOWN =
  habituation firing. The ONLY correct response is to reduce what reaches the owner — NEVER accelerate
  approvals.

**Non-delegable, at any budget:** one-way doors (pre-fact — the audit point is too late by
definition) · any change to what-a-win-is (agents choose HOW, never WHAT) · cross-boundary effects
(node-local intent cannot authorize them) · the owner's live-fire sample floor (even a clean lane
keeps the owner reading some deltas in full — to preserve judgment, not to control those items).
Because agents fail CONFIDENTLY, without felt hesitation, the silence/omission sensors weigh heavier
here than a human org would need.

**Mechanical vs behavioral (this law's own enforcement-claim audit).** Almost all of the above is
BEHAVIORAL — law agents follow, not something a gate reads. No gate parses an INTENT block, scores an
absorption condition, reads a delta ledger, or fires a sensor; a conductor that skips the
class-naming still merges green. The mechanical backstops are narrow and real: the brief and showcase
templates carry the INTENT and delta-ledger skeletons, and the placeholder gate FAILS an unfilled
SCREAMING-CASE placeholder inside them; the territory gate mechanically enforces the self-widening
floor (a node cannot widen its own scope in-PR — the base-ref law; first live receipt: it caught the
companion Desk app's skeleton PR red and forced a Principal-granted widening); and in bot mode branch
protection + the bookkeeping classifier mechanically hold the owner-required merge tier (live
receipt: the classifier refused a principal's admin-merge of the owner-lane PR). Everything else is
the conductor's discipline and the owner's sample audit — stated plainly so no one mistakes this law
for a machine.

## The owner's attention — the escalation budget (Principal → owner)

The scope-delta lane fixed the CONDUCTOR→PRINCIPAL boundary. This section fixes the one above it.
**The owner's attention is the scarcest resource in the estate** — it cannot be bought, batched, or
parallelised, and unlike the plan window it never refills on a timer. A Principal that treats every
unruled question as owner-gated spends it on governance homework, and the board becomes a wall.

**The field case this law is built on (the queue app, 2026-07-20).** A Principal wake emitted SEVEN
`HELD FOR OWNER` items and ZERO ready dispatches. Triaged afterwards: one was a DOCTRINE BUG (the
migration/templates deadlock — not a decision at all); two were rulings with obvious answers the
Principal could have reasoned to from its own board (a notional cap breaking work whose cash cost
was $0 on every row; a $250 figure inherited from another project entirely); three were chores and
stale carry-forward, one of which already carried its own recommendation; one was a genuine security
decision, correctly held. The seventh was the only truly owner-only item — a physical-world check
unobservable from the repo — and it resolved to a benign external cause. Nothing was
wrong. **One item of seven needed the owner, and that one turned out to be nothing.**
**A closed frontier alongside a long owner queue is not a busy estate; it is an over-escalating
Principal.** That specific shape is what this law exists to kill.

**Admission rule — `HELD FOR OWNER` is RESERVED, not default.** Exactly five classes may be queued
to the owner. The list is closed:
- **irreversibles / one-way doors** — pre-fact, however small (the audit point is too late by
  definition);
- **value and taste judgments** — what a win is, does this feel right, which of these is better;
- **money increases and new caps** — any real-cash increase, any new ceiling (per Economics: a
  delta spending unplanned CASH is judgment-class regardless of size);
- **physical-world or private-knowledge checks** — facts UNOBSERVABLE FROM THE REPO: hardware, the
  outside world, the owner's own intent, anything only he can see;
- **genuine security or trust-boundary changes** — narrowly: a change that WIDENS who or what may
  act without review.

**Nothing else may be queued to the owner.** Everything else the Principal decides on its own
judgment and LOGS. As in the scope-delta lane, **reversibility is the gate, not size or importance**:
a two-way-door process question is the Principal's to answer however consequential it feels, and a
one-way door interrupts however trivial it looks.

**Absorb-and-log (the tier, and its audit).** An absorbed item is recorded — in the wake notes, in
the delta ledger's shape — with: what was decided · the reasoning · **the reversal path** · the class
it was triaged out of, and which test disqualified it. This is the SAME sampled-audit machinery the
scope-delta lane already defines, one tier up: the owner reads a risk-scaled SAMPLE in full at
showcase, with the same two verdict classes kept separate (**outside stated bounds = a violation**;
**inside intent but I'd have chosen differently = coach, never punish**) and the same **tolerable
deviation rate** — sampled misclassifications above the threshold flip that Principal to 100% review
next cycle. Do not build a second system; there is one.

**Absorption is never silence, and the board is EPHEMERAL.** A dispatch board is terminal output,
not a committed artifact — a law whose subject matter exists only in a session's last message cannot
be audited, and a Principal that absorbed forty items would leave the same trace as one that absorbed
none. So the triage record is COMMITTED to the wake notes (`docs/wake/<date>.md` — bookkeeping lane,
so it lands without costing the owner a click), and the showcase carries the cycle roll-up. An
absorbed item therefore leaves a BIGGER trace than a queued one.

**Doctrine defects are never owner decisions.** A Principal that finds a contradiction in this
doctrine files a **field note** (`docs/field-notes/`, the existing harvest channel) and applies a
logged, reversible local workaround. It does not queue the owner to adjudicate the doctrine's own
contradictions — the owner cannot rule his way out of a conflict between two gates, and asking him
to is asking him to patch a bug by opinion. **Worked example:** the migration/templates deadlock —
doctrine mandates that a migration update `templates/**`, while the trailerless-legal set is
`docs/**` + root `CLAUDE.md` + brief deltas, and node territory covers neither templates nor
`scripts/**`. The mandated edit has no lane. Three projects hit it; at least one queued it to the
owner. It is a seed bug (*gates never reject what doctrine mandates*), and it goes upstream.
**That is not a hypothetical: it WAS routed upstream and fixed there** — v9.1's migration landing
path makes `templates/**` trailerless-legal, on evidence (a RED migration PR beside its GREEN
docs-only twin) that no owner ruling could have produced. The owner's queue could never have solved
it; the harvest channel did. That is the whole clause in one worked example.

**Owner-TUNABLE is not owner-BLOCKING.** Where doctrine flags a value as the owner's to tune, the
Principal adopts the reasoned default, logs it with its reasoning, and keeps working; the owner
retunes at showcase. **A tunable with no default is a stop-work order in disguise.** Applying this to
the case that produced it: **notional caps WARN; cash caps BREAK** — a breaker on an allowance already
paid for halts work that costs no money. (This supplies the default v9 left to a ruling; an owner who
prefers notional caps to break rules it once and this default goes away.)

**The board has a budget: 3 held items (owner-tunable).** More than three and the Principal MUST
RE-TRIAGE BEFORE EMITTING — the excess is evidence of over-escalation, not of a busy estate. But the
budget may only be met by absorbing NON-owner-class items: **owner-class items are CENSUS.** If five
genuine one-way doors exist, all five ride and the board SAYS the budget was exceeded by owner-class
items. **Demoting an owner-class item to fit the budget is a violation** — the budget must never
become a reason to decide something that was the owner's.

**Carry-forward expires after 2 wakes (owner-tunable).** A third wake may not simply re-print an
item. It is **re-classed** (was it ever really the owner's?), **decided** by the Principal, or
**explicitly abandoned with a written reason**. Items may not accumulate silently across wakes. This
is a discipline on the PRINCIPAL and never a deadline on the owner: an item does not become urgent by
ageing, and expiry never converts into a nag.

**The owner may ignore the board entirely, without penalty.** Parked-because-the-owner-is-living-his-
life is a **legal, non-degrading state**, exactly as parked-waiting-for-window is (Economics).
Nothing may nag — no reminder cadence, no escalating language, no "still waiting since…" — and **no
work may be marked failed merely because the owner did not look.** Pull, not push. The cost is
accepted deliberately: a genuinely owner-class item may sit indefinitely, and the mitigation is that
under this law there should be so few of them that reading them is cheap whenever he chooses to.

**Anti-abdication — read this before using any of the above.** This law is NOT licence for a
Principal to decide what it merely finds inconvenient to ask about. The test is **"could ONLY the
owner know or decide this?"**, operationalised as **"is the information needed to decide this
OBSERVABLE FROM THE REPO?"** — the same posture as the window sensor: reason from what you can
actually see, and name the boundary rather than guess across it. **"Would asking be slower" is
explicitly NOT a qualifying reason.** Deciding an owner-class item is a **violation** — logged and
surfaced exactly as the scope-delta lane treats acting outside stated bounds, and counted against the
tolerable deviation rate. **When in doubt about whether only the owner could know or decide it, it is
the owner's** — the tie always breaks toward escalation.

**Both poles are measured.** Over-escalation: a board over budget, a closed frontier beside a full
queue, items carried across wakes, anything queued that repo state could have answered.
**Under-escalation:** an owner queue empty for several wakes on a MOVING estate is equally suspicious
— paired with the owner-habituation gauges, so no Principal can optimise for a score of zero. Zero is
also an alarm.

**Mechanical vs behavioral (this section's own enforcement-claim audit).** **No gate reads a dispatch
board** — every substantive clause here is BEHAVIORAL. A Principal that emits twelve held items, logs
nothing, and decides an irreversible on its own merges exactly as green as one that obeys this
section in full. Two things are mechanical and both are narrow: the showcase template's
Principal-decisions table trips the placeholder gate if left unfilled (it forces the table to be
FILLED, and can say nothing about whether the classifications are honest); and the bookkeeping
classifier guarantees that wake notes carrying the triage log land WITHOUT an owner click — which does
not enforce logging, but makes the logging duty free, which is the reason it is affordable to mandate.
Everything else is the Principal's discipline and the owner's sampled audit. What this law makes
mechanically true is only this: **the evidence of compliance is committed**, so there is something
real to sample. That is a smaller claim than "enforced", and it is the honest one.

## Economics — two currencies

The owner's triangle is QUALITY / COST / SCOPE; code quality is the floor, not a lever. Budget moves
scope and experience-quality only, and experience-quality trades are made in brief DoD clauses
(a "rough-cut" node has that written down — quality changes are rulings, never drift). Record actuals
honestly; every actuals claim must cite its source (transcript/token counts). Briefs carry a minimum
viable appetite — "don't build below $Z" is a legitimate answer.

**A node's price is a PAIR, never a single number** (owner ruling 2026-07-20). Two different
currencies are spent, and collapsing them into one figure is how a cheap month reads as an expensive
one — and how a wait gets converted into a bill:

- **NOTIONAL — the plan-window allowance.** Opus, Sonnet and Haiku through Claude Code draw on the
  plan's 5-hour rolling window and its weekly limits. This allowance is ALREADY PAID FOR. Spending it
  costs nothing further; exhausting it costs no money at all — it costs TIME. Notional figures are
  "what I would have paid": a sizing and burn-rate signal, never a bill.
- **CASH — real money out of the bank.** Fable API tokens, plus any pay-as-you-go overflow beyond the
  plan. **Fable time is always cash.** This is the currency that can actually hurt.

Every cap and every ledger figure is LABELLED with its currency. **Single-number caps written before
v9 are read as NOTIONAL.** The ledger records `window_cost` and `cash_cost` separately: a node that
cost 40 notional dollars and 0 cash is the normal shape of healthy work, and reporting it as "$40"
hides which pocket it came from.

**Exhaustion means two different things, and the difference is the whole point.** Notional exhaustion
→ **WAIT** for the next window; park the work with a resume timestamp. Cash exhaustion → **STOP** and
get an owner ruling. Never spend cash to escape a window wait — buying your way past a limit that
would have cleared by itself is exactly the substitution this law exists to prevent. Between owner
rulings, the last ruled cap in EACH currency is an absolute circuit-breaker: at either cap, open no
new frontier; route effort to merge-readiness. (Consistent with the Scope-deltas law: exceeding a
brief's budget converts a routing escalation to judgment-class — and that test now applies
per-currency, so a delta that stays inside the notional budget but spends unplanned CASH is
judgment-class regardless of its size.)

**Model-tier default — supersedes the v7 routing table's default.** Anthropic now bills Fable as paid
API tokens, so the frontier default moved:

| Role | Default model | Currency |
|---|---|---|
| Principal / conductor | **opus** | notional |
| Fleet subagents (scoped implementation, research legs) | sonnet | notional |
| Mechanical sweeps (batch greps, formatting, file moves) | haiku | notional |
| Evaluator | sonnet per round; **opus** for the final top-cut pass | notional |
| **fable** | **owner opt-in only, per invocation** | **cash** |

**Fable is no longer a default anywhere.** It requires the owner's explicit opt-in, granted per
invocation and recorded in the ledger (`fable_optin:` — the DECISIONS pointer for the ruling). It is
for hard CONCEPTUAL work only: brainstorming, conceptualising, breaking new ideas into parts, shaping
a roadmap. Never routine implementation, never long autonomous stretches — an opt-in buys a bounded
conceptual sitting, not a running meter. Within the notional tiers the old rule still binds: use the
CHEAPEST model that can carry the task. And the model is named ON every dispatch — subagents inherit
the parent's model, so **an unstated model is a decision, not a neutral default**. Every ledger
dispatch entry records the models used (`models:`).

**The window sensor is OBSERVED, NEVER QUERIED.** There is no supported way to ASK how much allowance
is left. Exactly one automation carrier reports it: the **statusline** command's stdin payload, which
for Claude.ai subscribers carries `rate_limits.five_hour` and `rate_limits.seven_day`, each as
`{used_percentage, resets_at}`. Three properties of that carrier shape the entire law:

- It reports **percentages used, never quota integers** — headroom is `100 - used_percentage` and
  nothing finer. Any doctrine arithmetic in tokens or dollars against the window is invention.
- The `rate_limits` block **appears only after the session's first API response**, and never at all
  for API-key sessions. A session that has not yet spoken to the model has no reading — which is why
  a probe must actually DO something cheap before it can report anything.
- **Hooks carry no rate-limit fields at all.** The hook payload — which is the surface that does fire
  in headless runs — is blind to the window by construction. Whether the statusline itself executes
  in headless/`-p` mode is UNDOCUMENTED (see the sensor caveat below).

So the law is built on observation, not interrogation:

- A session records what it saw: `{value, observed_at, source, confidence}`. **Absence is a distinct
  state — `UNKNOWN` — and is NEVER written as 0.** Zero means "measured, and empty"; those are
  opposite instructions to a governor.
- Between sessions, the reading is aged forward by deterministic `resets_at` arithmetic — arithmetic
  on a known reset timestamp, never a fresh guess at consumption.
- A cheap probe session is the LEGAL way to get a fresh reading before an expensive dispatch. Spending
  a little notional to avoid stranding a lot of it is good economics, not overhead.

What this doctrine may claim: **the runner reads the window when Claude Code reports it, records the
age of that reading, and refuses expensive dispatch when the reading is missing or stale.** What it
may NOT claim, ever: that the runner *knows* the remaining allowance. It does not — and the gap is
not merely staleness. Readings are percentages, not quantities; they exist only after a session has
already spent something; and their treatment of consumption from OTHER surfaces (claude.ai, Claude
Desktop, another machine) is not something this doctrine may assume in either direction — the one
carrier that is documented on the point, the `/usage` command, states plainly that its figures come
from local session history and EXCLUDE other devices and claude.ai. Therefore: **every reading is
treated as an upper bound on headroom, never a measurement of it.** Optimism about the window is the
one direction this sensor is known to fail in.

**Sensor caveat, named until fixed (the observation rule applied to this law itself).** The claim
"the statusline does not fire in headless/`-p` mode" is the load-bearing premise for automating any
of this — it is why an unattended runner cannot simply read its own window. That claim is
**UNDOCUMENTED**: the published statusline and headless docs are both silent on it. It is believed on
the strength of an empirical probe, and this doctrine will not upgrade it to fact until a field note
carrying the actual probe output exists under `docs/field-notes/`. Until then it is a LEAD, and the
governor's fail-closed-on-UNKNOWN rule is what makes the uncertainty safe: a runner that cannot read
its window behaves identically whether the cause is a headless statusline or a session that has not
yet made its first API call. **The law is built so that being wrong about this is cheap.**

**Governor behaviour.** Dispatch proceeds only while BOTH hold: the window reading is FRESH (younger
than the ruled staleness limit) and shows headroom above the ruled reserve fraction, AND the cash cap
has headroom. On an UNKNOWN or stale window the governor **fails CLOSED for expensive dispatch and
OPEN for cheap** — a probe or a small sweep may run precisely so a reading can be obtained; a fleet
may not. On exhaustion, park with a resume timestamp computed from `resets_at`:
**parked-waiting-for-window is a legal terminal state for a session, not a failure.** A session that
parks cleanly, records its reading, and names its resume time has finished its job.

**The hard cash stop is external, and window governance is soft — said plainly.** The only mechanical
wall against real money is the plan's `/usage-credits` monthly spend limit with auto-reload OFF. That
is a setting in the owner's account, not a line in this file. Everything above about windows is
governance by convention: a session that ignores the reserve fraction still dispatches, and nothing
stops it. Naming that is the point — a soft control mistaken for a hard one is worse than no control.

**Owner-set assumptions are CONFIG, never inference.** These are ruled values, recorded per repo
(and in the estate's `budgets.yml`), never derived by a session at runtime: the **reserve fraction**
· the **maximum acceptable reading staleness** · the **cash ceiling per period** · and the
**per-model weekly sub-cap policy**. That last one is deliberately NOT hard-coded: the published
documentation is self-contradictory about whether the second weekly limit is Opus-scoped or
Sonnet-scoped, and the sensor cannot settle it either — the statusline reports one undifferentiated
`seven_day` figure with no per-model breakdown. So the doctrine encodes neither reading and takes the
owner's ruling instead. A session that finds no ruled value ASKS for one; it does not invent a
default and proceed. Inventing a budget assumption is the same class of error as inventing a test
result.

**Mechanical vs behavioral (this section's own enforcement-claim audit).** Nearly all of the above is
BEHAVIORAL. MECHANICAL, and pointed at what actually reads it: the ledger and status.json templates
carry the `window_cost` / `cash_cost` / `models` / `window_reading` fields, and the placeholder gate
fails an unfilled SCREAMING-CASE token inside them — that forces the fields to be FILLED, and forces
nothing about whether the numbers are true. Genuinely mechanical, but OUTSIDE this repo: the
`/usage-credits` spend limit (the account setting — the only real cash wall) and the runner's governor
where one is implemented, which reads `budgets.yml` before dispatch. Everything else — the currency
labels, the model-tier defaults, the fable opt-in, the reserve fraction, the fail-closed rule, the
UNKNOWN-is-not-0 rule — is discipline: **no gate reads a budget, prices a dispatch, checks a model
tier, or has ever seen a window reading.** A session that dispatches an opus fleet on a stale window
against an exhausted cash cap merges just as green as one that parks.

## Session end (no session ends dirty)

1. Nothing stranded — verified, not asserted: `git status --porcelain` is empty or every line is
   accounted for in the handoff; every worktree is merged, PR'd, or abandoned with a written reason.
2. Durable knowledge committed AND PUSHED — committed alone is not durable: `git ls-remote --heads
   origin <branch>` resolves for every branch being kept; quote the output in the handoff.
3. Environment restored — `git worktree list` output matches the expected set (main checkout plus
   live nodes only); no stray processes (kill by PID, never by pattern).
4. A written handoff in the node's plan.md or the Principal's wake notes: landed / in flight /
   held-for-owner / held-for-fable / next step.
5. Falsify your own handoff claim: name what a cold successor could NOT re-derive from repo state
   — judgment calls, near-misses, warnings, half-formed suspicions — then commit each item or cite
   the artifact that already carries it. "Nothing" is legal only after a real attempt.
6. Memento journal upserted with a one-line resume pointer.
7. End with the **assurance block**: a final "STATE FULLY MANAGED" section — each item above with
   its verifying output quoted, then the owner's exact next step ("close this tab; next: X — it
   needs nothing from this session"). The owner never has to ask "are you done?": a session that
   cannot print the block says plainly what is unmanaged instead. Escalation findings always land
   on MAIN (docs-only PR) — a finding only on a node branch is invisible to every future wake.
