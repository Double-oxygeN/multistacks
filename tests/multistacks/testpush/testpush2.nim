discard """
  target: "c cpp js"
"""

import std/unittest
import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([newSeq[int]()]) # Do nothing.
check stack.tops.len == 0
check stack.height == 0
