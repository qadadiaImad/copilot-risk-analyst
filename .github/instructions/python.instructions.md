---
applyTo: "src/**/*.py"
---

# Python rules (LOBE)

Applied automatically whenever Copilot edits files under `src/`.

- Use vectorized pandas/numpy operations; avoid row-by-row loops **unless** mirroring a
  VBA routine 1:1 for parity, and say so in a comment when you do.
- No hardcoded paths, credentials, or connection strings — read from env/config.
- Money and rates: use `Decimal` or document the float tolerance. Match the legacy VBA
  rounding behaviour exactly (Excel/VBA rounding differs from naive float rounding).
- Type hints on every public function; concise docstrings.
- Each public function's docstring **cites the originating VBA Sub/Function name** it replaces.
- Keep functions pure and testable; isolate I/O at the edges.
- Every migrated routine ships with a pytest parity test under `tests/`.
