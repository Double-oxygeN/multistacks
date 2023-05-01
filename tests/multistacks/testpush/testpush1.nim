discard """
  target: "c cpp js"
"""

import std/unittest
import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([])
check stack.peek().len == 0
check stack.height == 0
