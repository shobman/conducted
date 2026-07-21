# L0 - Skills only

> Four Claude Code skills on your own machine, running under your own GitHub identity - the
> smallest thing conducted can be.

## What it does

`install.ps1` copies `skills/*` from this repo into `~/.claude/skills/`. That's the entire
mechanism. Four skills land:

- `/principal` and `/conduct` - the two roles. `/principal` reads a repo and hands you a plan and
  a dispatch board; `/conduct` takes one item off that board and builds it end to end.
- `/idea` and `/feedback` - your two entry points. `/idea` takes a raw thought and files it as a
  reviewable PR; `/feedback` takes a reaction to something already built ("this feels wrong") and
  does the same.

Nothing else changes. No GitHub settings, no new accounts, no CI. You run these skills inside
Claude Code, in whatever project repo you're working on, in **solo mode**: agents act under your
own GitHub identity, and nothing merges until you say so - by typing merge, or clicking it.

Repo-is-the-state applies from here: any session can die at any point, and a fresh one resumes
from what's committed, not from a conversation.

## Why it exists

This solves two things that break agentic coding at any real scale: state living only in a
conversation (close the tab, lose the project), and you becoming the bottleneck who has to
supervise every step. L0 is a complete answer to both, on its own - you can run a real solo
project with nothing beyond this.

Honest limit: at L0 there is no CI gate yet (that's L1), so two of conducted's invariants -
"nothing verifies itself" and "the repo is the only state" - are enforced only by the skills'
own rituals and your discipline. They are **behavioral**, not machine-enforced. That's a real
gap, and it closes at L1, not here.

## Setup

### Scripted (the machine does this)

- `install.ps1` copies each directory under `skills/` into `~/.claude/skills/`, one-for-one. It's
  idempotent - re-running it after a `git pull` just refreshes the copies.

### Human acts (only you can do these)

1. Install [Claude Code](https://claude.com/claude-code) and the [GitHub CLI](https://cli.github.com/).
2. Run `gh auth login` as yourself - not as any machine account, there isn't one yet.
3. Clone conducted and install the skills:

       git clone https://github.com/shobman/conducted && cd conducted && ./install.ps1

4. Open your project repo (new or existing), run `claude`, then `/principal`.
5. When it asks you to pick a mode, choose **solo**.

## One repo at a time

Not really an axis here - skills install once per PC and then serve any repo you open them in.
"Adopting conducted on one project" just means running `/principal` in that one repo; genesis or
adoption scaffolds only that repo and never touches another. There's no per-repo install step at
this level. Running `/principal` in a second repo is exactly as safe - it reads and writes only
that repo, never the first.

## Kill switch

Solo mode already is the kill switch: nothing merges without your click or your word, every time.
There's no separate switch to throw.

## Undo

Delete the four skill directories under `~/.claude/skills/` (`principal`, `conduct`, `idea`,
`feedback`). Your project repos are untouched. If a repo already carries seed doctrine (from a
prior `/principal` run), that stays behind as ordinary committed files - inert without the
skills to act on it. There is nothing to unwind on GitHub: L0 never touched a repo setting or an
account.

## What gets better at this level

You get named roles instead of ad-hoc prompting, disposable sessions instead of one long
conversation you're afraid to close, and the start of an honest ledger habit (rulings, briefs,
showcases) even before anything is machine-checked.

## What it costs

Two currencies matter throughout this ladder. **Notional** is your plan-window allowance
(opus/sonnet/haiku via Claude Code) - already paid for; running out just means waiting for the
window to reset. **Cash** is real money spent beyond that. L0 costs $0 cash: no accounts, no
secrets, nothing billed. Every level below L5 costs $0 cash - only notional is drawn, by the
agent sessions themselves.

See also: [`../../install.ps1`](../../install.ps1), [the runbook's solo vs bot section](../RUNBOOK.md#solo-mode-vs-bot-mode).
Next: [L1 - Gates](L1-gates.md).
