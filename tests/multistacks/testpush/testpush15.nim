discard """
  targets: "c cpp js"
  matrix: "--mm:orc;--mm:refc"
"""

import std/unittest
import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([0, 1], [0.Natural, 0])
stack.push([2], [0.Natural])
check stack.peek() == @[2, 1]
check stack.height == 2
