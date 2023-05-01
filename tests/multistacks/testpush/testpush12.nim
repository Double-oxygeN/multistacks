discard """
  targets: "c cpp js"
  outputsub: "Error: unhandled exception: Values and top indices must have the same length. [ValueError]"
  exitcode: 1
"""

import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([0], [])
