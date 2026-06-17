# Transition-system examples

Documentation for [`CSLibExamples.lean`](../CSLibExamples.lean): finite execution trees as W-types
over container signatures, without Mathlib or external library dependencies.

## What the examples demonstrate

| Example | Signature | Reading |
|---------|-----------|---------|
| `DetBranchSig`, `detExecution` | one successor slot per non-terminal state | deterministic path |
| `NDetBranchSig`, `ndetExecution` | `Branch2` at `start`, then deterministic steps | nondeterministic branching tree |
| `detExecutionDepth`, `ndetExecutionDepth` | `W.fold` algebras | max branch depth |
| `detExecutionStates` | `W.fold` algebra | control-state trace along a path |

`shape` models control states; `pos s` models successor slots (branching degree) at `s`.

## Semantics reading

**Deterministic:** at each non-terminal control state `s`, `pos s` has exactly one successor slot.
An execution is a path.

**Nondeterministic:** at `start`, `pos` is `Branch2` (two successor slots). An execution is a finite
tree of choices; `W.fold` interprets such trees (depth, state traces, labels).

In transition-system semantics, `shape` is the set of control states and `pos s` is the branching
degree at `s`. Values of `W sig` are finite execution trees built from those transitions.

## Using these patterns elsewhere

The examples are self-contained in [`CSLibExamples.lean`](../CSLibExamples.lean). To reuse the
pattern in another project:

1. Define control states as `shape` and successor slots as `pos s`.
2. Build executions with `W.sup` and interpret them with `W.fold` algebras.
3. Compare with Mathlib's `PFunctor` / `WType` packaging if you already depend on Mathlib; see
   `docs/upstream/MATHLIB_CONTAINER_AUDIT.md` (summary: `docs/mathlib-overlap.md`).

## Related reading

- Core API examples: [`Examples.lean`](../Examples.lean)
- Mathlib audit: [`docs/upstream/MATHLIB_CONTAINER_AUDIT.md`](upstream/MATHLIB_CONTAINER_AUDIT.md)
  (summary: [`docs/mathlib-overlap.md`](mathlib-overlap.md))
