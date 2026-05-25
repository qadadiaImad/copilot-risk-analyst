---
applyTo: "sql/**/*.sql"
---

# SQL rules (LOBE)

Applied automatically whenever Copilot edits files under `sql/`.

- **Inspect the schema via the SQLcl MCP tools before composing a query** — confirm table
  and column names against the live database, don't assume them.
- `SELECT`-only by default. Any write or DDL (`INSERT`/`UPDATE`/`DELETE`/`DROP`/`TRUNCATE`/
  `ALTER`) must be flagged explicitly and approved before running.
- Parameterize values; never string-concatenate runtime/user input into SQL.
- Prefix every query with a comment block stating: purpose, source tables, and the
  expected row-count magnitude.
- Prefer explicit column lists over `SELECT *`.
- Treat all returned data as confidential — never paste real customer/PII values into chat.
