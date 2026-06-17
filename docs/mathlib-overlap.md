# Mathlib overlap (summary)

Short pointer to the full upstream audit. For maintainer-facing analysis and upstreaming guidance,
see **[`docs/upstream/MATHLIB_CONTAINER_AUDIT.md`](upstream/MATHLIB_CONTAINER_AUDIT.md)**.

## At a glance

| Question | Answer |
|----------|--------|
| Polynomial functor infrastructure in Mathlib? | **Yes** — `PFunctor` in `Mathlib/Data/PFunctor/Univariate/Basic.lean` |
| W-type API nearby? | **Yes** — `WType` in `Mathlib/Data/W/Basic.lean`; `PFunctor.W` in the PFunctor file |
| Where should extensions live? | **`Mathlib/Data/PFunctor`** (primary), **`Mathlib/Data/W`** (secondary); CategoryTheory later |
| Upstreamable local simp lemmas? | **`Poly.map_*` and `W.fold_sup` stay local** until a `Poly ≃ P` bridge is agreed |

## Local API

| Local name | Role |
|------------|------|
| `Container` | Signature: `shape`, `pos` |
| `Poly sig α` | Structure-based polynomial functor |
| `Poly.map_shape`, `Poly.map_children`, `Poly.map_id`, `Poly.map_comp` | `@[simp]` map lemmas |
| `W.fold_sup` | `W.fold` computation on `W.sup` |

## Copy-paste issue template

See [`docs/upstream/mathlib-issue-draft.md`](upstream/mathlib-issue-draft.md).
