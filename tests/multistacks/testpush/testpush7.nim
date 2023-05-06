discard """
  targets: "c cpp js"
  matrix: "--mm:orc;--mm:refc"
  outputsub: "Error: unhandled exception: The length of valuesByTopIndex must be equal to the length of tops. [ValueError]"
  exitcode: 1
"""

import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([@[0]])
stack.push([])
