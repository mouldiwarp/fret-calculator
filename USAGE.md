# Using Fret Calculator

A step-by-step guide to using the Fret Calculator application.

## Launching the App

### From the Desktop

Double-click the **Fret Calculator** shortcut on your desktop.

### From Finder

Navigate to `/Users/gary/mysrc/claude/fret-calculator/` and double-click `FretCalculator.app`.

### From Terminal

```bash
open /Users/gary/mysrc/claude/fret-calculator/FretCalculator.app
```

## The Interface

The Fret Calculator window contains:

```
┌─────────────────────────────────────────────────┐
│ Fret Calculator                                 │
├─────────────────────────────────────────────────┤
│                                                 │
│ Scale Length (inches): [ 25.5         ]         │
│                                                 │
│ Number of Frets:       [ 24           ]         │
│                                                 │
├─────────────────────────────────────────────────┤
│                                                 │
│ Fret  │ From Nut (mm) │ Spacing (mm)           │
├───────┼───────────────┼────────────────────────┤
│ F1    │ 56.41         │ 56.41                  │
│ F2    │ 111.50        │ 55.09                  │
│ F3    │ 165.39        │ 53.89                  │
│ ...   │ ...           │ ...                    │
│ F24   │ 647.70        │ 19.92                  │
│                                                 │
├─────────────────────────────────────────────────┤
│ [Copy Table]                        [Spacer]    │
└─────────────────────────────────────────────────┘
```

## Step-by-Step Usage

### 1. Enter Scale Length

The first field defaults to **25.5 inches** (standard guitar scale length).

To use a different scale length:
1. Click the scale length field
2. Clear the current value (Cmd+A, then Delete)
3. Type your scale length in inches

**Examples:**
- Guitar (Fender Stratocaster): 25.5"
- Guitar (Gibson Les Paul): 24.75"
- Ukulele: 15.4" - 17"
- Bass: 34" - 35.25"
- Classical guitar: 25.6" - 26"

### 2. Enter Number of Frets

The second field defaults to **24 frets** (standard modern guitar).

To change:
1. Click the frets field
2. Clear and type the number of frets

**Common values:**
- Electric guitars: 21, 22, or 24 frets
- Classical guitars: 18 - 22 frets
- 7-string guitars: 24 frets
- Bass: 20 - 26 frets
- Ukulele: 12 - 18 frets

### 3. Review the Results

The table updates automatically as you type. It shows:

| Column | Meaning | Unit |
|--------|---------|------|
| Fret | Fret number (F1 through Fn) | - |
| From Nut | Distance from the nut to this fret | mm |
| Spacing | Distance from the previous fret | mm |

**Key observations:**
- "From Nut" values increase (frets get farther apart from the nut)
- "Spacing" values decrease (frets get closer together)
- Fret 12 is always exactly half the scale length
- The last fret gets very close to (but never reaches) the full scale length

### 4. Copy to Clipboard

When you're happy with your measurements:

1. Click the **Copy Table** button
2. The table is copied as tab-separated values (TSV)
3. The button is only enabled when there's valid data to copy

### 5. Paste into a Spreadsheet

Open your spreadsheet application and paste:

**Excel/Numbers/Google Sheets:**
- Cmd+V (or Ctrl+V on Windows)
- Each measurement lands in its own cell/column

**Result:**
```
Fret    Distance from Nut (mm)    Distance from Previous Fret (mm)
F1      56.41                     56.41
F2      111.50                    55.09
F3      165.39                    53.89
F4      218.09                    52.70
...
```

## Common Tasks

### Calculate Fret Positions for a New Build

1. Measure your instrument's scale length (from nut to bridge)
2. Enter the length in the first field
3. Enter the number of frets you want
4. Copy the table and paste into a spreadsheet
5. Use the measurements to mark fret positions during construction

### Compare Different Scale Lengths

1. Enter your first scale length and fret count
2. Copy and save the results (paste into a text editor or spreadsheet)
3. Change the scale length
4. Copy the new results
5. Compare the differences side-by-side

### Create a Fretboard Template

1. Set the scale length and fret count
2. Copy the table
3. Paste into a spreadsheet or drawing application
4. Use the data to create a scale template or fretboard diagram

### Verify Existing Fretwork

If repairing a fretboard:
1. Enter the original scale length and fret count
2. Compare the app's calculations to actual measurements
3. Identify any frets that are significantly out of position

## Troubleshooting

### Table Shows No Results

**Problem**: Entered data but the table is empty

**Solutions:**
- Check that scale length is a positive number (e.g., 25.5, not "25.5 inches")
- Check that fret count is a positive whole number (e.g., 24, not "24 frets")
- Clear fields and try again

### Copy Button is Grayed Out

**Problem**: "Copy Table" button is disabled

**Solutions:**
- Ensure scale length and fret count are both valid
- At least one fret must be calculated
- Try re-entering the values

### Numbers Look Wrong

**Problem**: Fret positions don't match expectations

**Solutions:**
- Verify scale length: double-check your measurement from nut to bridge
- Verify fret count: ensure you're entering the correct number of frets
- Compare fret 12: it should be exactly half the scale length
  - Example: 25.5" scale → fret 12 at 323.85 mm (25.5 × 25.4 ÷ 2)

### Decimals Not Displaying

**Problem**: Numbers show without decimal places

**Solutions:**
- Decimals are always calculated (to 2 places)
- Spreadsheet applications may hide trailing zeros
- Format your cells to display 2 decimal places

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| Cmd+C | (In spreadsheet) Copy table after clicking Copy button |
| Cmd+Q | Quit the application |
| Cmd+, | Open Preferences (if available) |
| Tab | Move to next field |
| Shift+Tab | Move to previous field |

## Tips & Tricks

### Calculate Nut-to-Bridge Distance

The app calculates from nut to fret, but you can use it to find total nut-to-bridge distance:
- The last fret position is approximately 98-99% of the scale length
- The exact scale length is the nut-to-bridge measurement

### Use Millimeters Directly

If you're more comfortable in millimeters:
- Convert: `scale_length_mm = scale_length_inches × 25.4`
- Example: 25.5" × 25.4 = 647.7 mm

### Verify Equal Temperament Spacing

Each fret's frequency is 2^(1/12) ≈ 1.0595 times the previous fret's frequency. The app's measurements ensure this acoustic relationship.

### Export for Multiple Tunings

The measurements are independent of tuning system — they work for any tuning that uses standard 12-tone equal temperament spacing.

## Getting Help

- **Calculation questions**: Refer to "The Math" section in README.md
- **Building from source**: See BUILDING.md
- **Technical details**: See DEVELOPMENT.md
- **Unexpected results**: Try the troubleshooting section above

---

**Version**: 1.0  
**Last Updated**: July 15, 2026
