import SwiftUI

struct ContentView: View {
    @State private var scaleLengthText: String = "25.5"
    @State private var fretCountText: String = "24"

    var positions: [FretPosition] {
        guard let scaleLengthInches = Double(scaleLengthText),
              let fretCount = Int(fretCountText) else {
            return []
        }
        return FretMath.calculate(scaleLengthInches: scaleLengthInches, fretCount: fretCount)
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                HStack {
                    Label("Scale Length (inches):", systemImage: "ruler")
                        .frame(width: 180, alignment: .leading)
                    TextField("", text: $scaleLengthText)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                }

                HStack {
                    Label("Number of Frets:", systemImage: "music.note")
                        .frame(width: 180, alignment: .leading)
                    TextField("", text: $fretCountText)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 100)
                }
            }
            .padding(.top, 16)

            if positions.isEmpty && (!scaleLengthText.isEmpty || !fretCountText.isEmpty) {
                Text("Please enter valid scale length and fret count")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }

            Table(positions) {
                TableColumn("Fret") { position in
                    Text("F\(position.fretNumber)")
                }
                TableColumn("From Nut (mm)") { position in
                    Text(Clipboard.format(position.distanceFromNutMM))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                TableColumn("Spacing (mm)") { position in
                    Text(Clipboard.format(position.distanceFromPreviousMM))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .disabled(positions.isEmpty)

            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    Menu {
                        Button(action: {
                            Clipboard.copyTSV(positions)
                        }) {
                            Label("Entire Table", systemImage: "table")
                        }
                        Divider()
                        Button(action: {
                            Clipboard.copyColumn2(positions)
                        }) {
                            Label("Column 2: From Nut (mm)", systemImage: "list.number")
                        }
                        Button(action: {
                            Clipboard.copyColumn3(positions)
                        }) {
                            Label("Column 3: Spacing (mm)", systemImage: "list.number")
                        }
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    .disabled(positions.isEmpty)

                    Spacer()
                }
                .padding(.horizontal, 4)
            }
            .padding(.bottom, 16)
        }
        .padding(16)
        .frame(minWidth: 600, idealWidth: 700, minHeight: 500, idealHeight: 600)
    }
}

#Preview {
    ContentView()
}
