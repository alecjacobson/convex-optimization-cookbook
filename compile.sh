#!/bin/bash
python -m readme2tex --svgdir tex --output README{,.tex}.md 
sed -i '' -e 's#https[^"]*tex#./tex#g' README.md
