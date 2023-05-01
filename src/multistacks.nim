# Copyright 2023 Double-oxygeN
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

type
  MultiStackNode[T] {.acyclic.} = ref object
    value: T
    parent {.cursor.}: MultiStackNode[T]
    topIndexStack: seq[Natural]

  MultiStack[T] = ref object
    tops: seq[MultiStackNode[T]]
    height: Natural


func tops*[T](stack: MultiStack[T]): seq[T] =
  ## Gets the top values of the stack.
  for top in stack.tops:
    result.add top.value


func height*[T](stack: MultiStack[T]): Natural =
  ## Gets the height of the stack.
  result = stack.height


proc newMultiStackNode[T](value: T; topIndex: Natural; parent: MultiStackNode[T] = nil): MultiStackNode[T] =
  result = MultiStackNode[T](value: value, parent: parent, topIndexStack: @[topIndex])


proc newMultiStack*[T](): MultiStack[T] =
  ## Creates a new empty stack.
  result = MultiStack[T](tops: @[], height: 0)


proc push*[T](stack: var MultiStack[T]; valuesByTopIndex: openArray[seq[T]]) =
  ## Pushes the given values on each tops of the stack.
  runnableExamples:
    var stack = newMultiStack[int]()

    stack.push([@[1, 2, 3]])
    assert stack.tops == @[1, 2, 3]
    assert stack.height == 1

    stack.push([@[4, 5], @[], @[6]])
    assert stack.tops == @[4, 5, 2, 6]
    assert stack.height == 2

    stack.push([@[], @[7, 8, 9], @[], @[10]])
    assert stack.tops == @[4, 7, 8, 9, 2, 10]
    assert stack.height == 3

  if stack.height == 0:
    if valuesByTopIndex.len == 0:
      # Nothing to do.
      return

    if valuesByTopIndex.len > 1:
      raise ValueError.newException("Top index must be 0 when stack is empty.")

    for i, value in valuesByTopIndex[0]:
      stack.tops.add newMultiStackNode[T](value, i)

  else:
    if valuesByTopIndex.len != stack.tops.len:
      raise ValueError.newException("Top index is out of range.")

    var newTops: seq[MultiStackNode[T]] = @[]
    for topIndex, values in valuesByTopIndex:
      if values.len == 0:
        stack.tops[topIndex].topIndexStack.add newTops.len
        newTops.add stack.tops[topIndex]

      else:
        for value in values:
          newTops.add newMultiStackNode[T](value, newTops.len, stack.tops[topIndex])

    stack.tops = newTops

  inc stack.height
