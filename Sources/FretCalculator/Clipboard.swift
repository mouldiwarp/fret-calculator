import AppKit

enum Clipboard {
    static func copyTSV(_ positions: [FretPosition]) {
        var lines = ["Fret\tDistance from Nut (mm)\tDistance from Previous Fret (mm)"]
        for p in positions {
            lines.append("F\(p.fretNumber)\t\(format(p.distanceFromNutMM))\t\(format(p.distanceFromPreviousMM))")
        }
        let tsv = lines.joined(separator: "\n")
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(tsv, forType: .string)
    }

    static func format(_ value: Double) -> String {
        String(format: "%.2f", locale: Locale(identifier: "en_US_POSIX"), value)
    }
}
