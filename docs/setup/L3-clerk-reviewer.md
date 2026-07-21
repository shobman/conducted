# L3 - Clerk reviewer

> A second machine user reviews and mechanically approves your docs-only bookkeeping PRs, so they
> merge themselves with no click from you.

## What it does

You create a second dedicated machine GitHub account - the **clerk** - and
give the `bookkeeping-merge` job in `gates.yml` its PAT, held only in the
`CONDUCTED_CLERK` Actions secret. From then on, every PR is classified into exactly one of two
lanes, derived from its diff, never from a label or the PR text:

- **Owner lane** (unchanged, and still the default): showcases, irreversibles, rulings, anything
  outside the bookkeeping class. Your click is still the only key.
- **Bookkeeping lane**: a trailerless PR, authored by the L2 author bot, whose entire diff sits
  inside `docs/**` - minus `docs/VISION.md`, `docs/DECISIONS.md`, and `docs/BOT.md`, which stay
  owner lane on purpose. Wake notes, ledger updates, close-outs, field notes, findings, ROADMAP
  status - the paperwork of running the project, not the project itself.

When a bookkeeping PR's gates check goes green, the clerk posts a real, recorded APPROVE review
pinned to that exact commit SHA. It never authors anything and never touches PR content - the
`bookkeeping-merge` job runs on `pull_request_target`, so its logic is always the base ref's; it
reads diff file names, the base ref's `docs/BOT.md`, and check-run conclusions, nothing from the
PR's own commits. The author bot armed GitHub's native auto-merge when it opened the PR; once the
clerk's approval lands, GitHub itself performs the merge. Two-key separation is the whole design:
the author can arm but can never approve itself, the clerk can approve but never authors anything,
and neither credential alone lands a single PR.

## Why it exists

MIGRATIONS v7: the owner had become the dispatcher, the ceremony-approver, and the
scheduler for docs-only wake PRs - across several consumer repos the frontier was blocked on
exactly this class of PR. None of them needed judgment; they needed a click. See
[`../MIGRATIONS.md`](../MIGRATIONS.md) v7.

The shape of the fix is deliberate, not incidental:

- **Author-never-reviews.** The same two-key separation as L2, one level further: the party that
  writes a PR can never be the party that approves it.
- **A machine USER, not a GitHub App.** An earlier design used a dedicated GitHub App as the
  approving credential. It was retired: GitHub App review approvals are **not counted** by branch
  rulesets - proven live in the field, where a ruleset-protected repo stayed `REVIEW_REQUIRED`
  after the App "approved". A machine user's approval *is* counted. The clerk is an ordinary
  GitHub account, not an App installation - that's the whole reason it works.
- **No bypass, for anyone.** The clerk's review is a real review satisfying the branch protection
  rule, not a rule exemption. Required status checks still bind server-side regardless of who or
  what approved.

## Setup

### Scripted (the machine does this)

- [`ops/setup-clerk-secrets.ps1`](../../ops/setup-clerk-secrets.ps1) `-SecretFile <path> -Repos
  owner/name` - reads the clerk's PAT from a file on disk (never a command-line argument, never
  echoed, never in shell history) and sets it as the `CONDUCTED_CLERK` Actions secret on each repo
  you name. Idempotent - re-running it is how you rotate the token.
- [`ops/enable-auto-merge.ps1`](../../ops/enable-auto-merge.ps1) `-Repos owner/name` - the same
  script L2 uses to flip on the repo's "allow auto-merge" setting. Skip it if you already ran it at
  L2; run it now if you're arriving at L3 directly.
- The `bookkeeping-merge` job itself ships in the seed's
  [`gates.yml`](../../seed/.github/workflows/gates.yml) already - there is nothing else to install.

### Human acts (only you can do these)

1. Create the clerk's machine GitHub account.
2. On that account, create a **classic** PAT with the `repo` scope.
3. Save the PAT to a local file and point `setup-clerk-secrets.ps1` at it.

That's it - no collaborator invite, no repo settings beyond auto-merge. The clerk needs nothing
more than the secret to do its job.

## One repo at a time

This is load-bearing, not incidental: the `CONDUCTED_CLERK` secret is set **per repo**, one Actions
secret at a time. The `bookkeeping-merge` job's own gate for whether it's configured at all is
`secrets.CONDUCTED_CLERK != ''`. A repo where that secret was never set is not broken and not
half-migrated - it is a **clean no-op**. The job still runs, still classifies every PR, and every
PR - including PRs that would otherwise qualify for the bookkeeping lane - falls straight to the
owner lane and the job exits green. Running `setup-clerk-secrets.ps1` against one repo arms L3 on
that repo alone; every other repo you own is untouched and stays legally on the owner lane.

## Kill switch

Delete the `CONDUCTED_CLERK` secret. The `CONFIGURED` check goes false on the very next PR, and the
lane instantly no-ops back to owner lane - nothing else to flip, nothing else to unwind.

## Undo

The kill switch and the undo are the same single action:

    gh secret delete CONDUCTED_CLERK --repo owner/name --app actions

Instant and fully reversible. No branch protection changes, no collaborator to remove, no state
anywhere else that depends on the clerk having existed.

## What gets better at this level

Docs-only bookkeeping PRs land themselves the moment gates go green. You stop being the dispatcher
and the ceremony-approver for paperwork that was never asking for your judgment in the first place
- your click is now reserved for the things that actually need it. It also unlocks
dispatch-on-merge (MIGRATIONS v7): a bookkeeping merge can ignite ready board nodes within the
ruled cap, without waiting on a synchronous owner action.

## What it costs

One more machine GitHub account (free) and one classic PAT (free; renewing it is a small recurring
owner chore, same as L2's). One Actions secret per repo you enable it on. $0 cash. Notional only -
the clerk's own review costs nothing; the agent sessions that produced the PR being reviewed were
already drawing your plan window regardless of L3.

See also: [`../../ops/setup-clerk-secrets.ps1`](../../ops/setup-clerk-secrets.ps1),
[`../../ops/enable-auto-merge.ps1`](../../ops/enable-auto-merge.ps1),
[`../../seed/.github/workflows/gates.yml`](../../seed/.github/workflows/gates.yml) (the
`bookkeeping-merge` job), [`../MIGRATIONS.md`](../MIGRATIONS.md) (v7).
Back: [L2 - Author bot](L2-author-bot.md). Next: [L4 - Vault (+ Desk)](L4-vault.md).
