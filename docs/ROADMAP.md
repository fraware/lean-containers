# Roadmap

Planned and possible future work for `lean-containers`. The current release focuses on a small,
mathlib-free core API.

## Current release (0.1.x)

- Container signatures (`Container`), polynomial functors (`Poly`, `Poly.map`), W-types (`W`,
  `W.fold`)
- Named `@[simp]` lemmas for `Poly.map` and `W.fold`
- Example signatures: `ListSig`, `TreeSig`
- Smoke examples: `Examples.lean`, `CSLibExamples.lean`

## Future directions

- **Categorical bridge:** interpret `Poly sig` as an endofunctor on `Type`, container morphisms, and
  W-types as initial algebras. Requires alignment with Mathlib conventions; see
  `docs/mathlib-overlap.md`.
- **`M sig` development:** the nominal `M` type is a placeholder, not a final-coalgebra API.
- **Additional examples:** more W-type interpretations and container signatures as use cases arise.

This package intentionally stays mathlib-free. Users who need Mathlib's full `PFunctor` / `WType`
stack should depend on Mathlib directly or use both libraries with an equivalence layer once
maintainers agree on packaging.
