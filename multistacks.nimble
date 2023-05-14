# Package

version       = "0.1.0"
author        = "Double-oxygeN"
description   = "Multi-value stack data structure"
license       = "Apache-2.0"
srcDir        = "src"


# Dependencies

requires "nim >= 1.6.12"

# Helper procs

from os import splitFile

proc forFilesRecursive(rootDir: string; f: (proc (filename: string))) =
  for dir in listDirs(rootDir):
    forFilesRecursive(dir, f)

  for file in listFiles(rootDir):
    f(file)

# Tasks

task test, "Executes tests w/testament.":
  exec "testament category /"

task cleanup, "Clean up intermediate files.":
  rmDir "nimcache"
  rmDir "testresults"
  # exec "find tests/multistacks/ -type f -not -name '*.nim' -delete"
  forFilesRecursive("tests/multistacks") do (filename: string):
    if splitFile(filename).ext != ".nim":
      rmFile filename
