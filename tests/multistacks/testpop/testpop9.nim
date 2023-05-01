discard """
  targets: "c cpp js"
"""

import std/unittest
import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([@[0, 1]])
stack.push([@[2], @[]])
check stack.pop(1) == 1
check stack.peek().len == 0
check stack.height == 0
