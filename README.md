# risk-analyst-copilot

A **starter template** for risk analysts who build internal tools in **VS Code** with
**GitHub Copilot + Claude Sonnet 4.6**, with live **data awareness** via the Oracle
SQL Developer (SQLcl) MCP server.

It ships the full *"soul / brain / lobes"* instruction architecture so Copilot behaves
like a disciplined quant pair-engineer from the first prompt — **no Python code, just the
prompt/config layer** you drop on top of your own project.

> Typical use case: migrating Excel/VBA tooling to Python while keeping results
> auditable and matched to the legacy workbook.

---

## What's in here

| Path | Layer | Purpose |
|---|---|---|
| `templates/soul.copilot-instructions.md` | **SOUL** | Who Claude is *for you* — installs to `~/.copilot/` (every project) |
| `.github/copilot-instructions.md` | **BRAIN** | This project's context, stack & rules (repo-wide) |
| `.github/instructions/*.instructions.md` | **LOBES** | Path-scoped rules (Python / SQL / VBA migration) |
| `.vscode/mcp.json` | **DATA** | Optional explicit SQLcl MCP server config |
| `docs/copilot-claude-risk-analyst-setup.md` | — | The full explainer / presentation guide |
| `src/ sql/ legacy/ tests/` | — | Empty scaffolding (where *your* work goes) |

**Why the split?** The soul follows you into every repo, the brain is committed so it's
identical for the whole team, and the lobes keep Python rules out of SQL prompts and
vice-versa — Copilot only injects the instruction file whose `applyTo:` glob matches the
file you're touching.

---

## Prerequisites

1. **VS Code** with the **GitHub Copilot** + **GitHub Copilot Chat** extensions.
2. A Copilot plan that exposes **Claude Sonnet 4.6** in the model picker.
3. **Oracle SQL Developer extension for VS Code** (≥ 25.2.0) — provides the SQLcl MCP server.
4. At least one **Oracle DB connection** defined in SQL Developer **with the password saved**.

---

## Quickstart

```bash
# 1. Clone
git clone https://github.com/<you>/risk-analyst-copilot.git
cd risk-analyst-copilot

# 2. Install the personal SOUL file (one-time, per machine)
#    Windows (PowerShell):
./install.ps1
#    macOS / Linux:
./install.sh
```

That's it for the repo-level config — `.github/` and `.vscode/` are already wired up the
moment you open the folder in VS Code. The installer only handles the **personal soul**,
which lives in your home directory (`~/.copilot/copilot-instructions.md`) and can't be
committed to a repo.

### Then, in VS Code

1. Open this folder.
2. Open **Copilot Chat** → set the model to **Claude Sonnet 4.6** → switch to **Agent** mode.
3. Click the **tools** button and confirm the **SQLcl** tools are enabled (the SQL Developer
   extension auto-registers them — see [Data awareness](#data-awareness)).
4. Ask something grounded, e.g. *"List the columns in `RISK_EXPOSURES` and draft a SELECT
   for exposures above 1M EUR."* Copilot will read the real schema before answering.

---

## How the instruction layers load

GitHub Copilot only auto-reads specific files. Precedence, highest first:

1. **Personal** — `~/.copilot/copilot-instructions.md`  ← the SOUL (installed by script)
2. **Path-scoped** — `.github/instructions/*.instructions.md` (matched by `applyTo:`)
3. **Repo-wide** — `.github/copilot-instructions.md`  ← the BRAIN
4. `AGENTS.md`
5. Org instructions

> `soul.md` / `CLAUDE.md` are **Claude Code** filenames — Copilot ignores them. This repo
> uses the real Copilot files, organized into the same conceptual layers.

---

## Data awareness

The **Oracle SQLcl MCP server** lets Claude see your real database — list tables, read
column types, sample rows, run `SELECT`s — so generated SQL/Python is grounded in your
actual schema instead of guessed.

- For **Copilot it's near-zero config**: install the SQL Developer extension, save a
  connection, switch Copilot Chat to **Agent** mode, and enable the SQLcl tools.
- `.vscode/mcp.json` is included as an **explicit/shareable** declaration (and for non-Copilot
  agents). Edit the `command` path to point at your SQLcl install if you use it.
- The MCP server runs **locally** — your DB connection and data never leave your machine.

See [`docs/copilot-claude-risk-analyst-setup.md`](docs/copilot-claude-risk-analyst-setup.md)
for the full walkthrough and a ready-made presentation outline.

---

## Recommended workflow (Excel/VBA → Python)

1. Drop the exported VBA / reference workbook into `legacy/`.
2. Ask Copilot to **restate the business logic in plain English** and confirm it.
3. Have it emit the Python module into `src/` **plus a parity test** in `tests/` that asserts
   equivalence to the workbook's outputs.
4. Keep reviewed, parameterized queries in `sql/`.

The migration lobe (`.github/instructions/vba-migration.instructions.md`) enforces this loop
automatically whenever you work under `legacy/`.

---

## License

MIT — see [LICENSE](LICENSE).
