<div align="center">

# lean-containers

`lean-containers` is a Lean 4 library for container signatures, polynomial functors, and W-types.  
The package is intentionally small, mathlib-free, and focused on a clear core API.

</div>

## Install and import

Add this to your `Lakefile.lean`:

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
| Lean toolchain | `leanprover/lean4:v4.15.0` (`lean-toolchain`) |
| Lake manifest | root `lake-manifest.json` |
| Package version | `0.1.0` (`VERSION`) and `v!"0.1.0"` in `Lakefile.lean` |
| SPDX license | `MIT` |

## Local development

```bash
lake build
lake env lean FinalProductionTest.lean
lake exe lean-containers
```

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
