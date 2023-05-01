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


proc newMultiStack*[T](): MultiStack[T] =
  ## Creates a new empty stack.
  result = MultiStack[T](tops: @[], height: 0)
