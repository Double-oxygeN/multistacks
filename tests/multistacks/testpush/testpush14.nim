discard """
  targets: "c cpp js"
  outputsub: "Error: unhandled exception: Top index is out of range. [ValueError]"
  exitcode: 1
"""

import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([0, 1], [0.Natural, 0])
stack.push([2], [2.Natural])
