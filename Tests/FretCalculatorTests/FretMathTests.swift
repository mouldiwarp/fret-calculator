import XCTest
@testable import FretCalculator

final class FretMathTests: XCTestCase {
    func testCalculateEmptyInput() {
        let result = FretMath.calculate(scaleLengthInches: -1, fretCount: 24)
        XCTAssertTrue(result.isEmpty)
    }

    func testCalculateZeroFrets() {
        let result = FretMath.calculate(scaleLengthInches: 25.5, fretCount: 0)
        XCTAssertTrue(result.isEmpty)
    }

    func testFret12IsHalfScale() {
        let scaleLengthInches = 25.5
        let result = FretMath.calculate(scaleLengthInches: scaleLengthInches, fretCount: 12)
        let fret12 = result[11]
        let expectedDistance = scaleLengthInches * 25.4 / 2
        XCTAssertEqual(fret12.distanceFromNutMM, expectedDistance, accuracy: 0.01)
    }

    func testFret1DistanceFromPreviousEqualsDistanceFromNut() {
        let result = FretMath.calculate(scaleLengthInches: 25.5, fretCount: 5)
        let fret1 = result[0]
        XCTAssertEqual(fret1.distanceFromPreviousMM, fret1.distanceFromNutMM, accuracy: 0.001)
    }

    func testFret24Standard() {
        let scaleLengthInches = 25.5
        let result = FretMath.calculate(scaleLengthInches: scaleLengthInches, fretCount: 24)
        XCTAssertEqual(result.count, 24)
        let fret24 = result[23]
        let scaleLengthMM = scaleLengthInches * 25.4
        let expectedDistance = scaleLengthMM * (1 - 1 / pow(2.0, 24.0 / 12.0))
        XCTAssertEqual(fret24.distanceFromNutMM, expectedDistance, accuracy: 0.01)
    }

    func testIncreasingDistances() {
        let result = FretMath.calculate(scaleLengthInches: 25.5, fretCount: 10)
        for i in 1..<result.count {
            XCTAssertTrue(result[i].distanceFromNutMM > result[i - 1].distanceFromNutMM)
        }
    }

    func testDecreasingSpacingBetweenFrets() {
        let result = FretMath.calculate(scaleLengthInches: 25.5, fretCount: 10)
        for i in 2..<result.count {
            XCTAssertTrue(result[i].distanceFromPreviousMM < result[i - 1].distanceFromPreviousMM)
        }
    }
}
