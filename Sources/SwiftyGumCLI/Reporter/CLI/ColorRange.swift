struct ColorRange {
    let range: Range<String.Index>
    let color: CLIColor
}

struct CLIString {
    let text: String
    private(set) var colorRanges = [ColorRange]()

    init(text: String) {
        self.text = text
        colorRanges = [ColorRange(range: text.startIndex..<text.endIndex, color: .none)]
    }

    mutating func append(_ newObject: ColorRange) {
        defer {
            colorRanges.sort(by: { $0.range.lowerBound <= $1.range.lowerBound && $0.range.upperBound <= $1.range.upperBound })
        }

        guard let index = searchIndex(for: newObject) else {
            colorRanges.append(newObject)
            return
        }

        let removedColorRange = colorRanges.remove(at: index)

        if removedColorRange.color == newObject.color {
            colorRanges.append(removedColorRange)
            return
        } else if removedColorRange.range == newObject.range {
            colorRanges.append(ColorRange(range: removedColorRange.range, color: newObject.color))
            return
        }

        if removedColorRange.range.lowerBound != newObject.range.lowerBound {
            colorRanges.append(ColorRange(range: removedColorRange.range.lowerBound..<newObject.range.lowerBound, color: removedColorRange.color))
        }

        colorRanges.append(ColorRange(range: newObject.range.lowerBound..<newObject.range.upperBound, color: newObject.color))

        if removedColorRange.range.upperBound != newObject.range.upperBound {
            colorRanges.append(ColorRange(range: newObject.range.upperBound..<removedColorRange.range.upperBound, color: removedColorRange.color))
        }
    }

    private func searchIndex(for object: ColorRange) -> Int? {
        colorRanges.firstIndex(where: {
            $0.range.lowerBound <= object.range.lowerBound
                && object.range.upperBound <= $0.range.upperBound
        })
    }

    var string: String {
        var text = self.text
        let revesed = colorRanges.sorted(by: { $0.range.lowerBound <= $1.range.lowerBound && $0.range.upperBound <= $1.range.upperBound }).reversed()
        var index = 0
        revesed.forEach { colorRange in
            if colorRange.color != .none {
                text.insert(contentsOf: CLIColor.none.rawValue, at: colorRange.range.upperBound)
            }

            // ommision for unedited text
            if colorRange.color == .none {
                let substring = text[colorRange.range]
                var lines = [String]()
                substring.enumerateLines { (line, stop) in lines.append(line) }

                if index == 0 && lines.count >= 3 {
                    lines = [lines[0], lines[1], lines[2]]
                } else if index == colorRanges.count - 1 && lines.count >= 3 {
                    lines = [lines[lines.count - 3], lines[lines.count - 2], lines[lines.count - 1]]
                } else if lines.count >= 7 {
                    lines = [lines[0], lines[1], lines[2], "~~~~~",lines[lines.count - 3], lines[lines.count - 2], lines[lines.count - 1]]
                }
                let omittedText = lines.joined(separator: "\n")
                text.replaceSubrange(colorRange.range, with: omittedText)
            }

            if colorRange.color != .none {
                text.insert(contentsOf: colorRange.color.rawValue, at: colorRange.range.lowerBound)
            }
            index += 1
        }
        return text
    }
}
