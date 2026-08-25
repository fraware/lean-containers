<div align="center">

# lean-containers

`lean-containers` is a Lean 4 library for container signatures, polynomial functors, and W-types.  
The package is intentionally small, mathlib-free, and focused on a clear core API.

</div>

## Install and import

Add this to your `lakefile.lean`:

```lean
require lean-containers from git
  "https://github.com/fraware/lean-containers.git" @ "v0.1.0"
```

Then import:

```lean
import Containers
```

## Minimal example

```lean
import Containers

open Containers

def p : Poly ListSig Nat :=
  { shape := some (), children := fun _ => 42 }

#check Poly.map (fun n => n + 1) p
```

## API surface

- `Container`: container signatures (`shape`, `pos`)
- `Poly sig α`: polynomial functor representation
- `Poly.map`: functorial map on `Poly`
- `W sig`, `W.fold`: inductive W-types and fold
- `M sig`: nominal placeholder for future coalgebra-oriented expansion
- example signatures: `ListSig`, `TreeSig`

## Compatibility

| Item | Value |
|------|-------|
| Lean toolchain | `leanprover/lean4:v4.34.0-rc2` (`lean-toolchain`) |
| Lake manifest | root `lake-manifest.json` |
| Package version | `0.1.0` (`VERSION`) and `v!"0.1.0"` in `lakefile.lean` |
| SPDX license | `MIT` |

## Build verification

The repository is currently being revalidated on Lean **4.34.0-rc2**. Current compatibility should be inferred only from the latest successful CI run for the pinned toolchain.

The previous recorded full verification was on **Windows** with Lean **4.31.0** on 2026-06-17 and is retained here as historical evidence only:

| Step | Command | Historical result |
|------|---------|-------------------|
| Update | `lake update` | Pass |
| Build | `lake build` | Pass (3 jobs) |
| Examples | `lake env lean Examples.lean` | Pass |
| CSLib examples | `lake env lean CSLibExamples.lean` | Pass |
| Production test | `lake env lean FinalProductionTest.lean` | Pass |
| Executable | `lake exe lean-containers` | Pass |
| Makefile (Windows) | `make -f Makefile.win test` | Pass |

CI (`.github/workflows/ci.yml`) and `Dockerfile` target Lean **4.34.0-rc2**.

## Local development

```bash
lake build
lake env lean FinalProductionTest.lean
lake env lean Examples.lean
lake env lean CSLibExamples.lean
lake exe lean-containers
```

Smoke examples: `Examples.lean` (core `Poly` / `W.fold` usage) and `CSLibExamples.lean`
(transition-system trees). See `docs/transition-system-examples.md` for the latter.

## Relation to Mathlib

This package is mathlib-free by design. Mathlib already provides `PFunctor` and `WType` with
equivalent mathematics in a different packaging. Local `Poly.map_*` and `W.fold_sup` lemmas are
tuned for structure-based `Poly` values here, not for Mathlib's sigma presentation.

For the full Mathlib audit, see `docs/upstream/MATHLIB_CONTAINER_AUDIT.md` (summary:
`docs/mathlib-overlap.md`). Future work is outlined in `docs/ROADMAP.md`.

Windows release checks:

```bat
scripts\check-release-consistency.bat
```

Unix release checks:

```bash
bash scripts/check-release-consistency.sh
```

## Docker (optional)

```bash
docker build -t lean-containers .
docker run --rm lean-containers Main.lean
docker run --rm lean-containers FinalProductionTest.lean
```

## Scope and limitations

- No mathlib dependency
- No category-theory bridge layer yet
- `M sig` is not a full final-coalgebra development

## Contributing

See `CONTRIBUTING.md`.

## Maintainer release process

See `DISTRIBUTION_README.md`.

## License

MIT license in `LICENSE`.
