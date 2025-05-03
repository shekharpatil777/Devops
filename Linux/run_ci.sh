#!/bin/bash


python tests/syntax_lint.py
flake8 --max-line-length=100 . && echo "PEP8 Passed"