import Foundation

struct FretPosition: Identifiable {
    let fretNumber: Int
    let distanceFromNutMM: Double
    let distanceFromPreviousMM: Double

    var id: Int { fretNumber }
}

enum FretMath {
    static func calculate(scaleLengthInches: Double, fretCount: Int) -> [FretPosition] {
        guard scaleLengthInches > 0, fretCount > 0 else { return [] }
        let scaleLengthMM = scaleLengthInches * 25.4
        var positions: [FretPosition] = []
        var previous = 0.0
        for n in 1...fretCount {
            let distance = scaleLengthMM * (1 - 1 / pow(2.0, Double(n) / 12.0))
            positions.append(FretPosition(
                fretNumber: n,
                distanceFromNutMM: distance,
                distanceFromPreviousMM: distance - previous
            ))
            previous = distance
        }
        return positions
    }
}
