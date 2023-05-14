discard """
  targets: "c cpp js"
  matrix: "--mm:orc;--mm:refc"
"""

import std/unittest
import ../../../src/multistacks

var stack = newMultiStack[int]()
stack.push([@[0, 1]])
stack.push([@[], @[2]])
stack.push([@[3], @[]])

check stack.popSingle() == @[3, 2]
check stack.height == 2

check stack.popSingle() == @[0, 2]
check stack.height == 1
check stack.peek() == @[0, 1]
