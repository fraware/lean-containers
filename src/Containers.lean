/-!
# Containers

Polynomial functors, container signatures, W-types, and related definitions.
-/

namespace Containers

/-- A basic container signature -/
structure Container where
  shape : Type
  pos : shape → Type

/-- A polynomial functor -/
structure Poly (sig : Container) (α : Type) where
  shape : sig.shape
  children : sig.pos shape → α

/-- Map over polynomial functors -/
def Poly.map {sig : Container} {α β : Type} (f : α → β) (p : Poly sig α) : Poly sig β :=
  ⟨p.shape, f ∘ p.children⟩

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

/-- W-type as initial algebra -/
inductive W (sig : Container) : Type where
  | sup (s : sig.shape) (children : sig.pos s → W sig) : W sig

/-- Fold for W-types -/
def W.fold {sig : Container} {X : Type} (alg : Poly sig X → X) : W sig → X :=
  fun w => match w with
  | W.sup s children => alg ⟨s, fun p => W.fold alg (children p)⟩

@[simp] theorem W.fold_sup {sig : Container} {X : Type}
    (alg : Poly sig X → X) (s : sig.shape) (children : sig.pos s → W sig) :
    W.fold alg (W.sup s children) =
      alg ⟨s, fun p => W.fold alg (children p)⟩ := rfl

/-- Nominal "M-type" shape (not a developed final-coalgebra API; see README). -/
inductive M (sig : Container) : Type where
  | intro (shape : sig.shape) (children : sig.pos shape → M sig) : M sig

/-- Functor instance for polynomial functors -/
instance {sig : Container} : Functor (Poly sig) where
  map := Poly.map

/-- Functor laws for polynomial functors -/
instance {sig : Container} : LawfulFunctor (Poly sig) where
  map_const := rfl
  id_map := fun _ => rfl
  comp_map := fun _ _ _ => rfl

-- Example: List as a container
def ListSig : Container :=
  { shape := Option Unit, pos := fun _ => Unit }

-- Example: Tree as a container
def TreeSig (α : Type) : Container :=
  { shape := Option α, pos := fun s => match s with | none => Empty | some _ => Fin 2 }

end Containers
