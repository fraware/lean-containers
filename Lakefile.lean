import Lake
open Lake DSL

package «lean-containers» where
  -- Basic package information
  preferReleaseBuild := true
  -- Add package configuration options here

-- require mathlib from git
--   "https://github.com/leanprover-community/mathlib4.git" @ "v4.9.0"

@[default_target]
lean_lib «Containers» where
  -- add library configuration options here

lean_exe «lean-containers» where
  root := `Main
