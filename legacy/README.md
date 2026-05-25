# legacy/

Drop your **exported VBA code and reference Excel workbooks** here. Treat as read-only —
this is the source of truth for business logic during migration.

Copilot applies `.github/instructions/vba-migration.instructions.md` to anything in this
folder, enforcing the restate → migrate → parity-test loop.

> Do not commit real/confidential data. See `.gitignore`.
