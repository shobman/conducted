# The vault - the estate boundary rule

Most of conducted needs no vault. The skills (L0), the gates (L1), the author bot (L2), and the
clerk (L3) all live entirely inside a project's own repo, and a single project never needs anything
else. The vault appears only when you run **more than one** project and want them governed as an
estate. This page is the boundary rule that decides what belongs in a project repo versus the vault,
the concrete file inventory, and how to create your own.

## The boundary rule

**Project state lives in the project repo. Estate state lives in the owner's vault.**

- **Project state** is everything *about one project*: its vision, roadmap, decisions, briefs,
  plans, ledgers, findings, showcases, and code. It lives in that project's repo, where every
  session working on that project can see it, and where it survives with or without a vault. A
  project repo is self-sufficient by design.
- **Estate state** is everything *about the collection*: which repos are onboarded, what each is
  allowed to spend, and how the machine governor that wakes them is tuned. This is not *about* any
  single project, so it lives in no single project. It needs a home of its own, and that home is a
  private repo the owner controls: the vault.

The test is simple: if deleting a project would make the fact meaningless, it is project state; if
the fact is about the relationship *between* projects (membership, shared money, shared machine
governance), it is estate state. When in doubt, keep it in the project repo. The vault holds the
minimum that genuinely cannot.

**Per-owner by design.** A vault is one person's estate. Anyone running the optional companion app
brings their own vault; there is no shared or central registry, and nothing in conducted assumes
one. Two owners running conducted have two independent vaults and never see each other's.

## The file inventory

A vault is a small private repo. Git is the store; the companion app and the runner read and write
these files, and if every other component dies, this repo plus the onboarded project repos rebuild
the whole picture.

    <your-vault>/
      registry.yml          # which repos are onboarded, and which the runner may ignite
      budgets.yml           # budget scopes, in two currencies
      runner.yml            # the L5 runner's governor config (owner-ruled numbers)
      runner/
        heartbeat.json      # the runner's last-alive stamp
        window-reading.json # the last observed plan-window reading (aged forward between wakes)

### registry.yml - membership

A list of onboarded repos. Each entry carries a `status:` and a per-repo `runner:` flag. The
`runner:` flag is how L5 scope grows one line at a time: the runner ignites a repo **only** when its
flag reads `runner: enabled` (case-insensitive), and anything else - `disabled`, a typo, a missing
flag - reads as disabled. Fail closed on enablement: a repo is never ignited unless the owner
clearly said so.

    repos:
      - repo: owner/project-a
        status: onboarded
        runner: enabled
      - repo: owner/project-b
        status: onboarded
        runner: disabled

### budgets.yml - money, in two currencies

Budget scopes and the repos each scope covers. Every figure is labelled with its currency, because
conducted spends two:

- **notional** - the plan-window allowance (Opus/Sonnet/Haiku through Claude Code). Already paid
  for; exhausting it costs time, not money (you WAIT for the window). Notional figures are "what I
  would have paid", a burn-rate signal, never a bill.
- **cash** - real money out of the bank (Fable API tokens plus any pay-as-you-go overflow). This is
  the currency that can actually hurt; exhausting it means STOP and get a ruling.

    scopes:
      - scope: example-scope
        cap_usd: <notional cap>      # plan-covered "what I would have paid"
        cash_usd: <real cash spent>  # money out of the bank
        repos:
          - owner/project-a

A single-number cap written before the two-currency law is read as notional. The runner's governor
reads this file before any dispatch.

### runner.yml - governor config (L5)

Flat `key: value` scalars. Three values are **required and never defaulted** - the runner throws
rather than invent a governor number (inventing a budget assumption is the same class of error as
inventing a test result):

    enabled: true                 # false stops ignition on the next wake (a kill switch)
    window_ceiling_pct: <owner>   # required: reserve fraction of the plan window to hold back
    max_reading_age_min: <owner>  # required: how stale a window reading may be and still be trusted
    window_len_hours: <owner>     # required: the rolling window length
    repos_root: <path>            # optional: where the project repos are checked out
    events_retention_days: <n>    # optional: how long to keep runner events

The window is **observed, never queried**: the runner reads it when Claude Code reports it, records
how old that reading is, and refuses expensive dispatch when the reading is missing or stale. It
never claims to know how much allowance remains. See [MIGRATIONS.md](MIGRATIONS.md) v9 for the full
sensor law, and [docs/setup/L5-runner.md](setup/L5-runner.md) for the runner itself.

### runner/ - live machine state

The runner's own scratch state: a `heartbeat.json` stamp so you can see it is alive, and a
`window-reading.json` carrying the last observed plan-window reading (with its `observed_at`, so
between wakes it can be aged forward by arithmetic on a known reset time, never a fresh guess). This
directory is written by the machine; you do not hand-edit it.

## How to create your own

1. Create a private repo: `gh repo create owner/conducted-vault --private` (any name; keep it
   private - it carries your estate's membership and budgets).
2. Add `registry.yml` with one entry per repo you want the estate to know about.
3. Add `budgets.yml` with your budget scopes in both currencies.
4. If you are going on to [L5](setup/L5-runner.md), add `runner.yml` with the three required
   governor numbers and `enabled: true`.
5. Point the optional companion app (and/or `Install-Runner.ps1 -Vault <this repo>`) at it.

**Undo is a single small act at every step:** a repo leaves the estate by deleting its one
`registry.yml` line, and the whole estate layer disappears by deleting the vault. Nothing in any
project repo depends on the vault existing - project repos remain self-sufficient with or without
one. That is the boundary rule doing its job.

The optional companion app that reads and renders the vault is maintained separately and is not
required to get value from the vault itself.
