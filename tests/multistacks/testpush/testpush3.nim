discard """
  targets: "c cpp js"
"""

import std/unittest
import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([@[0]])
check stack.peek() == @[0]
check stack.height == 1
