struct ColorRange {
    let range: Range<Int>
    let color: CLIColor
}

struct CLIString {
    let text: String.UTF8View
    private(set) var colorRanges = [ColorRange]()

    init(text: String.UTF8View) {
        self.text = text
        colorRanges = [ColorRange(range: 0..<text.count, color: .none)]
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
                text.insert(contentsOf: CLIColor.none.rawValue.utf8, at: colorRange.range.upperBound)
            }

            // ommision for unedited text
            if colorRange.color == .none {
                let startIndex = text.index(text.startIndex, offsetBy: colorRange.range.lowerBound)
                let endIndex = text.index(text.startIndex, offsetBy: colorRange.range.upperBound)
                let substring = text[startIndex..<endIndex]
                var lines = [String]()
                substring.enumerateLines { lines.append($0) }

                if index == 0 && lines.count >= 3 {
                    lines = [lines[0], lines[1], lines[2]]
                } else if index == colorRanges.count - 1 && lines.count >= 3 {
                    lines = [lines[lines.count - 3], lines[lines.count - 2], lines[lines.count - 1]]
                } else if lines.count >= 7 {
                    lines = [lines[0], lines[1], lines[2], "~~~~~",lines[lines.count - 3], lines[lines.count - 2], lines[lines.count - 1]]
                }
                let omittedText = lines.joined(separator: "\n")
                text.replaceSubrange(colorRange.range, with: omittedText.utf8)
            }

            if colorRange.color != .none {
                text.insert(contentsOf: colorRange.color.rawValue.utf8, at: colorRange.range.lowerBound)
            }
            index += 1
        }
        return String(text)
    }
}

extension String.UTF8View {

    mutating func insert(contentsOf text: String.UTF8View, at offset: Int) {
        let index = self.index(self.startIndex, offsetBy: offset)
        let first = self[self.startIndex..<index]
        let second = self[index..<self.endIndex]
        let internalText = text[text.startIndex..<text.endIndex]
        let substring = Substring(first) + Substring(internalText) + Substring(second)
        self = String(substring).utf8
    }

    mutating func replaceSubrange(_ range: Range<Int>, with text: String.UTF8View) {
        let range = self.index(self.startIndex, offsetBy: range.lowerBound)..<self.index(self.startIndex, offsetBy: range.upperBound)
        let first = self[self.startIndex..<range.lowerBound]
        let second = self[range.upperBound..<self.endIndex]
        let internalText = text[text.startIndex..<text.endIndex]
        let substring = Substring(first) + Substring(internalText) + Substring(second)
        self = String(substring).utf8
    }
}

extension String.UTF8View.SubSequence {

    func enumerateLines(_ handler: @escaping (String) -> Void) {
        let string = String(self)
        string?.enumerateLines { (line, _) in
            handler(line)
        }
    }
}
