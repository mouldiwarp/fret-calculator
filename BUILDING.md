# Building Fret Calculator

This document describes how to build Fret Calculator from source.

## Prerequisites

- macOS 13.0 or later
- Swift 6.0 or later (included with Xcode Command Line Tools)
- `sips` and `iconutil` (standard macOS command-line tools)

### Installing Dependencies

If you don't have Swift installed, install the Xcode Command Line Tools:

```bash
xcode-select --install
```

Verify your Swift installation:

```bash
swift --version
```

## Build Methods

### Method 1: Quick Build (Development)

For a quick debug build suitable for testing:

```bash
swift build
./run
```

### Method 2: Complete App Bundle (Production)

To build a complete, standalone app bundle ready for distribution:

```bash
./Scripts/build_app.sh
```

This produces `FretCalculator.app` in the current directory, which can be:
- Launched with `open FretCalculator.app`
- Moved to `/Applications` for system-wide installation
- Shared with other macOS users

### Method 3: Release Build

For an optimized release binary:

```bash
swift build -c release
```

The binary is located at `.build/release/FretCalculator`.

## Build Process Details

### What `./Scripts/build_app.sh` Does

1. **Compiles** the source code to a release binary
2. **Generates icon assets** in `.icns` format:
   - Resizes the source PNG to standard macOS icon sizes (16×16 through 512×512)
   - Includes both standard and @2x (Retina) variants
   - Compiles the icons into a single `.icns` file
3. **Assembles the app bundle** structure:
   ```
   FretCalculator.app/
   ├── Contents/
   │   ├── Info.plist
   │   ├── MacOS/
   │   │   └── FretCalculator (executable binary)
   │   ├── Resources/
   │   │   └── AppIcon.icns
   │   └── _CodeSignature/
   ```
4. **Code signs** the bundle for execution (ad-hoc signature for local use)

### Environment Variables

The build script respects standard Swift build variables:

```bash
# Set configuration (debug or release, default: release)
# (No need to set - build_app.sh always uses release)

# Set custom build directory (default: .build)
# Not typically needed
```

## Troubleshooting

### Build Fails with "Cannot find 'pow'"

**Cause**: Missing `import Foundation` in source files

**Solution**: Ensure `Sources/FretCalculator/FretMath.swift` includes:
```swift
import Foundation
```

### "iconutil: error: couldn't find any icons" 

**Cause**: Missing or corrupted source image

**Solution**: Verify `Resources/AppIcon/source.png` exists:
```bash
ls -lh Resources/AppIcon/source.png
```

If missing, re-copy the source image:
```bash
cp "/Users/gary/Desktop/Screenshot 2026-07-15 at 20.09.19.png" Resources/AppIcon/source.png
```

### App Won't Launch After Build

**Solution**: Try rebuilding and code signing:
```bash
rm -rf FretCalculator.app
./Scripts/build_app.sh
```

If the build succeeds but the app won't launch:
```bash
codesign -v FretCalculator.app
# or re-sign it:
codesign --force --deep --sign - FretCalculator.app
```

### "Command not found: sips" or "iconutil"

These are standard macOS tools that should be available. If missing:

```bash
xcode-select --install
```

## Clean Build

To remove build artifacts and start fresh:

```bash
rm -rf .build
rm -rf .swiftpm
rm -rf FretCalculator.app
swift build  # or ./Scripts/build_app.sh
```

## Cross-Platform Builds

Swift on macOS can build for other platforms, but Fret Calculator uses SwiftUI and is macOS-specific.

To verify your build environment:

```bash
swift --version
uname -m  # Shows processor architecture (arm64 or x86_64)
```

## Continuous Integration

For CI/CD pipelines, use:

```bash
# Run tests
swift test

# Build release
./Scripts/build_app.sh

# Verify build
[ -f FretCalculator.app/Contents/MacOS/FretCalculator ] && echo "Build successful"
```

## Performance Notes

- **Debug build**: ~2-3 seconds, larger binary (~300MB)
- **Release build**: ~4-5 seconds, optimized binary (~160MB)
- **Icon generation**: ~1-2 seconds (uses `sips` and `iconutil`)

Total build time: 4-7 seconds for a complete app bundle.
