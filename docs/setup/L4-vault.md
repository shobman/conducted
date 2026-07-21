# L4 - Vault (+ Desk)

> An optional private repo holding your estate's cross-repo state - which projects are onboarded,
> what each is allowed to spend, and the runner's governor config - separate from any project repo.

## What it does

You create one private repo - a "conducted-vault-class" repo - holding three files and one
directory: `registry.yml` (which repos are onboarded, plus a per-repo `runner:` flag), `budgets.yml`
(budget scopes in both currencies), `runner.yml` (the L5 runner's governor config), and `runner/`
(heartbeat and window-reading state once L5 is running). This is the only new mechanism at L4 -
everything else is data.

The Desk is a separate, optional companion app that reads and renders the vault for you. It is not
required to get value from the vault, and this doc doesn't cover it further.

This doc stays short on purpose. The full inventory and the boundary rule behind it live in
[`../VAULT.md`](../VAULT.md) - read that before creating a vault of your own.

## Why it exists

The boundary rule: state about one project lives in that project's own repo; state about your
*estate* - which repos exist, what they're each allowed to cost, how the machine governor is tuned
- lives in no single project, because it isn't about any single project. It needs somewhere of its
own. A vault is per-owner by design: anyone running the Desk brings their own.

MIGRATIONS v9 formalized why this matters now: the plan-window is an estate-wide resource shared
across every repo you have, while `budgets.yml` scopes are per-repo - the vault is where those two
facts get reconciled. See [`../MIGRATIONS.md`](../MIGRATIONS.md) v9, and
[`../VAULT.md`](../VAULT.md) for the boundary rule in full.

## Setup

### Scripted (the machine does this)

Nothing. Creating a private repo is a single `gh` command, not a conducted script:

    gh repo create owner/conducted-vault --private

### Human acts (only you can do these)

1. Create the private vault repo.
2. Add `registry.yml`, `budgets.yml`, and (if you're going on to L5) `runner.yml`.
3. Register the repos you want the estate to know about - one entry per repo.

## One repo at a time

A repo joins the estate with one `registry.yml` entry (a `- repo: owner/name` block with its
`status:` and, from L5 on, its `runner:` flag). Adding one repo never touches any other entry.

## Kill switch

The vault is passive state - nothing reads it unless you point something (the Desk, or the L5
runner) at it. Stop using it by pointing nothing there.

## Undo

Remove a repo's line from `registry.yml`, or delete the vault entirely. Nothing in any project repo
depends on the vault existing - project repos are self-sufficient with or without one.

## What gets better at this level

A cross-repo view of your whole estate, budget attribution across projects, and the substrate the
L5 runner reads before it wakes anything.

## What it costs

One private repo (free/included on GitHub). $0 cash. The Desk app, if you use it, is optional and
not covered here.

See also: [`../VAULT.md`](../VAULT.md) (the full file inventory and boundary rule),
[`../MIGRATIONS.md`](../MIGRATIONS.md) (v9).
Back: [L3 - Clerk reviewer](L3-clerk-reviewer.md). Next: [L5 - Runner](L5-runner.md).
