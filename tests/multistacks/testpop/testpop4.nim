discard """
  targets: "c cpp js"
  matrix: "--mm:orc;--mm:refc"
"""

import std/unittest
import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([@[0, 1, 2]])
check stack.pop(2) == 2
check stack.peek().len == 0
check stack.height == 0
