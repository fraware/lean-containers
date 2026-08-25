# Contributing

Thanks for contributing to `lean-containers`.

## Development workflow

1. Use the pinned toolchain from `lean-toolchain`.
2. Run from repo root:
   - `lake build`
   - `lake env lean FinalProductionTest.lean`
3. If release metadata is touched, also run:
   - `bash scripts/check-release-consistency.sh` (Unix)
   - `scripts\check-release-consistency.bat` (Windows)

## Pull request requirements

- Keep PRs focused and reviewable.
- Explain motivation and behavioral impact.
- Ensure the build and smoke test pass locally.
- Update docs when public API, setup, or release flow changes.

## Code standards

- Preserve the small, explicit API design.
- Avoid introducing unnecessary dependencies.
- Keep naming and style consistent with `src/Containers.lean`.
- Add or update smoke checks in `FinalProductionTest.lean` when behavior changes.

## Versioning and releases

- Canonical version is in `VERSION` as `X.Y.Z`.
- `lakefile.lean` must match with `version := v!"X.Y.Z"`.
- Git tags use `vX.Y.Z`.
- Release artifacts are named `lean-containers-vX.Y.Z.tar.gz`.

Detailed maintainer checklist: `DISTRIBUTION_README.md`.

## Good first issues

Use issues labeled `good first issue` for starter-friendly tasks such as:

- improving examples
- clarifying docs
- adding small, well-scoped lemmas or checks
