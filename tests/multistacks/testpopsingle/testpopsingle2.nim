discard """
  targets: "c cpp js"
  matrix: "--mm:orc;--mm:refc"
"""

import std/unittest
import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([@[0]])
check stack.popSingle() == @[0]
check stack.height == 0
