# Fret Calculator

A native macOS SwiftUI application for calculating the positions of frets on a stringed instrument using 12-tone equal temperament tuning.

## Features

- **Scale Length Input**: Enter the scale length of your instrument in inches (e.g., 25.5" for a standard guitar)
- **Fret Count**: Specify how many frets your instrument has
- **Precise Measurements**: Each fret position calculated to 2 decimal places in millimeters
- **Three-Column Output**:
  - **Fret Number**: F1, F2, F3, ... Fn
  - **Distance from Nut**: Distance from the nut to each fret (mm)
  - **Spacing**: Distance between consecutive frets (mm)
- **Spreadsheet Export**: Copy button exports the table as tab-separated values (TSV) for direct pasting into Excel, Numbers, Google Sheets, or any spreadsheet application

## Installation

### Requirements
- macOS 13.0 or later
- Apple Silicon or Intel processor

### Quick Start

1. Navigate to the project directory:
   ```bash
   cd /Users/gary/mysrc/claude/fret-calculator
   ```

2. Build the application:
   ```bash
   ./Scripts/build_app.sh
   ```

3. Launch the app:
   ```bash
   open FretCalculator.app
   ```

## Usage

### Basic Workflow

1. **Enter Scale Length**: Type the scale length of your instrument in inches in the first field
2. **Enter Fret Count**: Type the number of frets in the second field
3. **View Results**: The table updates automatically showing all fret positions
4. **Copy to Clipboard**: Click "Copy Table" to copy the results in spreadsheet-friendly format
5. **Paste into Spreadsheet**: Open your spreadsheet application and paste

### Example: Standard Guitar (25.5" scale, 24 frets)

- Scale Length: `25.5`
- Fret Count: `24`
- Fret 1 distance: ~56.41 mm
- Fret 12 distance: ~323.85 mm (exactly half the scale length)
- Fret 24 distance: ~647.70 mm (approximately the full scale length)

## The Math

The application uses the standard formula for 12-tone equal temperament fret spacing:

```
Distance from nut = Scale Length (mm) × (1 - 1 / 2^(n/12))
```

Where:
- `n` is the fret number (1, 2, 3, ... 24)
- Scale length is automatically converted from inches to millimeters (×25.4)

**Why fret 12 matters**: At fret 12, the formula becomes `Scale Length × (1 - 1/2) = Scale Length × 0.5`, meaning fret 12 is always exactly halfway along the fretboard. This is a fundamental property of 12-tone equal temperament (the 12th fret is one octave above the open string).

## Project Structure

```
fret-calculator/
├── README.md                          # This file
├── Package.swift                      # Swift Package Manager configuration
├── Info.plist                         # App bundle metadata
├── .gitignore                         # Git ignore rules
│
├── Sources/FretCalculator/
│   ├── FretCalculatorApp.swift        # App entry point (@main)
│   ├── ContentView.swift              # SwiftUI UI components
│   ├── FretMath.swift                 # Pure fret calculation logic
│   └── Clipboard.swift                # Clipboard export functionality
│
├── Tests/FretCalculatorTests/
│   └── FretMathTests.swift            # Unit tests for calculation logic
│
├── Resources/AppIcon/
│   └── source.png                     # App icon source image
│
└── Scripts/
    └── build_app.sh                   # Build script for creating .app bundle
```

## Development

### Building from Source

```bash
# Debug build (faster, larger binary)
swift build

# Release build (optimized, smaller binary)
swift build -c release

# Run tests
swift test

# Build complete app bundle with icon
./Scripts/build_app.sh
```

### Testing

The project includes comprehensive unit tests for the fret calculation logic:

```bash
swift test
```

Test cases verify:
- Correct handling of edge cases (zero frets, negative scale length)
- Mathematical accuracy (fret 12 equals half scale length)
- Physical plausibility (increasing distances, decreasing spacing)

### Code Structure

**FretMath.swift**
- `FretPosition` struct: Represents a single fret with calculated distances
- `FretMath` enum: Contains the pure calculation function
- No UI dependencies, fully testable

**ContentView.swift**
- Main SwiftUI view with input fields and results table
- Real-time calculation as user types
- Input validation with error feedback

**Clipboard.swift**
- `copyTSV()`: Exports fret data as tab-separated values
- `format()`: Consistent decimal formatting using POSIX locale

**FretCalculatorApp.swift**
- App entry point with SwiftUI window configuration

## Technical Details

### Icon Generation

The app icon is automatically generated from the source image at multiple resolutions:
- 16×16, 32×32, 128×128, 256×256, 512×512 (and @2x variants for Retina)
- Built using macOS native tools: `sips` for resizing, `iconutil` for compilation

### App Bundle

The build script (`Scripts/build_app.sh`):
1. Compiles Swift code to a release binary
2. Generates icon assets in `.icns` format
3. Assembles the complete `.app` bundle structure
4. Ad-hoc code signs the bundle for execution

### Decimal Precision

All numeric output uses POSIX locale (dot separator, never comma) to ensure:
- Consistent display in the UI
- Reliable clipboard export for international users
- Proper parsing in spreadsheet applications

## Troubleshooting

### App Won't Launch
- Ensure macOS 13.0 or later
- Try rebuilding: `./Scripts/build_app.sh`
- Check codesigning: `codesign -v FretCalculator.app`

### Copy Button Not Working
- Ensure at least one fret is calculated
- Check that scale length and fret count are valid numbers
- Try clearing and re-entering values

### Icon Not Showing
- Rebuild the app: `./Scripts/build_app.sh`
- If using an older build, the source.png may be missing
- Verify `Resources/AppIcon/source.png` exists

## Future Enhancements

Possible additions:
- Multiple tuning systems (Just Intonation, Pythagorean, etc.)
- Fretboard diagram visualization
- Export to PDF
- Support for non-standard scale lengths
- History of recent calculations
- Dark mode optimization

## License

This project is created for personal use.

## Support

For issues or questions about the app, check:
1. The calculation accuracy against known references
2. That your scale length measurement is accurate
3. That input values are valid numbers

---

**Version**: 1.0  
**Build Date**: July 15, 2026  
**Platform**: macOS 13.0+
