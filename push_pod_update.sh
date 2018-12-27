#!/bin/bash

sed -i "11s/.*/s.version = \"$1\"/" file.txt
git add .
git commit -m "Update to version $1"
git tag $1
git push -u origin master --tags
pod repo push ACSpecs ACExtensions.podspec