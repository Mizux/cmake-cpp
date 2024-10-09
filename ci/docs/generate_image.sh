#!/usr/bin/env bash
set -eux

# Check plantuml is in PATH
command -v plantuml

#rm -f "*.png"
rm -f "*.svg"
for i in *.dot; do
  #plantuml -Tpng "$i";
  plantuml -Tsvg "$i";
done
