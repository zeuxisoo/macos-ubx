#!/bin/bash

rm -rf appicon.iconset
rm -rf appicon.icns

mkdir appicon.iconset

convert -alpha on -resize 16x16 ../Arkwork/icon.png ./appicon.iconset/icon_16x16.png
convert -alpha on -resize 32x32 ../Arkwork/icon.png ./appicon.iconset/icon_16x16@2x.png
convert -alpha on -resize 32x32 ../Arkwork/icon.png ./appicon.iconset/icon_32x32.png
convert -alpha on -resize 64x64 ../Arkwork/icon.png ./appicon.iconset/icon_32x32@2x.png
convert -alpha on -resize 128x128 ../Arkwork/icon.png ./appicon.iconset/icon_128x128.png
convert -alpha on -resize 256x256 ../Arkwork/icon.png ./appicon.iconset/icon_128x128@2x.png
convert -alpha on -resize 256x256 ../Arkwork/icon.png ./appicon.iconset/icon_256x256.png
convert -alpha on -resize 512x512 ../Arkwork/icon.png ./appicon.iconset/icon_256x256@2x.png
convert -alpha on -resize 512x512 ../Arkwork/icon.png ./appicon.iconset/icon_512x512.png
convert -alpha on -resize 1024x1024 ../Arkwork/icon.png ./appicon.iconset/icon_512x512@2x.png

iconutil -c icns appicon.iconset
