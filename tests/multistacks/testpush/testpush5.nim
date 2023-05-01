discard """
  targets: "c cpp js"
"""

import std/unittest
import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([@[0]])
stack.push([@[0]])
check stack.tops == @[0]
check stack.height == 2
