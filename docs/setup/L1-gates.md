# L1 - Gates

> A CI workflow, shipped in the seed, that mechanically checks every PR against the branch it's
> merging into - so an agent can no longer widen its own scope from inside its own diff.

## What it does

The seed carries `.github/workflows/gates.yml` plus a `scripts/` directory
(`manifest-check.sh`, `test.sh`, `rollup.sh`). Genesis or adoption lands both in your project
repo. From then on, every pull request against `main` runs a `gates` check that reads the
**base ref** (never the PR's own copy of anything) and enforces:

- a secret scan (gitleaks),
- your project's tests and lint (`scripts/test.sh`),
- a territory-manifest check - a node can only touch the paths its brief said it would, as that
  brief reads on the base branch, not as the PR rewrote it,
- a scan for leftover template placeholders in brief/plan/showcase/status/ledger files,
- and, only once the repo is in bot mode (see [L2](L2-author-bot.md)), a check that every commit
  in the PR range is authored by the bot.

Honest split: CI mechanically enforces exactly those items - secret scan, tests/lint, territory,
placeholders, and (in bot mode) authorship. The adversarial diff review and the evaluator's
pass/fail verdict are **not** read by any gate; nothing in `gates.yml` opens `code-review.md` or
`status.json`. Those stay behavioral invariants, upheld by the conductor and evaluator rituals,
not by CI.

## Why it exists

This solves "agents grade their own homework" and "scope drifts invisibly." Territory is law as
of the base ref, so a PR cannot edit the rule it's judged by from inside itself.

Field evidence: MIGRATIONS v2 (the first real end-to-end run - three seed self-contradictions
failed a project's own docs-only PR three times, and the evaluator defeated the territory gate
three separate ways before it held); v5 (a bash `*` silently matched across `/`, so a brief
scoped to `src/*` was actually enforced as `src/**` - fixed by compiling globs to anchored
regexes); v6 ("gates never reject what doctrine mandates" - a gate that rejects an artifact the
doctrine requires committing is a seed bug, and the fix is always the gate, never the artifact).
See [`../MIGRATIONS.md`](../MIGRATIONS.md) v2, v5, v6 for the full incidents.

## Setup

### Scripted (the machine does this)

There's no separate install script - the workflow file itself is the mechanism. It ships inside
`seed/.github/workflows/gates.yml` and lands in your repo whenever genesis or adoption runs.

### Human acts (only you can do these)

Let genesis or adoption land the seed, then merge that PR like any other. That's it for the
check to start *running*.

To make it **required** - so a red gate actually blocks a merge instead of just informing you -
branch protection has to name the `gates` check. That arrives bundled into L2's
[`ops/setup-project-repo.ps1`](../../ops/setup-project-repo.ps1), or you can go into the repo's
branch-protection settings yourself and require the `gates` check manually, without adopting the
rest of L2.

## One repo at a time

The workflow file is per-repo by nature - it lives in that repo's own
`.github/workflows/gates.yml`. Landing it (via genesis or adoption) touches only that one repo;
nothing estate-wide happens.

## Kill switch

There isn't a per-gate switch, and that's deliberate: gates are law, "never on the menu, at any
budget." You don't get to disable the secret scan or the territory check individually. The only
switch is to stop the workflow entirely by removing the file (see Undo).

## Undo

Remove `.github/workflows/gates.yml` via an owner-lane PR. `.github/**` is gate-repair territory
- the admin lane reserved for the owner, never something a node touches as part of its own work.

## What gets better at this level

Secret leaks, broken tests, and scope-widening are now caught mechanically, on every PR, against
the base branch - not caught if someone happens to notice. Scope can't silently widen from
inside a PR's own diff.

## What it costs

$0 cash. The gitleaks action is free, and Actions minutes bill under GitHub's normal free/paid
tiers for private repos - no new spend conducted introduces on top of that. No new accounts, no
new secrets. The only draw is notional (your plan-window allowance) - CI runs cost you nothing
beyond what your Actions plan already covers; the agent sessions that respond to a red gate are
what draw down your window. Honest gap, restated: with no branch protection yet, gates *run* but
are not yet *required* - they inform you, but nothing is mechanically blocked until protection
requires the check (see [L2](L2-author-bot.md)).

See also: [`../../seed/.github/workflows/gates.yml`](../../seed/.github/workflows/gates.yml),
[`../MIGRATIONS.md`](../MIGRATIONS.md) (v2, v5, v6).
Back: [L0 - Skills only](L0-skills.md). Next: [L2 - Author bot](L2-author-bot.md).
