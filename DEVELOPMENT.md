# Development Guide

Technical documentation for developers working on Fret Calculator.

## Architecture Overview

Fret Calculator follows a clean, testable architecture with clear separation of concerns:

```
User Interface (SwiftUI)
    ↓
    FretCalculatorApp.swift (App entry point)
    ContentView.swift (UI components & state)
    ↓
    FretMath.swift (Pure calculation logic)
    ↓
    Clipboard.swift (macOS integration)
```

## Project Layout

```
Sources/FretCalculator/
├── FretCalculatorApp.swift    # @main App scene
├── ContentView.swift          # SwiftUI views + state
├── FretMath.swift             # Pure math (no UI)
└── Clipboard.swift            # Platform integration

Tests/FretCalculatorTests/
└── FretMathTests.swift        # Unit tests

Resources/
├── AppIcon/
│   └── source.png             # Icon source image
└── (Icons generated here)

Scripts/
└── build_app.sh               # Build automation
```

## Core Modules

### FretMath.swift

**Purpose**: Pure, testable calculation logic

**Key Types**:
```swift
struct FretPosition: Identifiable {
    let fretNumber: Int
    let distanceFromNutMM: Double
    let distanceFromPreviousMM: Double
    var id: Int { fretNumber }  // For Table binding
}

enum FretMath {
    static func calculate(scaleLengthInches: Double, fretCount: Int) -> [FretPosition]
}
```

**Formula**:
```
distance_from_nut_mm = scaleLengthMM * (1 - 1 / 2^(n/12))

Where:
  n = fret number (1, 2, 3, ... fretCount)
  2^(1/12) ≈ 1.0594631 (semitone ratio in 12-TET)
  2^(12/12) = 2 (one octave = double frequency)
```

**Design Principles**:
- No SwiftUI imports → testable without UI framework
- No Foundation UI classes → runs in pure Swift
- Pure function with no side effects
- Input validation via guard statement
- All values computed in millimeters for precision

### ContentView.swift

**Purpose**: User interface and state management

**State Variables**:
```swift
@State private var scaleLengthText: String = "25.5"
@State private var fretCountText: String = "24"
```

**Derived State**:
```swift
var positions: [FretPosition] {
    // Parses text fields → calls FretMath.calculate()
    // Returns [] on invalid input
}
```

**UI Components**:
1. **Input Section**:
   - TextField for scale length
   - TextField for fret count
   - Validation feedback for invalid input

2. **Results Section**:
   - SwiftUI `Table` view with 3 columns
   - Identifiable row binding via `FretPosition.id`
   - Formatted numbers via `Clipboard.format()`

3. **Action Section**:
   - Copy button (disabled when positions.isEmpty)
   - Calls `Clipboard.copyTSV(positions)`

**Design Notes**:
- Reactive: table updates as user types
- Defensive: invalid input → empty table (no crashes)
- Non-blocking: number parsing doesn't throw

### Clipboard.swift

**Purpose**: Platform-specific integration (macOS clipboard)

**Key Functions**:
```swift
static func copyTSV(_ positions: [FretPosition])
    // Formats data as tab-separated values
    // Copies to NSPasteboard.general

static func format(_ value: Double) -> String
    // Formats Double to "%.2f" with POSIX locale
    // Used by both UI and clipboard export
```

**Important**: POSIX locale ensures decimal separator is always `.` (dot), never `,` (comma), which is critical for spreadsheet compatibility across locales.

**TSV Format**:
```
Fret    Distance from Nut (mm)    Distance from Previous Fret (mm)
F1      56.41                     56.41
F2      111.50                    55.09
...
```

### FretCalculatorApp.swift

**Purpose**: App lifecycle and window configuration

```swift
@main
struct FretCalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
    }
}
```

**Configuration**:
- Hidden title bar for modern appearance
- Unified toolbar (integrates with window buttons)
- ContentView fills window

## Testing

### Test Coverage (FretMathTests.swift)

**Tests included**:
```
✓ testCalculateEmptyInput()
✓ testCalculateZeroFrets()
✓ testFret12IsHalfScale()
✓ testFret1DistanceFromPreviousEqualsDistanceFromNut()
✓ testFret24Standard()
✓ testIncreasingDistances()
✓ testDecreasingSpacingBetweenFrets()
```

**Running Tests**:
```bash
swift test
# or watch mode:
swift test --watch  # (if available)
```

**Adding Tests**:
1. Add new test function to `FretMathTests`
2. Use XCTest assertions
3. Test pure `FretMath` logic only (no UI)

### Test Philosophy

- **Unit**: Test `FretMath.calculate()` in isolation
- **Pure**: No SwiftUI, no AppKit, no I/O
- **Accurate**: Verify against mathematical expectations
- **Edge cases**: Zero input, negative input, boundary conditions

## Build System

### Package.swift

**Swift Package Manager configuration**:
```swift
let package = Package(
    name: "FretCalculator",
    platforms: [.macOS(.v13)],  // Requires macOS 13 for Table view
    products: [
        .executable(name: "FretCalculator", targets: ["FretCalculator"])
    ],
    targets: [
        .executableTarget(name: "FretCalculator", dependencies: []),
        .testTarget(name: "FretCalculatorTests", dependencies: ["FretCalculator"])
    ]
)
```

**Key Points**:
- `macOS(.v13)` → requires SwiftUI `Table` view
- Executable target (not library) → produces binary
- Test target depends on main target

### Build Script (Scripts/build_app.sh)

**Steps**:
1. `swift build -c release` → produces binary
2. Create app bundle directory structure
3. Resize icon to all required sizes using `sips`
4. Compile `.icns` file using `iconutil`
5. Ad-hoc code sign with `codesign`

**Why a script?**
- SPM doesn't handle app bundles or icons natively
- macOS apps require specific directory structure
- Simpler than hand-authoring Xcode project files

## Extending the App

### Adding New Features

**Example: Add support for non-12-TET tuning systems**

1. Add to `FretMath.swift`:
```swift
enum TuningSystem {
    case equalTemperament12
    case justIntonation
    case pythagorean
    
    var semitoneRatio: Double {
        switch self {
        case .equalTemperament12: return pow(2, 1/12.0)
        case .justIntonation: return 16/15  // A5:P4
        case .pythagorean: return 3/2       // Perfect 5th
        }
    }
}

static func calculate(
    scaleLengthInches: Double, 
    fretCount: Int,
    tuningSystem: TuningSystem = .equalTemperament12
) -> [FretPosition] {
    // Updated calculation using tuningSystem.semitoneRatio
}
```

2. Update UI in `ContentView.swift`:
```swift
@State private var selectedTuning: TuningSystem = .equalTemperament12

var positions: [FretPosition] {
    FretMath.calculate(
        scaleLengthInches: ...,
        fretCount: ...,
        tuningSystem: selectedTuning
    )
}
```

3. Add tests in `FretMathTests.swift`

### Code Style

**Conventions**:
- `var` for mutable, `let` for immutable
- CamelCase for types and functions
- POSIX locale for all number formatting
- Guard statements for early returns
- No force unwraps except in tests

**Example**:
```swift
func calculate(scaleLengthInches: Double, fretCount: Int) -> [FretPosition] {
    guard scaleLengthInches > 0, fretCount > 0 else { return [] }
    let scaleLengthMM = scaleLengthInches * 25.4
    // ...
}
```

## Performance

**Optimization Notes**:
- Calculations are O(n) where n = fretCount (typically 12-24)
- No expensive operations (pow is called once per fret, < 1ms total)
- UI updates are immediate (< 16ms between frames)
- Table rendering is smooth even with 50+ frets

**Profiling**:
```bash
# Time the build
time ./Scripts/build_app.sh

# Profile at runtime (use Instruments.app)
open /Applications/Xcode.app/Contents/Applications/Instruments.app
```

## Debugging

### Enable Debug Output

Add to `ContentView.swift`:
```swift
.onChange(of: scaleLengthText) { newValue in
    print("DEBUG: Scale length changed to \(newValue)")
    print("DEBUG: Parsed value: \(Double(newValue) ?? -1)")
}
```

### Console Logging

```bash
# Run with debug logging
swift build
RUST_LOG=debug swift run FretCalculator

# Or direct app:
open FretCalculator.app
# Console output appears in Console.app
```

### Inspect Calculated Values

```swift
// In ContentView or tests:
let positions = FretMath.calculate(scaleLengthInches: 25.5, fretCount: 24)
for position in positions {
    print("F\(position.fretNumber): \(position.distanceFromNutMM) mm")
}
```

## Common Development Tasks

### Update the Calculation Logic

1. Edit `Sources/FretCalculator/FretMath.swift`
2. Run `swift test` to verify
3. Rebuild: `./Scripts/build_app.sh`

### Add a New UI Feature

1. Edit `Sources/FretCalculator/ContentView.swift`
2. Rebuild: `./Scripts/build_app.sh`
3. Test: `open FretCalculator.app`

### Change the App Icon

1. Replace `Resources/AppIcon/source.png` with new image
2. Rebuild: `./Scripts/build_app.sh`
3. The icon is regenerated automatically

### Create a Distribution Build

```bash
./Scripts/build_app.sh
zip -r FretCalculator.zip FretCalculator.app
# Share FretCalculator.zip
```

## Troubleshooting Development

### "Expression is not allowed at top level"

**Cause**: Non-main file running as top-level code

**Fix**: Ensure Swift files in `Sources/` don't have top-level expressions (only declarations)

### "Cannot find 'pow' in scope"

**Cause**: Missing `import Foundation`

**Fix**: Add `import Foundation` to FretMath.swift

### Tests Not Running

**Cause**: Test target not properly linked

**Fix**:
```bash
swift test --build-tests  # Force rebuild tests
swift test               # Run again
```

### App Icon Not Updating

**Cause**: Cached icon or old .app bundle

**Fix**:
```bash
rm -rf FretCalculator.app
./Scripts/build_app.sh
```

## Resources

- [Swift Official Documentation](https://swift.org/documentation/)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [12-Tone Equal Temperament](https://en.wikipedia.org/wiki/Equal_temperament)
- [macOS App Bundle Structure](https://developer.apple.com/documentation/bundleresources/placing_content_in_a_bundle)

---

**Last Updated**: July 15, 2026  
**Swift Version**: 6.0+  
**macOS Minimum**: 13.0
