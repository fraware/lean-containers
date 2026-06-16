import Containers

/-!
# Transition-system examples

Examples (no Mathlib dependency) showing how container signatures and W-types model branching
transition systems. See `docs/transition-system-examples.md` for a fuller walkthrough.

**Deterministic reading:** at each non-terminal control state `s`, `pos s` has exactly one
successor slot (`Unit`). An execution is a path, not a tree of choices.

**Nondeterministic reading:** at `start`, `pos` is `Branch2` (two successor slots). An execution
is a finite tree of choices; `W.fold` interprets such trees (depth, state traces, labels).

`shape` is the set of control states; `pos s` is the branching degree at `s`. Values of `W sig` are
finite execution trees built from those transitions.
-/

open Containers

/-- Control states for a tiny transition system. -/
inductive SysState where | start | mid | done

/-- Deterministic branching signature: each non-terminal state has exactly one successor slot. -/
def DetBranchSig : Container :=
  { shape := SysState,
    pos := fun s => match s with | SysState.done => Empty | _ => Unit }

/-- Nondeterministic branching at `start`: two successor slots; later steps are deterministic. -/
inductive NDetShape where | start | left | right | done

/-- Two-way branch labels for nondeterministic choice at `start`. -/
inductive Branch2 where | left | right

def NDetBranchSig : Container :=
  { shape := NDetShape,
    pos := fun s => match s with
      | NDetShape.start => Branch2
      | NDetShape.left | NDetShape.right => Unit
      | NDetShape.done => Empty }

/-- Finite deterministic execution: `start → mid → done`. -/
def detExecution : W DetBranchSig :=
  W.sup SysState.start (fun _ =>
    W.sup SysState.mid (fun _ =>
      W.sup SysState.done (fun e => nomatch e)))

/-- Finite nondeterministic execution tree: branch at `start`, then converge to `done`. -/
def ndetExecution : W NDetBranchSig :=
  W.sup NDetShape.start (fun b =>
    match b with
    | Branch2.left => W.sup NDetShape.left (fun _ =>
        W.sup NDetShape.done (fun e => nomatch e))
    | Branch2.right => W.sup NDetShape.right (fun _ =>
        W.sup NDetShape.done (fun e => nomatch e)))

/-- `W.fold` interpretation: maximum branch depth of a deterministic execution. -/
def detDepthAlg : Poly DetBranchSig Nat → Nat
  | ⟨SysState.done, _⟩ => 1
  | ⟨SysState.start, c⟩ => 1 + c (show DetBranchSig.pos SysState.start from Unit.unit)
  | ⟨SysState.mid, c⟩ => 1 + c (show DetBranchSig.pos SysState.mid from Unit.unit)

def detExecutionDepth : Nat :=
  W.fold detDepthAlg detExecution

/-- `W.fold` interpretation: control-state trace along a deterministic execution. -/
def detStatesAlg : Poly DetBranchSig (List SysState) → List SysState
  | ⟨SysState.done, _⟩ => [SysState.done]
  | ⟨SysState.start, c⟩ => SysState.start :: c (show DetBranchSig.pos SysState.start from Unit.unit)
  | ⟨SysState.mid, c⟩ => SysState.mid :: c (show DetBranchSig.pos SysState.mid from Unit.unit)

def detExecutionStates : List SysState :=
  W.fold detStatesAlg detExecution

/-- `W.fold` interpretation: maximum branch depth of a nondeterministic execution tree. -/
def ndetDepthAlg : Poly NDetBranchSig Nat → Nat
  | ⟨NDetShape.done, _⟩ => 1
  | ⟨NDetShape.start, c⟩ => 1 + Nat.max (c Branch2.left) (c Branch2.right)
  | ⟨NDetShape.left, c⟩ => 1 + c (show NDetBranchSig.pos NDetShape.left from Unit.unit)
  | ⟨NDetShape.right, c⟩ => 1 + c (show NDetBranchSig.pos NDetShape.right from Unit.unit)

def ndetExecutionDepth : Nat :=
  W.fold ndetDepthAlg ndetExecution

#check DetBranchSig
#check NDetBranchSig
#check detExecution
#check ndetExecution
#check detExecutionDepth
#check detExecutionStates
#check ndetExecutionDepth
