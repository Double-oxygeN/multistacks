discard """
  targets: "c cpp js"
"""

import std/unittest
import ../../src/multistacks

let multistack = newMultiStack[int]()

check multistack.height == 0
check multistack.peek().len == 0
