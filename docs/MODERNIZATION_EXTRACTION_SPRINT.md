# Modernization and extraction sprint

This document records the first modernization and extraction plan for `lean-containers` as part of the broader category-theory contribution program targeting Mathlib and CSLib.

## Current repository position

`lean-containers` is intentionally small and mathlib-free. Its public core consists of container signatures, polynomial functors, W-types, a fold operation, and example signatures. That makes it the cleanest repository in the portfolio for extracting upstreamable mathematical infrastructure, because the core surface is compact and does not depend on tactic internals or old Mathlib APIs.

Current constraints:

- Current toolchain in `lean-toolchain`: `leanprover/lean4:v4.31.0-rc2` (matches Mathlib master at sprint time).
- Upstream Mathlib baseline for this sprint: Lean 4.31 line.
- This repository has no Mathlib dependency by design.
- There is no category-theory bridge layer yet.
- The nominal `M` type is explicitly not a developed final-coalgebra API and must not be upstreamed as mathematical infrastructure without a separate design pass.

## Sprint objective

The objective is to preserve the standalone core while extracting a Mathlib-facing package of small, reviewable contributions around containers, polynomial functors, and W-type recursion.

The first sprint must not attempt to upstream the whole repository. The upstream goal is a sequence of precise API contributions, each one independently useful and easy to review.

## Modernization gates

### Gate 1: Lean 4.31 compatibility

Run the repository against the current Lean 4.31 line without introducing Mathlib.

Required commands:

```bash
lake update
lake build
lake env lean FinalProductionTest.lean
lake exe lean-containers
```

Expected first failures to check:

- Lake syntax drift from Lean 4.15 to Lean 4.31.
- Changes in the core `Functor` or `LawfulFunctor` expectations.
- Any use of deprecated names in test or release scripts.

No upstream extraction should happen until the standalone build works on the 4.31 line.

### Gate 2: law and simp surface

After the port compiles, add explicit named lemmas around the current definitional equalities. These lemmas are useful even when proofs are currently `rfl`, because upstream users should not rely on implementation details.

Candidate local lemmas:

```lean
@[simp] theorem Poly.map_shape {sig : Container} {α β : Type}
    (f : α → β) (p : Poly sig α) :
    (Poly.map f p).shape = p.shape := rfl

@[simp] theorem Poly.map_children {sig : Container} {α β : Type}
    (f : α → β) (p : Poly sig α) (i : sig.pos p.shape) :
    (Poly.map f p).children i = f (p.children i) := rfl

@[simp] theorem Poly.map_id {sig : Container} {α : Type} (p : Poly sig α) :
    Poly.map id p = p := by
  cases p
  rfl

@[simp] theorem Poly.map_comp {sig : Container} {α β γ : Type}
    (f : α → β) (g : β → γ) (p : Poly sig α) :
    Poly.map g (Poly.map f p) = Poly.map (g ∘ f) p := by
  cases p
  rfl
```

These should remain local to this repo until checked against current Mathlib naming and overlap.

### Gate 3: W-fold API

Extract computation lemmas for `W.fold`.

Candidate local lemmas:

```lean
@[simp] theorem W.fold_sup {sig : Container} {X : Type}
    (alg : Poly sig X → X) (s : sig.shape) (children : sig.pos s → W sig) :
    W.fold alg (W.sup s children) =
      alg ⟨s, fun p => W.fold alg (children p)⟩ := rfl
```

The first upstream candidate is not a full initial-algebra development. The first candidate is a small W-type recursion API with examples.

## Extraction targets

### Target A: Mathlib polynomial functor API audit

Before writing a Mathlib PR, check current Mathlib for existing definitions related to:

- polynomial functors;
- containers;
- W-types;
- initial algebras;
- accessible functors;
- species or analytic functors, if present.

If Mathlib already has a preferred abstraction, extract lemmas and examples into that abstraction. If Mathlib lacks this abstraction, propose only the smallest core file.

### Target B: container-to-category bridge

A later PR may introduce a categorical bridge, but only after the standalone API is stable.

Candidate bridge concepts:

- `Poly sig` as an endofunctor on `Type`;
- container morphisms and induced natural transformations;
- container composition if needed by downstream examples;
- W-types as initial algebras for polynomial endofunctors.

The first bridge PR should avoid coalgebraic claims. Final coalgebras and M-types need a separate theory design.

### Target C: CSLib semantics bridge

The CSLib-facing use case is coalgebraic or transition-system semantics. The first extraction should be examples, not abstractions.

Candidate examples:

- deterministic transition systems represented by a container shape and positions;
- nondeterministic branching signatures;
- tree-shaped executions as W-type values.

## Non-upstream material for now

The following should remain repository-local during this sprint:

- release scripts;
- Docker packaging;
- `M sig` as a final-coalgebra placeholder;
- any categorical bridge not yet aligned with Mathlib conventions.

## First PR candidates generated from this repo

1. Local modernization PR: port standalone repo to the Lean 4.31 line.
2. Local API PR: add named simp lemmas for `Poly.map` and `W.fold`.
3. Mathlib audit PR candidate: identify whether current Mathlib already has polynomial functor or W-type infrastructure.
4. Mathlib extraction PR candidate: add a minimal polynomial-container API only if it fills a confirmed gap.
5. CSLib example PR candidate: represent simple branching transition systems using container signatures.

## Build certification status

Certified on branch `modernize/lean-4-31-extraction` (2026-06-09) with toolchain `leanprover/lean4:v4.31.0-rc2`:

| Command | Result |
|---------|--------|
| `lake update` | Pass |
| `lake build` | Pass |
| `lake env lean FinalProductionTest.lean` | Pass |
| `lake exe lean-containers` | Pass |
| `lake env lean Examples.lean` | Pass |

Gate 2 (named simp lemmas for `Poly.map` and `W.fold`) and `docs/EXTRACTION_LEDGER.md` are complete on this branch.

### Environment note (Windows)

`elan toolchain install` and initial `lake update` failed with `CRYPT_E_NO_REVOCATION_CHECK` (Windows schannel CRL check). Workaround: download the release zip with `curl --ssl-no-revoke` and install into `~/.elan/toolchains/`. This is an environment/network issue, not a repository code blocker.
