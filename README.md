# Bypassium Codex Cloud Archive

This private archive contains the complete Bypassium workspace formerly located at:

`C:\Users\purce\Documents\Codex\2026-06-09\create-a-chrome-extension-manifest-v3`

The workspace contains the responsive website, Chrome extension, signaling servers, support bot, administration tools, build archives, tests, screenshots, reports, deployment copies, and workspace metadata.

The supplemental archive also preserves the Bypassium hardware-messenger project and the Bypassium-named files that were found in the user's Downloads folder. Extract `supplemental-bypassium-files.zip` from a user-profile directory to restore its `Documents` and `Downloads` paths. Verify those files against `supplemental-manifest-sha256.csv`.

## Integrity

- Original files: 12,593
- Original bytes: 417,785,025
- Manifest: `manifest-sha256.csv`
- Manifest SHA-256: `69d13bae720cc1c6407f34e4412dffd67e84bf7b02ed0a62fc6c39fc9c81c38f`
- Upload archive checksums: `archive-sha256.csv`
- Supplemental files: 706
- Supplemental manifest: `supplemental-manifest-sha256.csv`

## Restore and verify

Run:

```powershell
.\verify-and-restore.ps1 -Destination 'C:\path\to\restore'
```

The script extracts every archive and fails if a file is missing, has an unexpected length, or does not match its original SHA-256 hash.

The repository is intentionally private because it contains complete project history and deployment material. Runtime secrets should remain in the relevant hosting provider's secret store rather than source files.

