---
name: feedback
description: The owner has just looked at something — a showcase, a PR, a running app — and has a reaction. Resolve what he's reacting to, pull the real context (showcase, diff, brief, DoD), help him articulate expected-vs-saw, classify it as defect / taste / ruling because each routes differently under doctrine, spar to a confirmed reading of what he actually means, then file docs/feedback/<date>-<slug>.md — the owner-confirmed version, his raw words quoted as provenance — via a bookkeeping-lane PR. Use whenever the owner reacts to delivered work — "this feels wrong", "too slow", "not what I meant".
---

# /feedback — turn taste into something a conductor can act on

The owner has just looked at something and has a reaction. Reactions arrive as **taste** — "this
feels wrong", "too slow", "not what I meant". That is not a deficiency in the feedback; taste is
exactly the thing only he can supply, and it is the most valuable signal in the whole system.

Your job is to make it **actionable without flattening it**. The failure mode on both sides is real:
file "this feels wrong" untouched and no conductor can act on it; sharpen it into a crisp false
requirement and you have replaced his judgment with your guess and thrown away the actual signal.
When you can't resolve a reaction into specifics, **file the reaction as a reaction** — his words
plus honest uncertainty beat invented precision every time.

**Posture:** brief-first, grounded, few questions. Read the thing before you discuss it. Never
defend the work — you didn't build it, and defending it teaches him to stop telling you.

**Economics (doctrine v9).** Owner's session, **opus** by default, notional currency; fable only on
his explicit per-invocation opt-in. Cheap reads of repo state, the PR, and the showcase are expected.
**Do not spawn a fleet** — no re-evaluation, no investigation squad, no fix. This skill ends in a
file, not in work.

**Identity law.** Any commit, branch, or PR is bot-authored — preflight first, credential-helper push
form (see **Filing**).

---

## PR comments are not durable state

Say this plainly whenever it applies. **Feedback left in a GitHub PR review thread is not conducted
state** — it lives in GitHub, not the repo, and doctrine is explicit that the repo is the only state.
A cold session resuming from repo files cannot see it. So:

- Feedback he gave in a PR thread should be **re-filed by this skill** — offer to do it: read the
  thread, quote his comments verbatim, and land them as a feedback file. That is not duplication;
  it is the comment becoming state.
- The PR thread stays the right place for the human boundary conversation (doctrine: agent-to-agent
  coordination never goes through PR comments; review threads are for the human). Filing doesn't
  replace the thread — it makes the thread's content survive it.
- **A future Principal wake should harvest PR comments into this same shape** — sweeping open and
  recently-merged PRs for owner comments and filing any that never became a feedback file, a
  ROADMAP entry, or a DECISIONS ruling. Not law yet; note it if a wake would obviously benefit.

## 1 · Establish what he's reacting to

> **Opening (use this shape):**
>
> Tell me what you saw and what you made of it — react however it comes out, rough is fine, I'd
> rather have the real reaction than a tidy one.
>
> What was it you were looking at? A PR number or link, a node name, or just "the thing I just
> looked at" — I'll work it out from the repo.

Accept any of: a PR number or URL · a node name or path · a showcase · "the running app" · "the
thing I just looked at". Resolve it from the repo rather than asking him to be precise:

- recently merged and open PRs (`gh pr list --state all --limit 15`) — the most recent showcase PR
  is usually the answer;
- `work/*/status.json` for nodes recently in evaluation or closed;
- `docs/ledger/` and wake notes for what landed last.

Propose your resolution and let him correct it — "I think you mean PR #41, the queue view — right?"
is one cheap question that saves the whole conversation from being about the wrong thing. If it
genuinely can't be resolved, file it against the repo with `about: unresolved` and say so; an
unattributed reaction still beats a lost one.

## 2 · Pull the actual context

Before discussing it, read it — the conversation must be grounded, not speculative:

- `work/<node>/showcase.md` — what was CLAIMED, and the evidence claimed for it;
- the node's `brief.md` — **especially the DoD clauses and the INTENT block**. "Not what I meant"
  usually means the brief said something the DoD then satisfied exactly;
- the PR diff at a summary level (what changed, where) — you're orienting, not reviewing;
- `work/<node>/evaluations/round-*.md` — did the evaluator probe this and pass it? An evaluator
  that passed what the owner rejects is itself a finding worth naming;
- `docs/DECISIONS.md` — was this behaviour a ruling? Reacting against your own past ruling is a
  legitimate change of mind, but it should be a knowing one.

## 3 · Help him articulate — expected vs saw

Two questions carry most of the weight:

- **What did you expect?**
- **What did you actually see?**

Ask them in whatever wording fits what he's already said. The gap between the two answers is the
feedback; everything else is commentary. If he can only answer one, that's fine and normal — record
the one and mark the other unknown rather than filling it in for him.

Useful when the reaction is vaguer than the two questions can hold:
- "Show me the moment it felt wrong" — a specific screen, step, or line beats a general verdict.
- "Is it wrong, or is it not-yet-right?" — separates a defect from an unfinished thing.
- "If it were exactly right, what would be different?" — the inverse framing sometimes unlocks what
  the direct one can't.

Then **classify it**, out loud, and check the classification with him. This matters because the
three route completely differently under doctrine:

| Kind | What it means | Where it goes |
|---|---|---|
| **defect** | It doesn't do what the brief already said it would | Node work — a fix dispatch under the existing brief; the DoD already covers it |
| **taste** | It does what the brief said, and the result is still wrong to him | Showcase-level judgement — the Principal's call on whether it becomes a new node, an inherited-debt item, or an accepted limitation |
| **ruling** | The goal itself has changed | A ruling in DECISIONS that may amend the brief or the VISION — owner-required, never absorbed |

Don't force the call. "Between taste and ruling, closer to taste" is a legitimate value for `kind:`
and far more useful than false confidence. Say which way you'd lean and why, then take his answer.

**The observation rule applies to defects.** If it's a defect, the file needs one direct observation
of the failing behaviour — what he saw, on what, doing what. A defect filed without an observation
can't legally dispatch a fix, so capture the observation now while he still remembers it, or mark
plainly that it's missing.

## 4 · Capture his words verbatim

**His words are the evidence.** Quote them — exactly, including the ones that sound imprecise. "The
underline is murky" is not noise to be refined into "increase the underline's contrast ratio"; it is
the actual signal, and the refined version has already lost the part a designer needs. Quote first,
interpret separately and label it as interpretation.

Never paraphrase his reaction away in Raw, never tidy his phrasing there, never merge his
sentences with yours. But Raw is provenance, not the deliverable (owner ruling 2026-07-22): the
skill's value is the SPARRING — repeat his reaction back, confirm you understood the expected-vs-
saw, push back where the evidence disagrees, and converge on an `## Agreed` statement that
carries the classification and the actionable substance. **Read Agreed back and get his explicit
yes before filing.** Conductors and principals act on Agreed; Raw keeps everyone honest about
where it started.

## 5 · File it

Write `docs/feedback/<YYYY-MM-DD>-<slug>.md` in the repo. Date is today, UTC; slug is lowercase
ASCII letters, digits and hyphens; suffix `-2`, `-3`, … if taken.

```markdown
---
captured: <ISO-8601 timestamp>
source: skill:feedback
about: <node path | PR #N | PR URL | unresolved>
kind: defect | taste | ruling
status: untriaged
captured_by: <owner>
---

## Agreed

<the curated, sparred version the owner confirmed — the operative content>

## Raw

<his reaction, byte-for-byte as spoken — every quote exact>

## What he was reacting to

The resolved target and how I resolved it: PR, node, showcase, what the brief's DoD said,
what the evaluator reported. Pointers, not retellings.

## Expected vs saw

Expected: <his words>
Saw: <his words>
(Either may be "not stated" — say so rather than inferring it.)

## Observation

For a defect: the direct observation of the failing behaviour — what, where, doing what.
"Not captured" is an honest value and tells the next session it must get one before dispatching.
Omit the section for taste and ruling entries.

## Reading

My interpretation, clearly labelled as mine: why I classified it as I did, what it likely
routes to, anything it touches that he may not have connected — an evaluator that passed this,
a DECISIONS ruling it sits against, a DoD clause that literally permits what he's rejecting.
```

The machine-readable header is what makes this file sortable by a later wake — `about:`, `kind:`,
`status: untriaged` are the fields a Principal triages on, so fill all three even when a value is
hedged.

Then open the PR — **bookkeeping lane**: docs-only, **no `node:` trailer**, bot-authored, diff
confined to `docs/feedback/`. Anything touching `docs/VISION.md`, `docs/DECISIONS.md`,
`docs/BOT.md`, or outside `docs/**` leaves the lane and lands on the owner for nothing. **Note the
asymmetry:** a `kind: ruling` file RECORDS that a ruling is needed; it does not write DECISIONS.
Writing the ruling itself is owner-lane and is the Principal's job after he rules.

```bash
# Preflight — bot mode. Hard stop if this is not the bot.
export GH_TOKEN="$CONDUCTED_BOT" && gh auth setup-git
gh api user --jq .login          # must match docs/BOT.md; anything else = STOP

git -c user.name=<bot> -c user.email=<bot>@users.noreply.github.com \
    commit -m "feedback: <short description>"

# The credential-helper push form. The bearer-header form FAILS for classic PATs.
GH_TOKEN="$CONDUCTED_BOT" git -c credential.helper= \
  -c "credential.helper=!gh auth git-credential" push -u origin feedback/<YYYY-MM-DD>-<slug>

gh pr create --title "feedback: <short description>" --body "..."
```

Never push to main; always a branch plus a PR. In **solo mode** (`docs/BOT.md`) his credentials are
expected — sign the PR body as the session, never as him.

## 6 · Hand it back

Three or four lines:

- what was filed, its path, and the `kind:` you classified it as;
- the PR link;
- what that classification means for what happens next — defect → a fix under the existing brief;
  taste → the Principal weighs it at showcase level; ruling → it comes back to him as a ruling that
  may amend the brief or the VISION;
- anything you found while reading that he'd want to know (an evaluator that passed this, a DoD
  clause that permits it, a ruling in tension).

Then stop. Don't fix it, don't dispatch anything, don't ask for more feedback.
