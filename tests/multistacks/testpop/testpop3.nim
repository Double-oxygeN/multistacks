discard """
  targets: "c cpp js"
  outputsub: "Error: unhandled exception: Top index is out of range. [ValueError]"
  exitcode: 1
"""

import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([@[0]])
discard stack.pop(1)
