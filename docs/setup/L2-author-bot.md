# L2 - Author bot

> A machine GitHub account authors every agent commit and PR, which turns your approval from a
> conversation into a recorded, mechanically-required gate.

## What it does

You create one dedicated machine GitHub account - your **author bot** - and
invite it into your project repo as a collaborator with write access. From then on every agent
session authenticates as that account: commits, branches, PRs, and comments are all authored by
the bot, never by you. This is **bot mode**, and it's recorded in the project's
[`docs/BOT.md`](../../seed/docs/BOT.md).

Because the bot authors the work, GitHub's branch protection can require **your** recorded
approval before anything merges - a real, auditable review, not a click you happened to make in
a conversation. History then shows exactly what agents did versus what you did.

The bot arms GitHub's native auto-merge on its own PRs once your approval and the green gates
check land; it can never approve its own work.

## Why it exists

This is the identity law (MIGRATIONS v4): your identity carries exactly two things - rulings and
approvals - clicked or typed by you, the human, never produced by a session. Before this, an
agent's git commits under your own credentials made your approval indistinguishable from an
agent just saying so.

Field evidence (recorded in the version ledger): agent comments posted under the owner's own
identity "for the owner" - forging the one sensor the system can't replace; a conductor told to
"open PRs via the bot" with no mechanics anywhere to actually do it; and a run where commits lived
local-only for a node's entire life, because nothing forced them to be pushed as a distinct,
attributable actor. See [`../MIGRATIONS.md`](../MIGRATIONS.md) v4, and v6 for the authorship gate
that checks this mechanically in CI. See also the runbook's
[solo vs bot section](../RUNBOOK.md#solo-mode-vs-bot-mode) for the day-to-day difference.

## Setup

### Scripted (the machine does this)

- [`ops/setup-project-repo.ps1`](../../ops/setup-project-repo.ps1) `-Repo owner/name -Bot
  <machine-account>` - invites the bot as a write collaborator, sets squash-only + linear history
  + no force-push, requires 1 approval on `main`, and then **verifies** the protection actually
  reads back as real before declaring success (a silent failure here would leave the merge gate
  fictional).
- [`ops/enable-auto-merge.ps1`](../../ops/enable-auto-merge.ps1) `-Repos owner/name` - flips the
  repo's "allow auto-merge" setting so the bot can arm auto-merge on its own PRs. This is also a
  prerequisite for the bookkeeping-merge lane one level up; run it now even if you're stopping at
  L2.

### Human acts (only you can do these)

1. Create the machine GitHub account.
2. On that account, create a **classic** PAT (not fine-grained) with scopes `repo`, `workflow`,
   `read:org`. Classic, because a fine-grained PAT can only reach repos its own account owns, and
   the bot is deliberately a mere collaborator on your repos; `workflow` because conducted pushes
   `gates.yml` under `.github/workflows/`; `read:org` because `gh`'s GraphQL calls need it.
3. Accept the collaborator invite while signed in as the bot.
4. Make the PAT reachable to your sessions - on Windows, `setx CONDUCTED_BOT "<the PAT>"` in your
   **own** terminal. Never paste it into an agent conversation; a transcript is not a secrets
   store.
5. Fill in the project's `docs/BOT.md`: `mode: bot`, `bot-login:`, `pat-expires:`.

## One repo at a time

The collaborator invite and branch protection are both per-repo, and
`setup-project-repo.ps1` already takes a `-Repo` argument. Adopting L2 on a second project is one
more run of the script with a new `-Repo` - the first repo is untouched.

## Kill switch

Set `mode: solo` in that project's `docs/BOT.md`. Sessions fall back to your own credentials by
ruling, and the merge gate goes back to being behavioral - a conversation, not a recorded check.

## Undo

Remove the bot as a collaborator (`gh api -X DELETE repos/owner/name/collaborators/<bot>`), and
set `docs/BOT.md` back to `mode: solo`. Optionally relax the branch protection you added. Nothing
in the project's actual data depends on the bot - it's plumbing, not state.

## What gets better at this level

Your approval becomes a recorded gate instead of a conversation; history distinguishes agent
speech from your speech; multiple concurrent conductors become safe to run at once; and this is
what unlocks the L3 bookkeeping lane (docs-only PRs that can land themselves without your click).

## What it costs

One machine GitHub account (free) and one classic PAT (free; renewing it every ~90 days is a
small recurring owner chore). $0 cash - nothing here is billed. Notional only, and unchanged from
L1: the bot doesn't alter what your agent sessions draw from your plan window, it changes who's
allowed to push and merge.

See also: [`../../ops/setup-project-repo.ps1`](../../ops/setup-project-repo.ps1),
[`../../ops/enable-auto-merge.ps1`](../../ops/enable-auto-merge.ps1),
[`../../seed/docs/BOT.md`](../../seed/docs/BOT.md), [`../MIGRATIONS.md`](../MIGRATIONS.md) (v4, v6).
Back: [L1 - Gates](L1-gates.md).
