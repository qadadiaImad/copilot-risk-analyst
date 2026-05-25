# Project context (BRAIN) — Excel/VBA → Python risk tooling

This repo-wide file is auto-loaded by GitHub Copilot for every chat request in this
workspace. It tells Claude what this project is and the rules it must follow here.
Replace the `<...>` placeholders with your project's specifics.

## What this is

Internal risk-analytics tooling being migrated from Excel/VBA to Python. The legacy
workbook(s) in `/legacy` are the **source of truth** for business logic. Python output
MUST match the Excel output within `<tolerance, e.g. 1e-9>` on the golden-file test set
in `/tests`.

This is an internal analyst tool, not shipped production software — optimise for
correctness, auditability, and reproducibility over abstraction.

## Stack & conventions

- Python `<3.x>`, pandas / numpy, openpyxl for any Excel I/O.
- Type hints everywhere; pure functions where practical.
- Tests with pytest; **every migrated routine has a parity test** vs. its Excel golden file.
- Oracle data access via the **SQLcl MCP server** — always read the schema before writing queries.
- No hardcoded paths, secrets, or connection strings — read them from env/config.

## Repository layout

- `/legacy` — exported VBA + reference workbooks (treat as read-only)
- `/src` — Python modules
- `/sql` — reviewed, parameterized queries
- `/tests` — parity + unit tests

## Behaviour in this repo

- Lead with the recommendation, then the rationale.
- Prefer diffs over whole-file rewrites when editing.
- Never run destructive or schema-changing SQL without explicit approval.
- When unsure about a regulatory rule, threshold, or number, say so — do not guess.
