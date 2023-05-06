discard """
  targets: "c cpp js"
  matrix: "--mm:orc;--mm:refc"
  outputsub: "Error: unhandled exception: Top index must be 0 when stack is empty. [ValueError]"
  exitcode: 1
"""

import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([newSeq[int](), newSeq[int]()])
