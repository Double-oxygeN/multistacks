discard """
  targets: "c cpp js"
"""

import std/unittest
import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([@[0, 1]])
stack.push([@[2], @[3]])
check stack.pop(0) == 2
check stack.tops == @[0, 1]
check stack.height == 1
