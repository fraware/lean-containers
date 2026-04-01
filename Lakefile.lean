import Lake
open Lake DSL

package «lean-containers» where
  preferReleaseBuild := true
  version := v!"0.1.0"
  description := "Lean 4 library: container signatures, polynomial functors, and W-types (no mathlib dependency)."
  homepage := "https://github.com/fraware/lean-containers"
  keywords := #["lean4", "containers", "polynomial-functors", "w-types", "dependent-types"]
  license := "MIT"
  readmeFile := "README.md"
  licenseFiles := #["LICENSE"]

@[default_target]
lean_lib «Containers» where
  srcDir := "src"

lean_exe «lean-containers» where
  root := `Main
