discard """
  targets: "c cpp js"
  matrix: "--mm:orc;--mm:refc"
"""

import std/unittest
import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([@[0, 1]])
stack.push([@[2], @[]])
check stack.pop(0) == 2
check stack.peek() == @[0, 1]
check stack.height == 1
