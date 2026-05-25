# Claude (Sonnet 4.6) in Copilot for a Risk Analyst — Solid Configuration

A reference + presentation guide for using Claude Sonnet 4.6 in GitHub Copilot (VS Code)
with a `soul.md` / `claude.md`-style architecture, SQL Developer MCP for data awareness,
and an Excel/VBA → Python migration workflow.

---

## The key thing to get right first

`soul.md` and `claude.md` are **Claude Code conventions, not Copilot ones.** GitHub Copilot
in VS Code will **not** auto-read a file just because you call it `soul.md` or `CLAUDE.md`.
Copilot only auto-loads three things, in this precedence order (highest wins):

1. **Personal** — `~/.copilot/copilot-instructions.md` (follows you across every repo)
2. **Path-scoped** — `.github/instructions/*.instructions.md` (with an `applyTo:` glob)
3. **Repo-wide** — `.github/copilot-instructions.md`
4. `AGENTS.md`
5. Org instructions

So the "soul.md / claude.md architecture" is a **conceptual layering you implement on top of
Copilot's real files.** The good news: it maps almost perfectly.

---

## The solid configuration (3-layer "soul / brain / lobes" model)

| Conceptual layer | What it holds | Where it actually lives | Scope |
|---|---|---|---|
| **SOUL** | Who Claude is *for you* — identity, non-negotiables, how you like answers | `~/.copilot/copilot-instructions.md` | You, every project |
| **BRAIN (CLAUDE.md)** | This tool's context — stack, layout, migration rules | `.github/copilot-instructions.md` | This repo |
| **LOBES** | Specialized rules per file type | `.github/instructions/*.instructions.md` | Path-matched |

```
your-tool-repo/
├─ .github/
│  ├─ copilot-instructions.md          # BRAIN: project context
│  └─ instructions/
│     ├─ python.instructions.md        # applyTo: "src/**/*.py"
│     ├─ sql.instructions.md           # applyTo: "sql/**/*.sql"
│     └─ vba-migration.instructions.md # applyTo: "legacy/**"
├─ .vscode/
│  └─ mcp.json                         # MCP servers (commit for the team)
├─ legacy/                             # exported VBA + reference workbooks
├─ src/  tests/  sql/
└─ (~/.copilot/copilot-instructions.md = your SOUL, lives in your home dir)
```

**Why this split is solid:** the **soul** rides with you into every tool you build, the
**brain** is committed so it's identical for anyone (or future-you) opening the repo, and the
**lobes** keep Python rules out of SQL prompts and vice-versa — Copilot only injects the
matching `.instructions.md`.

---

## File contents (copy-paste starters)

### SOUL — `~/.copilot/copilot-instructions.md`

```markdown
# How you work with me
I'm a risk analyst building internal analytics tools (not production software).
You are my pair-engineer with strong Python, SQL, and quantitative-risk fluency.

## Non-negotiables
- Never invent numbers, thresholds, or regulatory rules. If unsure, say so.
- Every calculation must be auditor-explainable: state assumptions inline.
- Treat all data as confidential — never echo real customer/PII values into chat or commits.
- Destructive/schema SQL (DROP/DELETE/UPDATE/TRUNCATE): propose it, never run without my explicit "yes".
- Reproducibility over cleverness: deterministic, testable, documented.

## How I like answers
- Recommendation first, then the why. Show diffs, not full rewrites. Flag uncertainty explicitly.
```

### BRAIN — `.github/copilot-instructions.md`

```markdown
# Project: <tool name> — Excel/VBA → Python migration

## What this is
Internal risk tooling migrated from Excel/VBA to Python. The legacy workbook in
/legacy is the source of truth for business logic. Python output MUST match Excel
output within <tolerance> on the golden-file test set.

## Stack & conventions
- Python 3.x, pandas/numpy, openpyxl for Excel I/O.
- Type hints everywhere; pure functions where possible.
- pytest; every migrated routine has a parity test vs. its Excel golden file.
- Oracle data access via the SQLcl MCP server — read the schema before writing queries.

## Layout
- /legacy  exported VBA + workbooks (read-only)   - /src  modules
- /sql     reviewed, parameterized queries        - /tests  parity + unit tests
```

### LOBE — `.github/instructions/python.instructions.md`

```markdown
---
applyTo: "src/**/*.py"
---
- Vectorized pandas; avoid row loops unless mirroring VBA logic 1:1.
- No hardcoded paths/credentials. Match VBA rounding exactly (Decimal or documented float tolerance).
- Each public function's docstring cites the originating VBA Sub/Function name.
```

### LOBE — `.github/instructions/vba-migration.instructions.md`

```markdown
---
applyTo: "legacy/**"
---
When migrating a VBA routine:
1. Restate the business logic in plain English; confirm with me first.
2. List inputs, outputs, edge cases, Excel quirks (1-based indexing, type coercion, rounding).
3. Emit Python + a parity test feeding identical inputs, asserting equivalence to the workbook.
4. Log any discrepancy as a TODO with the magnitude of the difference.
```

### LOBE — `.github/instructions/sql.instructions.md`

```markdown
---
applyTo: "sql/**/*.sql"
---
- Inspect the schema via the SQLcl MCP tools before composing a query.
- SELECT-only by default; any write/DDL must be called out and approved.
- Parameterize; never string-concatenate runtime values.
- Add a comment block: purpose, source tables, expected row magnitude.
```

---

## The "data awareness" piece — SQL Developer MCP

This is the headline feature: the **Oracle SQLcl MCP server** lets Claude *see* the real
database — list tables, read column types, sample rows, run SELECTs — so the SQL and Python
it generates is grounded in your actual schema instead of guessed.

**For Copilot specifically, it's near-zero config:**

- Install the **Oracle SQL Developer extension for VS Code** (≥ 25.2.0).
- Define at least one DB connection **with the password saved**.
- SQL Developer auto-registers the SQLcl MCP server for Copilot — no `mcp.json` editing needed.
- In Copilot Chat, switch to **Agent mode**, click the **tools** button, enable the SQLcl tools.

A shareable `.vscode/mcp.json` (for teammates on other agents, or to make it explicit):

```json
{
  "servers": {
    "sqlcl": {
      "type": "stdio",
      "command": "C:\\path\\to\\sqlcl\\bin\\sql.exe",
      "args": ["-mcp"]
    }
  }
}
```

**Compliance angle for your audience:** the MCP server runs **locally**, so the database
connection and data never leave your machine to a third party.

---

## Suggested slide flow (brief)

1. **The shift** — VBA macros → Python tools, with Claude Sonnet 4.6 as pair-engineer in Copilot Agent mode.
2. **Myth-buster** — `soul.md`/`CLAUDE.md` aren't magic filenames; Copilot reads specific files. Show the precedence table.
3. **The 3-layer architecture** — soul / brain / lobes diagram (the tree above).
4. **Data awareness** — SQLcl MCP demo: "show me the columns in `RISK_EXPOSURES`" → grounded query.
5. **Migration discipline** — the parity-test loop (restate → migrate → assert vs. golden file).
6. **Guardrails** — no fabricated numbers, no PII in prompts, no unapproved writes, local-only DB.

---

## Assumptions

- Your DB is **Oracle** (implied by "SQL Developer MCP").
- These are **internal analyst tools**, not shipped software.

If either differs, the SOUL and BRAIN files are where you'd tweak it.

---

## Sources

- [Use custom instructions in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [Add custom instructions for Copilot — GitHub Docs](https://docs.github.com/en/copilot/how-tos/copilot-on-github/customize-copilot/add-custom-instructions)
- [Add and manage MCP servers in VS Code](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)
- [Getting Started with our MCP Server for Oracle Database (thatjeffsmith)](https://www.thatjeffsmith.com/archive/2025/07/getting-started-with-our-mcp-server-for-oracle-database/)
- [Starting and Managing the SQLcl MCP Server — Oracle Docs](https://docs.oracle.com/en/database/oracle/sql-developer-command-line/26.1/sqcug/starting-and-managing-sqlcl-mcp-server.html)
- [Chat with Your Oracle Database: SQLcl MCP + GitHub Copilot (DZone)](https://dzone.com/articles/hat-with-your-oracle-database-sqlcl-mcp-github)
