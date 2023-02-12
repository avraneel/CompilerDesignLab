#!/bin/bash

lex -t lexanalyzer.l > lexanalyzer.c
gcc lexanalyzer.c -o lexanalyzer
./lexanalyzer