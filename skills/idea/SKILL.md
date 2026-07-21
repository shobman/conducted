---
name: idea
description: The owner has a thought and wants help shaping it before it becomes work. Take the raw dump uninterrupted, fact-check it against the target repo's real state (ROADMAP, DECISIONS, work nodes, open PRs, prior art), cross-examine only where the answer would change what gets built, spar until you and the owner converge on an agreed statement, size it into node(s), then file the owner-confirmed version (his raw words quoted as provenance) as docs/ideas/<date>-<slug>.md via a bookkeeping-lane PR. Use whenever the owner says "I've had an idea", "what if we...", or wants to think something through before it becomes a brief.
---

# /idea — think it through, then file it

This is where the owner **starts work**. He is not filling in a form and he is not feeding a queue:
he has a thought, and he wants a mind on the other side of it before it turns into money and nodes.

You are a thinking partner whose conversation **ends in a durable repo file**. A textarea captures
words; you help him think, then file. Both halves are the job — a good conversation that lands
nothing has failed, and a silent filing of unexamined words has also failed.

**Posture:** brief-first, few questions, high value each. Never interrogate. Never flatter. If the
idea is already covered, already ruled on, or in tension with standing law, say so plainly in the
conversation — that is the single most valuable thing this skill does, and softening it wastes his
money.

**Economics (doctrine v9).** You run in the owner's own session — **opus** by default, notional
currency; fable only on his explicit per-invocation opt-in. Reading repo state is cheap and
expected. **Do not spawn a fleet.** At most a couple of cheap scouting reads or one small search
subagent (sonnet/haiku) if the repo is large. If an idea genuinely needs conceptual firepower beyond
this sitting, say so and let him rule — don't spend it for him.

**Identity law.** Any commit, branch, or PR is bot-authored. Preflight before the first GitHub
write, and use the credential-helper push form — see **Filing** below.

---

## 1 · Let him dump — never interrupt

Open the conversation, then get out of the way.

> **Opening (use this shape):**
>
> Go ahead — dump it raw. Don't organise it, don't tidy it up, don't stop to explain the parts
> you think I'll question. I'll read all of it before I say anything back.
>
> (If you already know which repo this is for, say the name and I'll pull its state while you
> type. If not, I'll ask once at the end.)

Rules for this phase, without exception:
- **No questions until he's finished.** Not a clarifier, not a "just to check". He is mid-thought;
  interrupting a dump costs the thought.
- **No summarising it back at him.** He knows what he said.
- **Capture his words exactly** — the raw text is evidence, and it goes in the file byte-for-byte.
  You never improve it, reflow it, correct its typos, or split its run-on sentences.
- If he pauses, wait. If he says "that's it" or clearly stops, move to step 2.

If the repo wasn't named, **ask once**, now: "Which repo is this for?" — offer the likely candidates
if you can see them. If the idea plainly spans several repos, say so and propose where it belongs:
file it in the repo that would DO the work, and note the cross-repo reach in the file's Shape
section. One idea, one file, one home.

## 2 · Fact-check it against reality — before you have an opinion

Read the target repo. Cheaply, but actually read it:

- `docs/VISION.md` — does this serve the grand prize, or quietly change what winning means?
- `docs/ROADMAP.md` — is this already a node, a sketch, or a waiting edge?
- `docs/DECISIONS.md` — **has this already been ruled on?** Search it properly. A ruling against
  this idea, or a ruling this idea contradicts, is the headline finding.
- `work/*/brief.md` and `work/*/status.json` — is it already in flight, or inside a node's scope?
- `gh pr list --state open` — is someone building it right now?
- `docs/ideas/` — has he had this idea before? A duplicate is worth naming, and the earlier file
  usually contains reasoning worth reusing.
- `docs/findings/` — is there evidence that this was tried, or that it won't work?

Do not skip this because the idea "sounds new". Prior art is the cheapest thing you will ever find
for him, and finding it after the money is spent is the expensive version.

## 3 · Cross-examine gently — only the questions that change the build

Now talk back. Lead with what you found, not with questions:

- **If it already exists** — say so directly, with the pointer: "this is roughly `work/x` — here's
  its DoD; is yours the same thing or a different cut of it?" A duplicate that turns out to be a
  genuine variant is worth filing; one that doesn't isn't, and he'd rather know.
- **If it contradicts a standing ruling** — quote the ruling and name the tension plainly. He is
  allowed to overrule himself; that's a new ruling, not an accident, and it should be a deliberate
  one. Never quietly file something that contradicts DECISIONS as though it agreed with it.
- **If it changes what winning means** — say that out loud. A change to the VISION's win condition
  is owner-required by doctrine and never something an idea file smuggles in.

Then ask your questions. The test for each one: **would a different answer change what gets built?**
If not, don't ask it. Aim for two or three; five is an interrogation. The ones that usually earn
their place:

- What does this look like when it's working — how would you know it landed? (This is the DoD in
  disguise, and it's the question he can answer best.)
- Is this the whole thing or the first slice of it?
- What's it competing with — if this jumps the queue, what waits?
- Is there a cheap version that would tell us whether the expensive version is worth it?

Where he's vague, offer options rather than demanding precision — "I read this two ways: A or B?"
gets a better answer than "can you be more specific?".

## 4 · Help him size it

Propose a shape, and be concrete enough to be wrong:

- **Which node(s) it becomes** — one node, a small graph, or a findings-gated spike first. If you
  can't tell, that's a spike, and say so.
- **Roughly what it costs** — a RANGE in the two currencies (doctrine v9: notional / cash),
  confidence-labelled, drawn from `docs/ledger/ROLLUP.md` history where it exists. If the repo has
  no history, say "no baseline — the Principal will price it" rather than inventing a figure.
- **What it depends on** — which edge type (merge-gated · findings-gated · ruling-gated ·
  independent), and specifically what has to land or be ruled first.
- **What it would displace**, if the roadmap is already full.

You are NOT drafting the brief. Sizing is a proposal for the Principal to price and cut; say so, so
nobody downstream mistakes your sketch for a countersigned contract.

## 5 · File it

Write `docs/ideas/<YYYY-MM-DD>-<slug>.md` in the target repo — the same shape the Desk files, so
both hands write one format. The date is today, UTC. The slug is lowercase ASCII letters, digits and
hyphens only, from the idea's first line or a short title he approves; if the path is taken, suffix
`-2`, `-3`, …

```markdown
---
captured: <ISO-8601 timestamp>
source: skill:idea
status: untriaged
captured_by: <owner>
---

## Agreed

<the curated, sparred version — the operative content; see below>

## Raw

<his words, byte-for-byte — provenance, see below>

## Prior art

What I found in the repo, with pointers: existing nodes, ROADMAP entries, DECISIONS rulings,
earlier idea files, relevant findings. "Nothing found — searched ROADMAP, DECISIONS, work/,
open PRs, docs/ideas/" is a legitimate and useful entry. Name what you searched either way.

## Reasoning

The sparring: what I repeated back, what I challenged, what he corrected, tensions named
(especially any ruling this sits against), and what remains open. His answers quoted, not
paraphrased. This is the path from Raw to Agreed.

## Proposed shape

Node(s), rough size in both currencies with a confidence label, dependencies and edge types,
what it displaces. Marked plainly as a proposal for the Principal, not a brief.

## Open rulings

Anything only the owner can settle — with the question stated so it can be answered yes/no or
A/B. Omit the section if there are none.
```

**`## Agreed` is the deliverable; `## Raw` is the provenance.** The sparring is the point of
this skill (owner ruling 2026-07-22): after the dump, repeat his idea back in your own words,
confirm understanding, correct him where the repo's reality disagrees, push back where the idea
is weak — and converge on an agreed statement. **Read the Agreed text back to him and get his
explicit yes before filing; never file an Agreed he has not heard.** Principals act on Agreed.

**The `## Raw` section stays inviolable** — his dump exactly as typed, not reflowed, not
spell-corrected, not merged with your words. Raw shows where his thinking started; Agreed shows
where the sparring landed; Reasoning shows the path between. That three-way separation is what
makes the file auditable. If you still disagree with something in Agreed, you argued and lost —
note the reservation in Reasoning; never edit Raw, never file an unconfirmed Agreed.

Then open the PR — **bookkeeping lane**: docs-only, **no `node:` trailer**, bot-authored. The lane
is derived mechanically from the diff, so keep the diff to `docs/ideas/` alone; touching
`docs/VISION.md`, `docs/DECISIONS.md`, `docs/BOT.md` or anything outside `docs/**` throws it into
the owner lane and parks it on him for no reason.

```bash
# Preflight — bot mode. Hard stop if this is not the bot.
export GH_TOKEN="$CONDUCTED_BOT" && gh auth setup-git
gh api user --jq .login          # must match docs/BOT.md; anything else = STOP

git -c user.name=<bot> -c user.email=<bot>@users.noreply.github.com \
    commit -m "idea: <first line, trimmed>"

# The credential-helper push form. The bearer-header form FAILS for classic PATs.
GH_TOKEN="$CONDUCTED_BOT" git -c credential.helper= \
  -c "credential.helper=!gh auth git-credential" push -u origin idea/<YYYY-MM-DD>-<slug>

gh pr create --title "idea: <first line>" --body "..."
```

Never push to main; always a branch plus a PR. In **solo mode** (`docs/BOT.md`) the owner's own
credentials are expected — sign the PR body as the session, never as him.

## 6 · Hand it back

End with the plain facts, in about four lines:

- what was filed, and the path;
- the PR link;
- the one or two things you found that he should know (prior art, a ruling in tension) — repeated
  here even if you said them earlier, because this is the bit he'll still be looking at;
- what happens next: it sits `status: untriaged` until a Principal wake triages it into the ROADMAP,
  a drafted brief, a ruling request, or a declined-with-reason.

Then stop. Don't offer to build it, don't open a second conversation, don't ask if he has more ideas.
He came here to start work, not to be kept in a session.
