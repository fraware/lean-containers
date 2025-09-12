/-!
# lean-containers Main

This is the main entry point for the lean-containers library.
-/

import Containers.Sig
import Containers.Poly.Core
import Containers.W.Core
import Containers.M.Core
import Containers.Traverse
import Containers.Examples.List
import Containers.Examples.Vec
import Containers.Examples.Rose
import Containers.Examples.Stream

def main : IO Unit := do
  IO.println "lean-containers library loaded successfully"
  IO.println "Available examples: List, Vec, Rose, Stream"
