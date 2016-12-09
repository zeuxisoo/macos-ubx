#!/bin/bash

rm -rf ./node_modules
rm -rf ubx.dmg
rm -rf Ubx.app

npm install

cp -Rf ~/Library/Developer/Xcode/DerivedData/Ubx-cyfjhnisivblyafdlzkygqroyekn/Build/Products/Release/Ubx.app Ubx.app

./node_modules/.bin/appdmg dmg.config.json Ubx.dmg
