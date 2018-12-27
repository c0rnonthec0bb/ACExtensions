#!/bin/bash

git add .
git commit -m "Update to version $1"
git tag $1
git push -u origin master --tags
pod repo push ACSpecs ACExtensions.podspec