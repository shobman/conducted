# Contributing to conducted — field notes and the harvest

Conducted's doctrine changes on EVIDENCE, never on taste. Every clause in the seed traces to a
field incident with mechanical receipts. This file defines the one channel evidence travels.

## For outside contributors

- **Mechanical fixes** (seed bugs, script/CI defects, doc typos): plain PRs welcome.
- **Doctrine or process changes:** open an issue shaped like a field note — the header schema
  below: what happened, on which clause, with what mechanical evidence, at what cost. A doctrine
  PR must carry its `docs/MIGRATIONS.md` entry in the same PR, and will be judged on its
  receipts, not its reasoning.
- **Running conducted on your own projects?** The capture-locally rule applies to you too: file
  field notes in your own repo's `docs/field-notes/`, and open an issue here pointing at them —
  that's the harvest signal for repos we don't sweep.

## The rule: capture locally, harvest centrally

**Project sessions never PR this repo.** A session in a conducted project that hits
doctrine-grade evidence files a field note IN ITS OWN REPO at `docs/field-notes/<date>-<slug>.md`
using the seed template (`seed/templates/field-note.md`). The header IS the qualification bar —
it is checkable, not judgeable:

- `evidence:` must carry mechanical pointers (commits, ledger rows, issue/PR ids, workflow runs).
  **No pointers, no note.**
- `verdict:` — `confirms` (a clause held under fire), `contradicts` (a clause failed or misled —
  these get harvest priority), `gap` (no clause covers what happened).
- The trigger is the INCIDENT, never a checklist. "Consider filing a field note" as a session-end
  step is forbidden — a diligent agent prompted for learnings always finds one, and the doctrine
  has the scars to prove it (the game project's evaluation rounds 3–4).

## The harvest (how notes become law)

A Principal session in THIS repo periodically sweeps registered projects' `docs/field-notes/`:
1. `contradicts` first — a confirmed contradiction is the only urgent class.
2. Dedupe across projects: three repos confirming one clause is one doctrine change, not three.
3. Judge `transfer` independently — the filer's judgment is a claim like any other.
4. Land accepted changes as a versioned doctrine bump: seed/skills edits + a MIGRATIONS entry in
   the SAME PR (the contributor rule below). Cite the originating notes as evidence.
5. Rejected or deferred notes get their reason recorded in the harvest PR — findings must not
   evaporate, and neither must their rejections.

## The contributor rule (non-negotiable)

Any change to `seed/` or `skills/` that an adopted repo must react to bumps the doctrine version
and appends a `docs/MIGRATIONS.md` entry in the same PR. Rituals are written idempotently
("ensure X"), and in-flight nodes finish under the law they were countersigned under — a live
node adopts new law only by an explicit owner-ruled delta.

## Worked examples (the bar, demonstrated)

- **the queue app** `docs/notes/2026-07-19-conductor-exit-debrief.md` — an exit debrief whose §2 ritual and
  §3 near-misses became v3's consolidation law. Pre-dated this schema; carries every field of it
  in prose.
- **the booking app** `docs/findings/2026-07-19-fabricated-premise-dev-outage.md` — the observation rule's
  origin: premise verbatim, discovery cost from issue timestamps + workflow runs, a same-session
  A/B, transfer analysis, draft clause. The reference example of `verdict: gap`.
