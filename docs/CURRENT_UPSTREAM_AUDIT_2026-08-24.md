# lean-containers current-upstream audit — 2026-08-24

This document supersedes the June 2026 upstream discussion plan **for current contribution decisions**. The earlier Mathlib overlap audit remains useful evidence about the relationship between the local API and Mathlib's `PFunctor` / W-type stack.

## Audit baseline

- Lean: `leanprover/lean4:v4.34.0-rc2`
- The core package intentionally has **no Mathlib dependency**.
- Current-baseline build status: **pending CI** until the audit branch workflow completes successfully.

The previous 4.31 build state is historical and must not be represented as current compatibility evidence.

## Existing overlap remains decisive

The prior repository audit correctly identified that the local container signature / polynomial functor layer is mathematically the same basic object already represented by Mathlib's `PFunctor` infrastructure:

- local `Container.shape` / `Container.pos` correspond to Mathlib `PFunctor.A` / `PFunctor.B`;
- local `Poly sig α` corresponds to the sigma presentation used by `PFunctor`;
- Mathlib already has the relevant map laws;
- Mathlib already has W-type infrastructure and `PFunctor.W`.

That overlap is not a reason to discard the repository. It is a reason not to upstream a parallel foundational hierarchy.

Current CSLib also has `Cslib/Foundations/Data/PFunctor/Free.lean`, increasing the value of interoperability experiments and decreasing the justification for another independently named polynomial-functor core.

## Strategic decision

`lean-containers` should remain a **mathlib-free research and interoperability laboratory**.

Do not upstream, without explicit maintainer alignment:

- a new Mathlib `Container` core duplicating `PFunctor`;
- a second W-type hierarchy;
- structure-based aliases whose only advantage is field naming;
- examples-only PRs whose mathematics and API are already present.

## Productive research directions

### 1. Thin interoperability with `PFunctor`

Use the local structure presentation to understand where Mathlib's sigma presentation creates genuine downstream friction. A bridge is interesting only if it enables a real theorem or development that is materially awkward today.

Possible result classes:

- an equivalence between a local structure presentation and existing `PFunctor` data;
- missing extensionality / simp lemmas exposed by that bridge;
- transport of recursive constructions across the equivalence.

These are research directions, not presumed upstream candidates.

### 2. Containers / PFunctors and free effects

The more interesting cross-repository direction is to connect polynomial signatures to the current CSLib `FreeM` stack rather than introduce another syntax representation.

Research question:

> Can a useful class of effect signatures or syntax functors be represented through existing PFunctor/container machinery in a way that yields reusable recursion, interpretation, or modularity theorems?

Any resulting upstream contribution should extend the existing `PFunctor` / `FreeM` abstractions directly.

### 3. Containers / PFunctors and operational semantics

Current CSLib already has LTS, simulation, bisimulation, trace-equivalence, and execution infrastructure.

A longer-term integration path is:

`polynomial signature → generated syntax/tree → operational LTS → semantic equivalence`.

This is potentially high-value if it produces reusable bridges between existing abstractions. It is not a reason to add a parallel LTS framework.

## Decision table

| Local stream | Current decision |
|---|---|
| `Container` core | Keep local; do not duplicate `PFunctor` upstream |
| `Poly` map laws | Keep local unless a bridge exposes a genuinely missing current theorem |
| W-type recursion aliases | Keep local unless a real downstream need survives comparison with `WType` / `PFunctor.W` |
| list/tree examples | Local pedagogical/regression material |
| transition-system examples | Research bridge to existing CSLib LTS, not a new semantics API |
| `Poly ≃ PFunctor` bridge | Research; maintainer alignment required before upstream proposal |
| PFunctor/FreeM interoperability | Active research direction |

## Acceptance gate for any container-derived upstream candidate

A candidate may move to `PR_READY` only when:

1. current Lean compatibility is independently verified;
2. the candidate extends existing `PFunctor`, W-type, FreeM, or LTS abstractions instead of duplicating them;
3. current master and open PRs do not already provide an equivalent mechanism;
4. a real downstream theorem/use case demonstrates the missing capability;
5. the contribution remains valuable without the local `Container` naming/package;
6. no `sorry`, `admit`, custom axiom, or local experimental tactic is required;
7. the proposed diff is minimal and reviewable;
8. AI assistance is accurately disclosed and the contributor independently understands the submitted code.

## Immediate work queue

1. Obtain CI evidence for Lean 4.34 compatibility.
2. Keep the package mathlib-free while using external scratch work for current-Mathlib interoperability experiments.
3. Audit current `PFunctor` and CSLib `PFunctor.Free` APIs before designing any bridge.
4. Prototype one real PFunctor/FreeM or PFunctor/LTS use case.
5. Only extract an upstream theorem if the experiment reveals a small missing primitive in the existing hierarchy.
