#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

swift build -c release

APP=FretCalculator.app
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp .build/release/FretCalculator "$APP/Contents/MacOS/FretCalculator"
cp Info.plist "$APP/Contents/Info.plist"

ICONSET=Resources/AppIcon/AppIcon.iconset
rm -rf "$ICONSET"; mkdir -p "$ICONSET"
SRC=Resources/AppIcon/source.png
for size in 16 32 128 256 512; do
  sips -z $size $size "$SRC" --out "$ICONSET/icon_${size}x${size}.png" >/dev/null
  double=$((size * 2))
  sips -z $double $double "$SRC" --out "$ICONSET/icon_${size}x${size}@2x.png" >/dev/null
done
iconutil -c icns "$ICONSET" -o "$APP/Contents/Resources/AppIcon.icns"
rm -rf "$ICONSET"

codesign --force --deep --sign - "$APP"
echo "Built $APP"
