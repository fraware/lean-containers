import Containers

open Containers

def listPolyExample : Poly ListSig Nat :=
  { shape := some (), children := fun _ => 1 }

#check Poly.map Nat.succ listPolyExample

def treeExample : W (TreeSig Nat) :=
  W.sup (some 0) (fun _ => W.sup none (fun e => nomatch e))
