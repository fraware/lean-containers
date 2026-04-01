import Containers

/-!
# Smoke tests for lean-containers

Exercises the public API in `Containers` after `lake build`.
-/

open Containers

/-- List signature example -/
def testListSig : Container := ListSig

/-- Polynomial value and map -/
def testPoly : Poly ListSig Nat :=
  { shape := some (), children := fun _ => 42 }

def testPolyMapped : Poly ListSig String :=
  Poly.map (fun n => s!"Number: {n}") testPoly

def testIdMap : Poly ListSig Nat :=
  Poly.map id testPoly

def testCompMap : Poly ListSig String :=
  Poly.map (fun s => s ++ "!") (Poly.map (fun n => s!"{n}") testPoly)

#check testListSig
#check testPoly
#check testPolyMapped
#check testIdMap
#check testCompMap

theorem testPolyMapId : Poly.map id testPoly = testPoly := rfl

theorem testPolyMapComp :
  Poly.map (fun s => s ++ "!") (Poly.map (fun n => s!"{n}") testPoly) =
  Poly.map (fun n => s!"{n}" ++ "!") testPoly := rfl

#check Functor (Poly ListSig)
