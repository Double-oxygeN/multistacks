discard """
  targets: "c cpp js"
  matrix: "--mm:orc;--mm:refc"
  outputsub: "Error: unhandled exception: Stack is empty. [ValueError]"
  exitcode: 1
"""

import ../../../src/multistacks

var stack = newMultiStack[int]()

discard stack.pop(0)
