# The owner's runbook — how to actually use conducted

You are the **owner**. You never read code, never review diffs, never manage agents' work. Your
whole job is three things: **say what you want, answer rulings, review showcases.** Everything
else is the machine's problem. This page is everything a human does, start to finish.

## One-time machine setup (~10 minutes)

1. Install [Claude Code](https://claude.com/claude-code) and the [GitHub CLI](https://cli.github.com/); run `gh auth login` as yourself.
2. Clone this repo and install the skills:

       git clone https://github.com/shobman/conducted && cd conducted && ./install.ps1

3. That's it. Re-run `./install.ps1` after pulling updates (a Principal will tell you when your
   projects trail the doctrine version).

## Start a project

Open a terminal in your repo (empty or existing — both work) and run:

    claude
    /principal

- **Empty repo:** the Principal interviews you — what you're building, what winning looks like,
  what you want in your hands first, roughly what you'll spend. Answer in plain language.
- **Existing repo:** it scouts first, then asks you to confirm its picture. Far fewer questions.

Either way it ends with a **PR whose description is the plan**. Read the description (not the
files), comment like you'd comment on a colleague's proposal, merge when it reads like your
project. It will also ask you to choose a **mode** — see below; say "solo" for your first project.

## The loop (this is 95% of your life with conducted)

1. The Principal ends every session with a **dispatch board** — a short list like:

       READY TO DISPATCH
         work/some-node  →  claude --model opus "/conduct work/some-node"

2. For each READY line: open a new terminal tab in the repo, paste the command. That's a
   **conductor** — it builds that one piece, end to end, with its own agent fleet and an
   independent evaluator. You don't supervise it.
3. When a piece is done you get a **showcase PR**. The description tells you: what was decided on
   your behalf, what you can now do, how to try it, the evidence, and any open rulings. Try the
   thing if you can. Comment. Merge when satisfied (solo mode) or approve (bot mode).
4. When the board is empty or you want a fresh look, run `/principal` again — it re-reads
   everything from the repo and deals a new board. Sessions are disposable; the repo is the state.

## Your three entry points (where you start work)

Everything you initiate starts with one of three commands, in any repo, any time:

- **`/idea`** — you've had a thought. Dump it raw; it won't interrupt you. Then it checks the idea
  against the repo (already built? already ruled on? contradicts something?), asks the two or three
  questions that would actually change what gets built, sizes it, and files it as a PR you can read.
- **`/feedback`** — you've just looked at something and have a reaction. "This feels wrong" is a
  complete sentence here. It works out what you were looking at, reads it, helps you say what you
  expected versus what you saw, and files it — in your words, not cleaned up.
- **`/principal`** — you want the map: what's done, what's next, what it costs, what needs you.

**Pull, not push.** The Desk is a place you *go*, never a thing that nags you. Nothing here pings
you, chases you, or fills a queue that makes you feel behind. Work waits in the repo — patiently and
indefinitely — until you come and look. You are not on call for your own project.

## Your three jobs, precisely

- **Rulings.** Agents will escalate taste, priorities, irreversible actions, and spend. Answer
  them; the answer gets recorded as law so nobody asks twice.
- **Showcases.** Review the product, not the code. "The underline is murky" is exactly the kind of
  feedback only you can give — say it.
- **Money.** You set a cap; agents price work before doing it and stop at the cap. "What does $X
  get me?" is a question the Principal answers with a menu.

## Solo mode vs bot mode

- **Solo (default, zero setup):** agents work under your GitHub identity; nothing merges until you
  say so in the session or click merge. Honest limitation: your approval is a conversation, not a
  recorded gate — fine for one project and one human paying attention.
- **Bot (one-time, ~10 min):** a machine account authors all agent work, and GitHub then *requires*
  your recorded approval to merge — plus history shows exactly what agents did vs what you did.
  Upgrade when you run multiple projects, multiple concurrent conductors, or you want the audit
  trail. How: create a machine account, run `ops/setup-project-repo.ps1 -Repo <owner/name>` from
  this repo, create its **classic** PAT with scopes `repo` + `workflow` + `read:org`, fill in the
  project's `docs/BOT.md`. (Classic, not fine-grained: fine-grained tokens can't reach repos the
  bot doesn't own, and the bot is a collaborator by design; `workflow` is required because
  conducted ships a CI gates file the bot must push; `read:org` because gh's GraphQL commands
  need it.) The script prints the checklist.

  **Where the token lives (Windows):** in your own terminal — never in an agent chat — run
  `setx CONDUCTED_BOT "<the PAT>"` once. The name matters: it is NOT `GH_TOKEN`, so your
  personal gh/git stay signed in as you; agent sessions activate it themselves with
  `export GH_TOKEN="$CONDUCTED_BOT" && gh auth setup-git` before their first GitHub write.
  `setx` reaches new terminals only — relaunch any session that was open when you set it. When
  the PAT is renewed (every ~90 days), the same `setx` updates it everywhere at once.

## Which level am I at, and what's next

conducted is adopted in levels (the [maturity ladder](../README.md#the-maturity-ladder)). You never
have to climb; add a rung only when a project makes you want it. To place yourself, read down this
list and stop at the first rung you have *not* done:

- **L0 - Skills.** You ran `install.ps1` and you drive projects with `/principal` and `/conduct` in
  solo mode. This is a complete way to run a project. -> [docs/setup/L0-skills.md](setup/L0-skills.md)
- **L1 - Gates.** Your project repo has `.github/workflows/gates.yml` and CI runs on every PR
  (secret scan, tests, territory). If the check isn't *required* yet, that arrives with L2's setup
  script or a one-time branch-protection change. -> [docs/setup/L1-gates.md](setup/L1-gates.md)
- **L2 - Author bot.** `docs/BOT.md` says `mode: bot`, a machine account authors agent work, and
  GitHub requires your recorded approval to merge. Add this when you want an audit trail or run
  concurrent conductors. -> [docs/setup/L2-author-bot.md](setup/L2-author-bot.md)
- **L3 - Clerk reviewer.** The `CONDUCTED_CLERK` Actions secret is set, and docs-only bookkeeping
  PRs land themselves without your click. Add this when you're tired of clicking merge on paperwork.
  -> [docs/setup/L3-clerk-reviewer.md](setup/L3-clerk-reviewer.md)
- **L4 - Vault.** You run more than one project and keep a private vault repo of estate state
  (membership, budgets, governor config). -> [docs/setup/L4-vault.md](setup/L4-vault.md) and
  [docs/VAULT.md](VAULT.md)
- **L5 - Runner.** A scheduled task wakes principals on ready work under a window governor, so work
  flows even while you ignore the board. -> [docs/setup/L5-runner.md](setup/L5-runner.md)

Each level's doc states exactly what it costs, how to adopt it on **one repo at a time**, and the
single small act that undoes it. Nothing here is a one-way door.

## When something looks wrong

- **Red X's on a PR:** read the failing check's name first — the gates are strict by design
  (tests, secrets, territory). Ask the session that opened the PR; don't debug it yourself.
- **A PR stays red on a gate you already fixed on main:** GitHub's "Re-run" replays the OLD
  workflow snapshot, and even close/reopen can reuse a stale merge ref. Force a truly fresh run
  with `gh pr update-branch <n>` (or any new commit on the branch) — the new merge picks up
  main's fixed gate.
- **A conductor seems stuck or you closed the laptop mid-node:** nothing is lost — run
  `/principal`; it judges every node from repo state and replans or resumes.
- **An agent says "bot auth needs renewal":** the bot's token expired (every ~90 days). Renewal
  steps are in that project's `docs/BOT.md`; five minutes, then everything resumes.
- **You want to change direction:** just say so to a Principal session. Direction changes are its
  job; it will restructure the map and show you before anything is built.
