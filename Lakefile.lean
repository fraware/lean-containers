import Lake
open Lake DSL

package «lean-containers» where
  -- add package configuration options here

-- require mathlib from git
--   "https://github.com/leanprover-community/mathlib4.git" @ "v4.9.0"

@[default_target]
lean_lib «Containers» where
  -- add library configuration options here

lean_exe «lean-containers» where
  root := `Main

-- Test configuration
lean_exe «Tests.TestRunner» where
  root := `Tests.TestRunner

lean_exe «Tests.Unit.Sig» where
  root := `Tests.Unit.Sig

lean_exe «Tests.Unit.Poly» where
  root := `Tests.Unit.Poly

lean_exe «Tests.Unit.W» where
  root := `Tests.Unit.W

lean_exe «Tests.Unit.M» where
  root := `Tests.Unit.M

lean_exe «Tests.Unit.Traverse» where
  root := `Tests.Unit.Traverse

lean_exe «Tests.Property.FunctorLaws» where
  root := `Tests.Property.FunctorLaws

lean_exe «Tests.Property.TraversableLaws» where
  root := `Tests.Property.TraversableLaws

lean_exe «Tests.Property.FusionLaws» where
  root := `Tests.Property.FusionLaws

lean_exe «Tests.Integration.Workflows» where
  root := `Tests.Integration.Workflows

lean_exe «Tests.Performance.Benchmarks» where
  root := `Tests.Performance.Benchmarks

-- Comprehensive test configuration
lean_exe comprehensiveTest where
  root := `ComprehensiveTest

-- Simple test configuration
lean_exe simpleTest where
  root := `SimpleTest

-- Legacy test configuration
lean_exe tests where
  root := `Tests

-- Benchmark configuration
lean_exe bench where
  root := `Bench
