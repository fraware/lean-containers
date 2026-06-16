import Containers

/-!
# Core API examples

Small, checkable examples for `Poly.map` and `W.fold` on the built-in signatures.
-/

open Containers

def listPolyExample : Poly ListSig Nat :=
  { shape := some (), children := fun _ => 1 }

#check Poly.map Nat.succ listPolyExample

def treeExample : W (TreeSig Nat) :=
  W.sup (some 0) (fun _ => W.sup none (fun e => nomatch e))

/-- Algebra: leaf depth `0`, node depth `1 + max(child depths)`. -/
def treeDepthAlg : Poly (TreeSig Nat) Nat → Nat
  | ⟨none, _⟩ => 0
  | ⟨some _, c⟩ => 1 + Nat.max (c (0 : Fin 2)) (c (1 : Fin 2))

def treeDepth (t : W (TreeSig Nat)) : Nat :=
  W.fold treeDepthAlg t

#check treeDepth treeExample
