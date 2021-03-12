#!/bin/bash

quasar build
rm -rf docs
cp -r dist/spa docs
cp CNAME docs/
git add . && git commit -m "site build" && git push origin master