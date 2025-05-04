#!/bin/bash



echo $(( $(grep \</summary\> -c README.md) + $(grep -i Solution README.md | grep \.md -c) ))