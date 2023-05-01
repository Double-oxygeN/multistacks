discard """
  targets: "c cpp js"
"""

import std/unittest
import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([@[0]])
check stack.pop(0) == 0
check stack.tops.len == 0
check stack.height == 0
