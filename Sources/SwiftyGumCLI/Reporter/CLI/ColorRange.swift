struct ColorRange {
    let range: Range<String.Index>
    let color: CLIColor
}

struct StringWithColor {
    let text: String
    private(set) var colorRanges = [ColorRange]()

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
        revesed.forEach { colorRange in
            text.insert(contentsOf: CLIColor.close.rawValue, at: colorRange.range.upperBound)
            text.insert(contentsOf: colorRange.color.rawValue, at: colorRange.range.lowerBound)
        }
        return text
    }
}
