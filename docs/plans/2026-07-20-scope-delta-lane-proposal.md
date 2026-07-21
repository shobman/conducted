# Proposal: the scope-delta lane (v8 candidate)

**To the Owner, for ruling.** Evidence-driven answer to your 2026-07-20 question: "much of that
scope chatter can happen without me — but auto-widening scope is a smell we need to guard
against; worth understanding how similar projects failed." Two Opus research legs (multi-agent
failure modes; human-org delegation science) inform this. Not law yet; v7 (PR #7) first.

---

## The reframe the evidence demands

**Escalations are two different things, and conducted currently mixes them** (AWS Agentic-AI
Lens, AGENTOPS01-BP02): a **routing escalation** ("this task needs capability/scope outside my
brief") and a **judgment escalation** ("this needs a human's values, stakes tolerance, or
budget"). Mixing them "either sends too many routine tasks to humans (fatigue and bottlenecks)
or too many high-stakes decisions through automated routing (risk)." Your chatter is largely
routing escalations mis-routed to you as if they were judgment ones.

**Both poles of the failure are historically fatal:**
- *Auto-widening scope killed the AutoGPT generation* (no stopping rule, goal drift, cost
  runaway) and is the top measured failure class in the Berkeley MAST taxonomy (FM-1.2 "agents
  overstepping assigned responsibilities", FM-2.3 task derailment, across 1,600 annotated
  traces). Devin's firsthand postmortem (Answer.AI, 3/20 tasks succeeded) found the core defect
  was an agent that "won't stop, won't ask, won't recognize its own blocker."
- *Routing everything to the human is equally fatal*: "Habituation at the Gate" (11,429 reviews,
  400 reviewers) measured approval rates **rising +14.5pp** while per-item inspection effort
  **fell 22%** as agent-PR volume grew — volume converts the reviewer into a rubber stamp,
  specifically for agent output. Your management model ("staff only flag necessary things") is
  passive management-by-exception, which the leadership literature identifies as the failing form
  — *unless* paired with a stated intent and an audit channel, which is what this lane adds.

## The law, in five parts

### 1. Every brief gains an INTENT block (commander's intent)
Purpose (*why this node*), end-state (*what a win looks like, testable*), **bounds as
constraints** (stay two-way-door; blast radius ≤ this node's surface; cost ceiling), and **named
one-way doors** (the things that always route to the owner). This is the positive signal that
makes "no flag" mean "inside stated intent" rather than mere silence. A conductor at its brief's
edge first checks: does the deviation serve the stated end-state within the stated bounds?

### 2. Three-tier decision rights (one Decider per tier — RAPID, not RACI)
| Tier | Delta character | Decider | Owner sees it |
|---|---|---|---|
| Conductor-cleared | Inside brief bounds, reversible, node-local | Conductor | In the showcase's delta ledger; sampled |
| **Principal-absorbed** | Crosses the brief's edge but inside INTENT + bounds; reversible; blast radius ≤ node; cost within the node's complexity-indexed budget | **Principal, without the owner** | Batched to showcase; sampled by risk |
| Owner-required | Any one-way door, any change to what-a-win-is, cross-boundary effect, or budget increase | Owner, synchronously | Interrupt now |

**Reversibility, not size, is the primary gate** (Bezos one-way/two-way doors). A tiny
irreversible delta interrupts; a large reversible one need not.

### 3. Absorption conditions (all must hold — from Cognition + Anthropic + AWS)
- The principal **adds intelligence, not just re-dispatch**: it re-scopes with context the
  conductor lacked. A principal that merely re-issues the brief is ping-pong (the documented
  "polite, expensive, infinite ping-pong" of ownerless handoffs).
- **Writes stay single-threaded** per territory (Cognition: "multi-agent works best when writes
  stay single-threaded and additional agents contribute intelligence rather than actions").
- The **capability gap is right-sized**: the absorber must be materially stronger/more
  context-rich than the escalator (the "smart friend" pattern fails when the gap is too wide or
  absent). Maps onto the v7 sub-agent-models law: conductors opus → principal opus with fable
  consult available.
- The delta stays **within a complexity-indexed effort budget** stated in the brief (Anthropic's
  effort-scaling doctrine); exceeding it converts the escalation to judgment-class.
- Every handoff is a **versioned contract**: task, work completed, artifacts, explicit
  escalation reason + class (routing|judgment). Contracts transfer accountability; their absence
  is what turns handoffs into negotiations.

### 4. The showcase delta-audit ritual (audit theory, anti-rubber-stamp)
- Every showcase carries a **delta ledger**: each delta with tier, class, reason, reversibility,
  cost. The owner **samples** — sample size scales with risk tier, never with volume; one-way
  doors are census by definition (they already interrupted).
- **Tolerable deviation rate**: if sampled deltas show out-of-intent decisions above an agreed
  threshold, the whole node/principal goes to 100% review next cycle — a slipping lane
  re-tightens itself.
- **Active processing**: the sampled deltas are read in full with a recorded verdict — no bulk
  click. This is also what keeps the owner's judgment calibrated (Endsley: full hands-off decays
  the supervisor's ability to spot the ugly truth; intermediate involvement preserves it).
- **Two verdict classes, explicitly separated**: *outside stated bounds* (violation — fix the
  lane) vs *inside intent but I'd have chosen differently* (coach the INTENT block — never
  punished). Without this split, zero-defect culture kills initiative and agents revert to
  referring everything up or hiding deltas (mission-command atrophy).

### 5. Sensors (named in MAST vocabulary, instrumented not vibes)
- **Self-widening pole**: territory touches outside the granted envelope; token/step growth
  without artifact progress (the AutoGPT drift signature); tool outputs unreflected in results
  (spec-gaming / tool-call hacking — verify *intent*-compliance, not just literal boundary
  compliance).
- **Over-escalation pole**: escalation before the retry budget is spent; escalation with no
  attempted resolution; repeat-escalation on the same node → deadlock timer ("a deadlock that
  requires a human to notice lasts until someone notices").
- **Storm counter**: handoffs per node per window without state change → force single-owner
  assignment instead of another round-trip.
- **Silence sensor**: a node that produced deltas and now produces none is ambiguous (solved, or
  gone quiet) — surfaced, not left to be noticed.
- **The owner's own gauges** (the novel one): approval rate trending up while per-item
  inspection time trends down = habituation firing. Correct response: reduce what reaches the
  owner, never accelerate approvals.

## Non-delegable, regardless (all four literatures agree)
One-way doors (pre-fact scrutiny — the audit point is too late by definition). Changes to
what-a-win-is (agents choose *how*, never *what*). Cross-boundary effects (node-local intent
cannot authorize them). And a **live-fire sample floor**: even in a clean lane the owner keeps
reading some deltas in full — not to control those items, but to keep their own judgment from
decaying.

## Adoption path
- **Now, no law change**: INTENT blocks and delta ledgers can enter briefs/showcases immediately
  as practice (the brief template + showcase template in the seed).
- **v8**: the lane as law — decision-rights table, absorption conditions, audit ritual, sensors —
  after v7 (two-lane approval) lands and one leg of field evidence (the companion Desk app's build is
  the natural pilot).
- One honest caveat carried from the research: mapping human-org controls onto AI agents assumes
  agent failure resembles human failure. It partly doesn't — agents fail *confidently* without
  felt hesitation — which argues for weighting the silence/omission sensors heavier than a human
  org would need.
