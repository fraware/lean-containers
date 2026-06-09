# Extraction ledger

Tracks Mathlib and CSLib upstream candidates from `lean-containers`. Overlap columns are filled during audit PRs; this sprint establishes the ledger only.

| Candidate | Current local declaration | Mathlib overlap checked? | CSLib overlap checked? | Proposed upstream target | Review risk | Status |
|-----------|---------------------------|--------------------------|------------------------|--------------------------|-------------|--------|
| Poly.map simp API | `Poly.map_shape`, `Poly.map_children`, `Poly.map_id`, `Poly.map_comp` | No | No | Mathlib polynomial functor / container API (TBD after audit) | Low | Local lemmas added |
| W.fold computation lemma | `W.fold_sup` | No | No | Mathlib W-type recursion API (minimal, example-driven) | Low | Local lemma added |
| Container morphism structure | `Container` (`shape`, `pos`) | No | No | Mathlib category bridge (later PR) | Medium | Not started |
| Polynomial functor as Type endofunctor | `Poly`, `Poly.map`, `Functor (Poly sig)` | No | No | Mathlib endofunctor on `Type` (after audit) | Medium | Not started |
| W-type initial algebra examples | `W`, `W.fold`, `TreeSig`, `Examples.lean` | No | No | Mathlib examples file | Low | Examples added locally |
| Transition-system example for CSLib | (planned) | No | No | CSLib semantics examples | Medium | Not started |
