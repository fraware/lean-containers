# Mathlib overlap notes

Comparison of `lean-containers` with Mathlib 4.31. Use this when deciding whether to depend on
this package, Mathlib, or both.

**Do not introduce a parallel `Container` type in Mathlib without maintainer agreement.** Mathlib
already provides `PFunctor` and `WType`; the main risk is duplicating that stack under different
names.

## Local API

From `src/Containers.lean`:

| Local name | Role |
|------------|------|
| `Container` | Record `shape : Type`, `pos : shape → Type` (container signature) |
| `Poly sig α` | Polynomial functor value: `⟨shape, children : pos shape → α⟩` |
| `Poly.map` | Post-composition on child labels; `Functor (Poly sig)` instance |
| `Poly.map_shape`, `Poly.map_children`, `Poly.map_id`, `Poly.map_comp` | Named `@[simp]` lemmas |
| `W sig` | Initial algebra: `W.sup s children` |
| `W.fold` | Recursor from `Poly sig X → X` |
| `W.fold_sup` | Computation lemma for `W.fold` on `W.sup` |

`ListSig` and `TreeSig` are pedagogical signatures; `Examples.lean` and `CSLibExamples.lean` show
usage patterns.

---

## 1. Does Mathlib already have a container or polynomial-functor abstraction?

**Yes — a mature univariate stack, plus a separate minimal W-type layer.**

Mathlib's preferred packaged abstraction is **`PFunctor`** in
[`Mathlib/Data/PFunctor/Univariate/Basic.lean`](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/Data/PFunctor/Univariate/Basic.lean):

- `PFunctor` is a structure with fields `A : Type` and `B : A → Type`.
- `P α` is `Σ x : P.A, P.B x → α` (sigma presentation).
- `PFunctor.map`, `id_map`, `map_map`, and `LawfulFunctor` are already present.
- Composition (`comp`), lifting predicates/relations, and multivariate variants live in sibling files
  under `Mathlib/Data/PFunctor/`.

The local `Container` / `Poly` API is the **same mathematical object** in a different packaging:

| lean-containers | Mathlib |
|-----------------|---------|
| `Container` with `shape`, `pos` | `PFunctor` with `A`, `B` |
| `Poly sig α` as a structure | `P α` as `Σ a, B a → α` |
| `Poly.map` | `PFunctor.map` |

Mathlib does **not** use the name `Container` for this signature. The word "container" appears in
comments and in the QPF / species literature (`MvPFunctor`, multivariate W/M constructions), not as a
standalone `Container` structure in the root namespace.

**Conclusion:** Mathlib already has polynomial-functor infrastructure. A new `Container` type would
duplicate `PFunctor` unless carefully aligned via a thin equivalence layer.

---

## 2. Does Mathlib already have W-type recursion lemmas in a nearby file?

**Yes — in `Mathlib/Data/W/Basic.lean` and `Mathlib/Data/PFunctor/Univariate/Basic.lean`.**

- [`Mathlib/Data/W/Basic.lean`](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/Data/W/Basic.lean)
  defines `WType β` with constructor `WType.mk`, sigma equivalence (`equivSigma`), and eliminator
  `WType.elim` (the same recursion principle as `W.fold`).
- [`Mathlib/Data/PFunctor/Univariate/Basic.lean`](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/Data/PFunctor/Univariate/Basic.lean)
  defines `PFunctor.W` as `WType P.B`, with `W.mk`, `W.dest`, and `W.dest_mk` / `W.mk_dest`.

Local `W.fold_sup` is definitionally `rfl` on `W.sup`, analogous to unfolding `WType.elim` on
`WType.mk`. Mathlib does not currently export a lemma named `fold_sup`, but the recursion API exists
as `WType.elim` and `PFunctor.W.dest_mk`.

Multivariate W-type theory (for QPFs) lives in
[`Mathlib/Data/PFunctor/Multivariate/W.lean`](https://github.com/leanprover-community/mathlib4/blob/master/Mathlib/Data/PFunctor/Multivariate/W.lean).

**Conclusion:** W-type recursion is present; the gap is **naming, simp normal form, and examples**,
not the core eliminator.

---

## 3. Where would Mathlib extensions belong?

| Area | Fit | Notes |
|------|-----|-------|
| `Mathlib/Data/PFunctor` | **Primary** | Natural home for map lemmas, examples, and any `Container ≃ PFunctor` bridge |
| `Mathlib/Data/W` | **Secondary** | For `elim`/`fold` computation lemmas and encodability-adjacent examples |
| `Mathlib/Logic` | Low | No dedicated container theory; W-types are data, not logic infrastructure |
| `Mathlib/CategoryTheory` | **Later** | Endofunctor-on-`Type` and initial-algebra functoriality belong after the data API is settled |

Category-theoretic packaging (`Poly sig` as endofunctor, natural transformations from container
morphisms) should wait until maintainers confirm whether examples should use `PFunctor` directly or
a renamed/equivalent API.

**Conclusion:** If Mathlib wants new material, start with examples and simp lemmas adjacent to
existing `PFunctor` / `WType` files. See `docs/upstream/mathlib-issue-draft.md` for a copy-paste
issue template.

---

## 4. Should local `Poly.map_*` lemmas move to Mathlib?

**Remain in this package for now; Mathlib already has equivalent `PFunctor` map lemmas.**

Mathlib's `PFunctor.Univariate.Basic` already includes:

- `PFunctor.map_eq` (shape and children decomposition),
- `PFunctor.id_map`,
- `PFunctor.map_map`,
- `map_eq_map` linking `Functor.map` and `PFunctor.map`.

The local `Poly.map_shape`, `Poly.map_children`, `Poly.map_id`, and `Poly.map_comp` lemmas are
useful here because `Poly` is a **structure** with named fields `shape` and `children`, whereas
Mathlib's sigma presentation uses `.1` / `.2`. Porting the lemmas verbatim would duplicate
Mathlib's simp set unless tied to an equivalence `Poly sig α ≃ P sig α`.

Similarly, `W.fold_sup` should stay local until maintainers agree on whether downstream users should
use `WType.elim`, `PFunctor.W.dest_mk`, or a new `fold` alias.

**Conclusion:** Keep lemmas local until (a) an equivalence to `PFunctor` is accepted in Mathlib,
and (b) maintainers confirm desired simp normal form.

---

## Suggested Mathlib discussion topic

**Title:** Audit polynomial functor and W-type API overlap for possible container examples

The standalone package [lean-containers](https://github.com/fraware/lean-containers) develops a
mathlib-free API for container signatures, polynomial functors, and W-types:

- `Container` (`shape`, `pos`), `Poly sig`, `Poly.map` with `@[simp]` lemmas
  (`map_shape`, `map_children`, `map_id`, `map_comp`),
- `W sig`, `W.fold`, `W.fold_sup`,
- examples: lists/trees (`ListSig`, `TreeSig`), plus transition-system trees in
  `CSLibExamples.lean`.

**Questions for Mathlib maintainers:**

1. Should new examples and simp lemmas extend **`PFunctor` / `WType`** directly, or is there
   appetite for a `Container` synonym and structure-based `Poly` packaging?
2. Is there a preferred home for **small W-type examples** (trees, branching transition systems)
   adjacent to `Mathlib/Data/W/Basic.lean` or `Mathlib/Data/PFunctor/Univariate/`?
3. Would a thin **`Poly sig α ≃ P α`** equivalence be welcome before any category-theory bridge?

**Out of scope for a first Mathlib interaction:**

- Introducing `Container` as a new core type without maintainer sign-off.
- Porting `M sig` (final-coalgebra placeholder) or release/Docker tooling from this repo.

---

## Reference metadata

| Field | Value |
|-------|-------|
| Mathlib baseline consulted | master @ Lean 4.31 line (2026-06) |
| Key Mathlib files | `Data/PFunctor/Univariate/Basic.lean`, `Data/W/Basic.lean`, `Data/PFunctor/Multivariate/W.lean` |
| Open question | Whether Mathlib prefers structure-based `Poly` vs sigma `P`; needs maintainer input |
