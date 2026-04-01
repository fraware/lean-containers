# Distribution notes (maintainers)

This document defines the release contract for this repository.

## Release source of truth

- `VERSION` contains the canonical semantic version `X.Y.Z`.
- `Lakefile.lean` must set `version := v!"X.Y.Z"` to the same value.
- Git release tag must be `vX.Y.Z`.
- Release archive name must be `lean-containers-vX.Y.Z.tar.gz`.

## Required repo-root artifacts

- `lake-manifest.json`
- `Lakefile.lean`
- `lean-toolchain`
- `VERSION`
- `LICENSE`
- `README.md`

## Pre-release validation checklist

Run from repository root:

1. `bash scripts/check-release-consistency.sh` (or `scripts\check-release-consistency.bat`)
2. `lake build`
3. `lake env lean FinalProductionTest.lean`
4. optional: `lake exe lean-containers`

## CI release behavior

On GitHub Release:

1. Validate tag/version consistency via `scripts/check-release-consistency.sh`.
2. Build and push Docker image tags derived from release metadata.
3. Create source archive `lean-containers-vX.Y.Z.tar.gz`.
4. Upload release archive to GitHub Releases.

## Docker notes

- Local check:
  - `docker build -t lean-containers .`
  - `docker run --rm lean-containers Main.lean`
- Published image location:
  - `ghcr.io/<owner>/lean-containers`

## Bump procedure

1. Update `VERSION` to target `X.Y.Z`.
2. Update `Lakefile.lean` `version := v!"X.Y.Z"` to match.
3. Run validation checklist.
4. Tag and publish `vX.Y.Z`.
