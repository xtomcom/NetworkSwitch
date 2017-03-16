#!/bin/bash
echo "clean dist"
[ -d dist ] && rm -rf ./dist
[ -d dist.tgz ] && rm -rf ./dist.tgz
echo "create dist"
mkdir dist
echo "build"
go build -ldflags "-s -w" -o ./dist/network-switch
echo "copy assets"
cp -r ./hooks ./dist
cp -r ./pages ./dist
cp ./configure.json ./dist/
cp ./service.initd.sh ./dist/
