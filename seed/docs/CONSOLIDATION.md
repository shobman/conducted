# The consolidation pass — branch/worktree GC after parallel work

Run when branches or worktrees outnumber the active frontier (wake schedules it before opening
new frontier). Field origin: the queue app, 76 branches + 31 worktrees → 1 (2026-07-19). Any role may run
it; it is git plumbing, not judgment about product scope. Deletions of HELD or owner-territory
branches always wait for the owner's word.

**Step 0 — reconcile local main with the remote FIRST.** `git fetch --all --prune`; confirm
origin/main is at-or-ahead and fast-forward local main. Skipping this is the single most dangerous
error: every downstream "is it merged?" check measures against main, and a stale main marks landed
work as unmerged. (Field case: local was 27 commits behind; a naive prune would have deleted
landed work.)

**Step 1 — build the authoritative merged-set.** `gh pr list --state merged --limit 300 --json
headRefName`. Under squash-merge, `git branch --merged` does NOT flag landed branches — only `gh`
is truthful. Also list `--state open` (never touch those).

**Step 2 — classify every branch by two signals.** `ahead = git rev-list --count main..<branch>`
and `in_merged = name ∈ merged-set`. `ahead == 0` OR `in_merged` → MERGED-SAFE. `ahead > 0` AND
not in merged-set → REVIEW — the only bucket that can hide stranded work; inspect every one.

**Step 3 — the evidence standard for keepable.** Keepable = content that exists nowhere on main
and is not superseded. Proof content IS on main: (a) name in the merged-set; (b) shared commit
SHAs with a merged branch (definitive); (c) for docs/findings, a grep hit on main. Large net
deletion vs main is a strong tell (behind by landed work, not ahead). A branch NAME matching
nothing proves nothing; only content does. And contradicted content is worse than useless — a
prior keep-decision is re-tested against later rulings, never deferred to.

**Step 4 — stranded-work safety sweeps before removing anything.** (a) `git -C <wt> status
--porcelain --untracked-files=no` on every worktree — any tracked change means stop and inspect;
(b) detached-HEAD worktrees: `git merge-base --is-ancestor <sha> main`; (c) grep
findings/DECISIONS for any milestone a spike branch claims before deleting the spike.

**Step 5 — execute in order.** Kill dev services (a running process locks a worktree dir on
Windows) → `git worktree remove` each non-main worktree → `git worktree prune` → `git branch -D`
with explicit named arguments (squash-merged branches never `-d`-delete).

**Step 6 — HELD is a hard stop.** A branch marked HELD or in owner territory gets a per-branch
verdict WITH a committed written rationale, then waits for the owner — regardless of how certain
supersession looks. (Field case: a HELD branch's "obvious" supersession still hid one unique
verdict that had to be proven on main before deletion was safe.)

Record: MERGED-SAFE bulk is self-documenting via the merged-set; every REVIEW/HELD verdict gets a
committed rationale (handoff note or findings). Deleted branches stay reflog-recoverable ~90 days.
