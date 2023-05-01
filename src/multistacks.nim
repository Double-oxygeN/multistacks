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

  MultiStack*[T] = ref object
    tops: seq[MultiStackNode[T]]
    height: Natural


func hasSameTopIndex[T](x, y: MultiStackNode[T]): bool =
  result = not x.isNil and not y.isNil and x.topIndexStack.len == y.topIndexStack.len and x.topIndexStack[^1] == y.topIndexStack[^1]


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

    if valuesByTopIndex[0].len == 0:
      # Nothing to do.
      return

    for i, value in valuesByTopIndex[0]:
      stack.tops.add newMultiStackNode[T](value, i)

  else:
    if valuesByTopIndex.len != stack.tops.len:
      raise ValueError.newException("The length of valuesByTopIndex must be equal to the length of tops.")

    var
      newTops: seq[MultiStackNode[T]] = @[]
      pushValueCount = 0

    for topIndex, values in valuesByTopIndex:
      inc pushValueCount, values.len
      if values.len == 0:
        stack.tops[topIndex].topIndexStack.add newTops.len
        newTops.add stack.tops[topIndex]

      else:
        for value in values:
          newTops.add newMultiStackNode[T](value, newTops.len, stack.tops[topIndex])

    if pushValueCount == 0:
      # Nothing to do.
      return

    stack.tops = newTops

  inc stack.height


proc push*[T](stack: var MultiStack[T]; values: openArray[T]; onTopIndices: openArray[Natural]) =
  ## Pushes the given values on the given tops of the stack.
  runnableExamples:
    var stack = newMultiStack[int]()

    stack.push([1, 2, 3], [0.Natural, 0, 0])
    assert stack.tops == @[1, 2, 3]
    assert stack.height == 1

    stack.push([4, 5, 6], [0.Natural, 0, 2])
    assert stack.tops == @[4, 5, 2, 6]
    assert stack.height == 2

    stack.push([7, 8, 9, 10], [1.Natural, 1, 1, 3])
    assert stack.tops == @[4, 7, 8, 9, 2, 10]
    assert stack.height == 3

  if values.len != onTopIndices.len:
    raise ValueError.newException("Values and top indices must have the same length.")

  var valuesByTopIndex: seq[seq[T]] = newSeqOfCap[seq[T]](max(1, stack.tops.len))
  for i, value in values:
    let topIndex = onTopIndices[i]
    if (stack.height == 0 and topIndex != 0) or (stack.height > 0 and topIndex > stack.tops.high):
      raise ValueError.newException("Top index is out of range.")

    while valuesByTopIndex.high < topIndex:
      valuesByTopIndex.add @[]

    valuesByTopIndex[topIndex].add value

  while valuesByTopIndex.high < stack.tops.high:
    valuesByTopIndex.add @[]

  stack.push(valuesByTopIndex)


proc pop*[T](stack: var MultiStack[T]; topIndex: Natural): T =
  ## Pops the top value of the given top index.
  runnableExamples:
    var stack = newMultiStack[int]()

    stack.push([@[0, 1, 2]])
    assert stack.pop(0) == 0
    assert stack.tops.len == 0
    assert stack.height == 0

    stack.push([@[0, 1, 2]])
    stack.push([@[3, 4], @[], @[5]])
    stack.push([@[], @[6, 7, 8], @[], @[9]])
    assert stack.pop(3) == 8
    assert stack.tops == @[3, 4, 1, 5]
    assert stack.height == 2

    assert stack.pop(2) == 1
    assert stack.tops.len == 0
    assert stack.height == 0

  if stack.height == 0:
    raise ValueError.newException("Stack is empty.")

  if topIndex > stack.tops.high:
    raise ValueError.newException("Top index is out of range.")

  let selectedTop = stack.tops[topIndex]
  result = selectedTop.value

  var newTops: seq[MultiStackNode[T]] = @[]
  for i, top in stack.tops:
    discard top.topIndexStack.pop()

    if top.topIndexStack.len == 0:
      if newTops.len > 0 and top.parent.hasSameTopIndex(newTops[^1]):
        continue

      if not top.parent.isNil:
        newTops.add top.parent

    else:
      newTops.add top

  stack.tops = newTops
  dec stack.height

  if selectedTop.topIndexStack.len > 0:
    result = stack.pop(selectedTop.topIndexStack[^1])
