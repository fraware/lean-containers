import Containers

/-!
# lean-containers Main

This is the main entry point for the lean-containers library.
-/

def main : IO Unit := do
  IO.println "lean-containers library loaded successfully"
  IO.println "Available examples: List, Vec, Rose, Stream"
