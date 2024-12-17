#!/bin/bash
python3 readme_autogen.py
git add .
git commit -m "update"
git push
echo "uploaded done"
