# Showcase: <NODE-PATH>

quality-tier-built-to: <FULL-POLISH | ROUGH-CUT>
evidence-captured: <DATE> against main @ <SHA>   <!-- staleness SLA: recapture if stale vs main -->

## Decisions made on your behalf (read first)
- <DECISION-AND-WHY> (delta ref: <NONE-OR-DELTA-ID>)

## Delta ledger (every deviation; the owner audits by risk-scaled SAMPLE — one-way doors are census)
| Delta | Tier | Class | Decider | Reversibility | Strike (routing edge) |
|---|---|---|---|---|---|
| <WHAT-DEVIATED> | conductor-cleared \| principal-absorbed \| owner-required | routing \| judgment | <WHO-DECIDED> | two-way \| ONE-WAY | <EDGE-N-OR-na> (routing only; n=2 names what changed; n=3 auto-converts to owner) |

Violations of stated bounds: <NONE-OR-LIST>.

## Principal decisions absorbed from the owner's queue (v10 — same ledger shape, same sampled audit)
<!-- Candidates triaged OUT of HELD FOR OWNER this cycle. The durable per-wake record lives in
     docs/wake/<date>.md; this is the roll-up the owner samples. Sampling rule is unchanged: risk-
     scaled sample, read in full, two verdict classes (outside bounds = violation; in-intent but
     I'd have chosen differently = coach). NONE is a legal and common value. -->
| Decision | Class it was triaged out of | Disqualifying test | Reversal path | Wakes carried |
|---|---|---|---|---|
| <WHAT-THE-PRINCIPAL-DECIDED-AND-WHY> | one-way-door \| taste \| money \| physical-world \| security \| n/a | <WHY-IT-WAS-NOT-OWNER-CLASS> <!-- e.g. observable from repo state: ledger shows cash $0 on every row --> | <HOW-TO-UNDO-IT> | <N-OF-2> |

Owner-class items held this cycle: <COUNT> of budget 3 · doctrine defects routed upstream: <NONE-OR-FIELD-NOTE-REFS>.
Owner-class items decided by the Principal (VIOLATIONS — the anti-abdication line): <NONE-OR-LIST>.

## What you can now do
<OUTCOME-FIRST-PRODUCT-LANGUAGE>

## Go use it
<LINK-OR-EXACT-RUN-INSTRUCTION>

## The tour (where to look, what to watch)
<BEFORE/AFTER-PER-CHANGE; WHAT-TO-WATCH-WHILE-DRIVING-IT; AND-WHAT-WAS-DELIBERATELY-UNCHANGED-AND-WHY>

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
