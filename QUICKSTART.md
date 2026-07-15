# Quick Start Guide

Get up and running with Fret Calculator in 2 minutes.

## Installation

### Option 1: Use Desktop Shortcut (Easiest)

Double-click **Fret Calculator** on your desktop.

### Option 2: Build from Source

```bash
cd /Users/gary/mysrc/claude/fret-calculator
./Scripts/build_app.sh
open FretCalculator.app
```

## Basic Usage (30 seconds)

1. **Launch** the app
2. **Enter** scale length: `25.5` (default is fine)
3. **Enter** fret count: `24` (default is fine)
4. **View** the table with all fret positions
5. **Click** "Copy Table" to copy to clipboard
6. **Paste** into Excel/Sheets/Numbers (Cmd+V)

That's it! Each measurement is now in its own spreadsheet cell.

## Default Values

| Field | Default | Unit |
|-------|---------|------|
| Scale Length | 25.5 | inches |
| Fret Count | 24 | - |

These defaults are for a standard electric guitar (Fender Stratocaster).

## Common Scale Lengths

```
Guitar (Fender)          25.5"
Guitar (Gibson)          24.75"
Mandolin                 13.75" - 14"
Ukulele                  15.4" - 17"
7-String Guitar          25.5" - 27"
Bass Guitar              34" - 35.25"
Classical Guitar         25.6" - 26"
Baritone Guitar          30"
```

## The Math

- **Fret 12** = exactly half the scale length (one octave)
- **Each fret** = previous fret + spacing between them
- **Spacing** gets smaller as you go up the fretboard
- Formula: `position = scaleLength × (1 - 1/2^(fret÷12))`

## What to Copy

The "Copy Table" button copies three columns in tab-separated format:

```
Fret    Distance from Nut (mm)    Distance from Previous Fret (mm)
F1      56.41                     56.41
F2      111.50                    55.09
```

## Use Cases

### Building an Instrument
1. Measure your scale length
2. Enter scale length and fret count
3. Copy measurements
4. Paste into spreadsheet
5. Use data to mark fret positions

### Verifying Fretwork
1. Measure actual frets
2. Compare to app's calculations
3. Identify out-of-spec frets

### Creating a Fretboard Diagram
1. Generate measurements
2. Paste into graphing software
3. Create scale template

## Troubleshooting

**No results showing?**
- Check scale length is a number (e.g., 25.5, not "25.5 inches")
- Check fret count is a number (e.g., 24, not "24 frets")

**Copy button disabled?**
- Make sure you've entered valid scale length and fret count

**Numbers look wrong?**
- Verify fret 12: should be exactly half your scale length
  - Example: 25.5" → fret 12 should be ≈323.85 mm

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Cmd+C | Copy (after clicking Copy Table button) |
| Cmd+Q | Quit |
| Tab | Next field |
| Shift+Tab | Previous field |

## Next Steps

- 📖 Read [USAGE.md](USAGE.md) for detailed instructions
- 🛠️ Read [BUILDING.md](BUILDING.md) to build from source
- 👨‍💻 Read [DEVELOPMENT.md](DEVELOPMENT.md) for technical details

## Example: Standard Guitar (25.5", 24 frets)

| Fret | From Nut (mm) | Spacing (mm) |
|------|---------------|--------------|
| F1   | 56.41         | 56.41        |
| F2   | 111.50        | 55.09        |
| F3   | 165.39        | 53.89        |
| F4   | 218.09        | 52.70        |
| F5   | 269.70        | 51.61        |
| F6   | 320.38        | 50.68        |
| F7   | 370.25        | 49.87        |
| F8   | 419.40        | 49.15        |
| F9   | 467.93        | 48.53        |
| F10  | 515.92        | 47.99        |
| F11  | 563.45        | 47.53        |
| F12  | 610.59        | 47.14        |
| ... | ... | ... |
| F24  | 647.70        | 19.92        |

Notice how fret 12 (610.59) is half the total (25.5 × 25.4 = 647.7).

## Still Have Questions?

See the full documentation:
- **README.md** — Overview and features
- **USAGE.md** — Detailed usage guide
- **BUILDING.md** — Build and installation
- **DEVELOPMENT.md** — Technical architecture

---

**Version**: 1.0  
**Platform**: macOS 13.0+
