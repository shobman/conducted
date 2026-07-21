# Bot identity — mode + plumbing record (owner-maintained)

mode: <solo | bot>          # solo = agents act as the owner by explicit DECISIONS ruling —
                            # fine for a first project; the merge gate is then behavioral and
                            # every wake board says so. bot = the fields below are live.
bot-login: <BOT-USERNAME-or-n/a>
pat-expires: <YYYY-MM-DD-or-n/a>   # wake warns when <14 days out; renewal is an owner task
pat-type: classic            # NOT fine-grained: a fine-grained PAT reaches only repos its own
                             # account OWNS, and the bot is deliberately a mere collaborator on
                             # the owner's repos. Classic + collaborator is the supported shape;
                             # containment = the bot's memberships, not the token's repo list.
pat-scopes: repo, workflow, read:org   # workflow: conducted lands gates.yml under
                                       # .github/workflows/, which classic PATs cannot push
                                       # without it; read:org: gh's GraphQL commands need it
last-verified: <YYYY-MM-DD>

## How agent sessions authenticate
Launch agent sessions with the bot's fine-grained PAT in the environment: `GH_TOKEN=<token>` (gh
gives an env token precedence over the keyring) plus `gh auth setup-git` so git pushes use it too.
The owner's keyring stays out of agent reach; approvals happen in the owner's browser. Never paste
the token into an agent conversation — transcripts are not a secrets store.

## Renewal (owner, ~5 min, every PAT cycle)
1. On the bot account: regenerate the classic PAT with scopes `repo`, `workflow`, `read:org`.
   (Classic tokens have no per-repo list — access follows the bot's collaborator memberships.)
2. Update the launch environment with the new token; update `pat-expires:` above.
3. Any session that hard-stopped on auth resumes normally — nothing else to fix.
