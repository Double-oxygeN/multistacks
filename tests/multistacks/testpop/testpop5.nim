discard """
  targets: "c cpp js"
"""

import std/unittest
import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([@[0]])
stack.push([@[1]])
check stack.pop(0) == 1
check stack.tops == @[0]
check stack.height == 1
