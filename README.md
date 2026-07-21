# conducted

Run a real software project where AI agents do all the building, and you keep all the judgment.

**conducted** is an operating model for [Claude Code](https://claude.com/claude-code): four skills
(`/principal`, `/conduct`, plus the owner's entry points `/idea` and `/feedback`) and a repo seed
that turn one human owner and a hierarchy of disposable agent sessions into a working development
organization. You say what winning looks like, answer the occasional ruling, and review finished
work. Agents plan, build, verify, and account for every dollar, under rules they cannot bend.

The core skills are complete on their own: with nothing but the skills installed you can run a real
solo project, and the repo is the only state, so any session can die and a fresh one resumes from
the committed files alone. Everything past that is **optional maturity** you add when a project earns
it: machine-enforced gates, a bot that authors agent work so your approval becomes a recorded gate,
a clerk that lands your paperwork PRs without a click, an estate vault, and a runner that starts
ready work on a timer. You never have to adopt any of it, and nothing you add is hard to walk back.

The doctrine is not a set of promises agents try to keep; it is a set of rules they *cannot* break.
State lives in files, not conversations. Nothing verifies itself: every finished piece is judged by
a fresh-context evaluator that never saw the build. Gates are law, enforced by CI against the base
branch, so an agent cannot widen its own scope from inside its own PR. Money is on the ledger, in
two honest currencies, with a hard spending cap you set. Every rule traces to a real incident on a
real project, captured as evidence and harvested into versioned law.

## The maturity ladder

conducted is adopted in levels. Each one is **independently useful** and stands on the one below it.
**Every level is adoptable per-repo where applicable, and every level's undo is a single small act:
conducted never demands estate-wide adoption and never makes a step hard to walk back.** "One bit at
a time, so it's safe, and can be undone."

| Level | You get | You set up (scripted) | Human acts (only you) |
|---|---|---|---|
| **[L0 Skills](docs/setup/L0-skills.md)** | The four skills; solo mode; the repo is the only state | `install.ps1` copies the skills | Install Claude Code + `gh`; run `/principal` in your repo |
| **[L1 Gates](docs/setup/L1-gates.md)** | CI enforces secret scan, tests, and territory against the base ref | the seed ships `gates.yml` + `scripts/` | Let the seed land; merge the PR |
| **[L2 Author bot](docs/setup/L2-author-bot.md)** | Your approval becomes a recorded, required gate; agent-vs-owner audit trail | `setup-project-repo.ps1`, `enable-auto-merge.ps1` | Create a machine account + its classic PAT |
| **[L3 Clerk reviewer](docs/setup/L3-clerk-reviewer.md)** | Docs-only bookkeeping PRs review and land themselves, no click | `setup-clerk-secrets.ps1` | Create a second machine account + PAT |
| **[L4 Vault (+ Desk)](docs/setup/L4-vault.md)** | Cross-repo estate state: membership, budgets, governor config | one `gh repo create --private` | Create the vault; register repos |
| **[L5 Runner](docs/setup/L5-runner.md)** | Ready work ignites on a timer, under a window governor, never merging | `Install-Runner.ps1` | Set the governor numbers + the account spend limit |

L0 through L4 cost **$0 cash** (agent sessions draw your already-paid plan allowance; see
[Economics](#proven-in-the-field-versioned-like-software)). Each level's doc splits its setup into
what a script does versus what only a human can do, and states its kill switch, its one-act undo,
and exactly what it costs. Start at L0; climb only when a project makes you want the next rung.

## Start in three steps (this is L0)

1. **Install** [Claude Code](https://claude.com/claude-code) and the
   [GitHub CLI](https://cli.github.com/) (`gh auth login`), then:

       git clone https://github.com/shobman/conducted && cd conducted && ./install.ps1

2. **Ignite** by opening a terminal in your project repo (brand-new or existing, both work):

       claude
       /principal

   Answer the interview in plain language. It ends with a pull request whose description *is* the
   project plan; read it, comment, merge. When it asks for a mode, say **solo** for your first
   project ([why](docs/setup/L2-author-bot.md)).

3. **Conduct**: the Principal hands you a dispatch board; paste each listed command into a new
   terminal tab and let it run. Finished work comes back as showcase PRs written for a human: what
   was decided, what you can now do, the evidence. Merge when satisfied.

**-> [The owner's runbook](docs/RUNBOOK.md)** covers everything after that: the day-to-day loop,
your three jobs, cost control, which ladder level you're on, and what to do when something looks
wrong. It's a ten-minute read and the only document a non-programmer owner ever needs.

## Who does what

| Role | Held by | Does | Never does |
|---|---|---|---|
| **Owner** | you | vision, rulings, spend caps, showcase reviews | reads code |
| **Principal** | a session | the map: roadmap, briefs, sequencing, economics | builds anything |
| **Conductor** | one session per node | scouts, plans, dispatches a worker fleet, integrates | merges its own work |
| **Evaluator** | a fresh session | probes the finished node, binary verdict with proof | sees the build conversation |

At L2 and above, the **author bot** and the **clerk** are two machine accounts that split one power
in half: the author writes agent commits and PRs but can never approve them; the clerk approves
mechanically-verified bookkeeping PRs but never authors anything. Neither can act alone.

## Proven in the field, versioned like software

The doctrine changes only on evidence. Every rule in the seed traces to a real incident on a real
project: a non-terminating review loop, a gate an agent defeated three ways, a fabricated defect
that took an environment down. These are captured as [field reports](docs/field-reports/) and field
notes, harvested into versioned law with a [migration path](docs/MIGRATIONS.md) for every adopted
repo. The build plans for each version are in [docs/plans/](docs/plans/), executed by the same
process they define.

## Layout

- `skills/` - the Claude Code skills: the two roles (`/principal`, `/conduct`) plus the owner's two
  entry points (`/idea`, `/feedback`); `install.ps1` copies them to `~/.claude/skills/`
- `seed/` - what genesis copies into a project repo: doctrine (`CLAUDE.md`), templates, CI gates,
  status schema, rituals
- `docs/setup/` - the maturity ladder, one doc per level (L0 to L5)
- `docs/RUNBOOK.md` - the human owner's guide - `docs/MIGRATIONS.md` - the version ledger -
  `docs/VAULT.md` - the estate boundary rule - `docs/field-reports/` - the evidence -
  `docs/plans/` - how each version was built
- `ops/` - the owner's setup scripts, one per ladder rung above L1 (`setup-project-repo.ps1`,
  `enable-auto-merge.ps1`, `setup-clerk-secrets.ps1`) plus the live-conductor launchers
- [`CONTRIBUTING.md`](CONTRIBUTING.md) - how evidence becomes law, and how to contribute yours

## License

[MIT](LICENSE)
