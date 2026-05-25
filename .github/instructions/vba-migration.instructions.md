---
applyTo: "legacy/**"
---

# VBA → Python migration rules (LOBE)

Applied automatically whenever Copilot works with files under `legacy/`.

When migrating a VBA routine, follow this loop:

1. **Restate** the business logic in plain English first, and confirm it with me before
   writing any Python.
2. **Enumerate** inputs, outputs, edge cases, and Excel-specific quirks: 1-based indexing,
   implicit type coercion, rounding, empty-cell handling, date serial numbers.
3. **Emit** the Python module into `src/` **plus a parity test** in `tests/` that feeds the
   same inputs and asserts equivalence to the workbook's outputs (golden file).
4. **Log** any discrepancy as a `TODO` comment with the magnitude of the difference.

Rules:

- `legacy/` is read-only reference material — never modify the original VBA/workbooks.
- Preserve the exact numeric behaviour of the original; correctness vs. the workbook beats
  idiomatic elegance.
- If the original logic is ambiguous or appears buggy, surface it — do not silently "fix" it.
