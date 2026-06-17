# Mathlib issue draft (copy-paste ready)

Use this file to open a Mathlib discussion issue. Distilled from
`docs/upstream/MATHLIB_CONTAINER_AUDIT.md`.

---

## Title

Audit polynomial functor and W-type API overlap for possible container examples

---

## Body

The standalone package [lean-containers](https://github.com/fraware/lean-containers) develops a
mathlib-free API for container signatures, polynomial functors, and W-types:

- `Container` (`shape`, `pos`), `Poly sig`, `Poly.map` with `@[simp]` lemmas
  (`map_shape`, `map_children`, `map_id`, `map_comp`),
- `W sig`, `W.fold`, `W.fold_sup`,
- examples: lists/trees (`ListSig`, `TreeSig` in `Examples.lean`), plus transition-system trees in
  `CSLibExamples.lean`.

### Findings (Lean 4.31 line)

Mathlib already has a mature univariate stack:

| lean-containers | Mathlib |
|-----------------|---------|
| `Container` with `shape`, `pos` | `PFunctor` with `A`, `B` in `Mathlib/Data/PFunctor/Univariate/Basic.lean` |
| `Poly sig α` as a structure | `P α` as `Σ a, B a → α` |
| `Poly.map` | `PFunctor.map` |
| `W sig`, `W.fold` | `WType`, `WType.elim`; `PFunctor.W` with `dest_mk` |

Local `Poly.map_*` and `W.fold_sup` lemmas are useful for structure-based `Poly` packaging but
duplicate Mathlib's sigma-based simp set unless tied to an equivalence `Poly sig α ≃ P α`.

### Questions for Mathlib maintainers

1. Should new examples and simp lemmas extend **`PFunctor` / `WType`** directly, or is there
   appetite for a `Container` synonym and structure-based `Poly` packaging?
2. Is there a preferred home for **small W-type examples** (trees, branching transition systems)
   adjacent to `Mathlib/Data/W/Basic.lean` or `Mathlib/Data/PFunctor/Univariate/`?
3. Would a thin **`Poly sig α ≃ P α`** equivalence be welcome before any category-theory bridge?

### Out of scope for a first interaction

- Introducing `Container` as a new core type without maintainer sign-off.
- Porting `M sig` (final-coalgebra placeholder) or release/Docker tooling from lean-containers.

The first deliverable should be maintainer feedback on duplication risk and naming.

### References

- Full audit: `docs/upstream/MATHLIB_CONTAINER_AUDIT.md` in lean-containers
- Key Mathlib files: `Data/PFunctor/Univariate/Basic.lean`, `Data/W/Basic.lean`,
  `Data/PFunctor/Multivariate/W.lean`

---

## Before submitting

- [ ] Confirm Mathlib baseline branch matches Lean 4.31
- [ ] Search Mathlib for recent `PFunctor` / `WType` changes since the audit date
- [ ] Choose issue labels (e.g. `data`, `PFunctor`, `documentation`)
- [ ] Link to a lean-containers tag or branch with the overlap notes
