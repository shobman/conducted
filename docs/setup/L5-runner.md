# L5 - Runner

> A scheduled task that wakes a principal on ready work every half hour, refuses to guess your
> remaining budget, and never merges anything itself.

## What it does

`Install-Runner.ps1` registers a Windows scheduled task named `conducted-runner`, firing every 30
minutes on the half hour (`:00`/`:30`). Each wake runs `runner.ps1` once against your vault, then
exits - it does not stay running between wakes. Each run reads `runner.yml` for its governor
settings and `registry.yml` for which repos it's allowed to touch, and ignites **only** repos
flagged `runner: enabled`; a missing or misspelled flag reads as disabled, never enabled.

Before it wakes anything, it reads the plan window's ceiling. If that reading is missing or older
than the age limit you set, it fails **closed** for expensive dispatch - it does not fall back to
assuming headroom exists. The runner never merges anything; that stays entirely with the L2 author
bot and the L3 clerk. Its only job is deciding whether to wake a principal, never whether to land a
PR.

## Why it exists

MIGRATIONS v7's dispatch-on-merge and v9's window governor, put together: automate the ignition of
ready or triageable work so you stop being the one who remembers to start it, while keeping spend
inside caps you set - not caps the runner invents.

Be honest about the shape of that governance: it is **soft by design**. The only mechanical wall
against real money leaving your account is external to conducted entirely - the account-level
`/usage-credits` monthly spend limit, with auto-reload turned off. That's a setting on your
Anthropic account, not a file in any repo. What the runner itself does is narrower and stated
plainly: it reads the plan window when Claude Code has reported one, records how old that reading
is, and refuses expensive dispatch when the reading is missing or stale. It never claims to know
how much allowance you actually have left - only whether the last reading it has is fresh enough
to trust. See [`../MIGRATIONS.md`](../MIGRATIONS.md) (v7, v9) and [`../VAULT.md`](../VAULT.md).

## Setup

### Scripted (the machine does this)

- `Install-Runner.ps1 -Vault <path-to-conducted-vault>` registers the scheduled task, pointed at
  your vault. Idempotent - re-running it updates the existing task in place.
- `Install-Runner.ps1 -Uninstall` removes the scheduled task outright.

### Human acts (only you can do these)

The runner refuses to invent any of its governor numbers - it throws rather than guess, so these
are yours to set:

1. In the vault's `runner.yml`, set `window_ceiling_pct`, `max_reading_age_min`, and
   `window_len_hours` (all required - the runner will not start without them), plus `enabled: true`.
2. In `registry.yml`, set `runner: enabled` on each repo you want it to touch.
3. In `budgets.yml`, set the caps and cash ceiling you want enforced.
4. Once per account, not per repo: set the `/usage-credits` monthly spend limit and turn
   auto-reload **off**. This is the one mechanical cash wall, and nothing in any repo substitutes
   for it.

## One repo at a time

The runner installs once per machine - one scheduled task - but it only ignites repos carrying
`runner: enabled` in `registry.yml`, so the scope it acts on grows one registry line at a time. The
flag fails closed: anything other than `enabled` (case-insensitive) - a typo, an empty value, a
missing flag - reads as disabled. A mistake in the registry never accidentally ignites a repo.

## Kill switch

Three, ordered smallest to largest:

1. **Stop one repo:** set `runner: disabled` (or remove the flag) for that repo in `registry.yml`.
   Every other enabled repo keeps running.
2. **Stop ignition estate-wide on the next wake:** set `enabled: false` in `runner.yml`.
3. **Stop the runner right now:** `Install-Runner.ps1 -Uninstall` deletes the scheduled task
   itself.

## Undo

The same three layers, applied in that order as your comfort with the runner grows or shrinks:
turn off one repo's flag first; if that's not enough, disable the whole runner in `runner.yml`;
if you want it gone entirely, uninstall the scheduled task. Nothing about L0-L4 depends on the
runner having existed.

## What gets better at this level

Ready work gets ignited without you remembering to start it, inside the limits you've set - and
because the board (v10) no longer needs your attention to move, you can genuinely ignore it
between checks. Hands-off, but still inside the money wall.

## What it costs

$0 cash for the runner itself. It draws **notional** plan-window allowance each time it wakes a
principal - the same allowance any agent session draws, just started by a timer instead of by you.
The runner never merges, so it never directly spends cash either way. The real cash wall is the
account spend limit from step 4 above - external to conducted, and the only place real money stops.

See also: `Install-Runner.ps1` and its `config.mjs` (which define the `runner.yml` and registry
`runner:` flag shapes) ship with the optional companion app, maintained separately;
[`../MIGRATIONS.md`](../MIGRATIONS.md) (v7, v9), [`../VAULT.md`](../VAULT.md).
Back: [L4 - Vault (+ Desk)](L4-vault.md).
