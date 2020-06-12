import Foundation
import Commander

extension URL: ArgumentConvertible {

    public init(parser: ArgumentParser) throws {
        guard let string = parser.shift() else {
            throw ArgumentParserError("Failed Parse as URL")
        }
        self.init(fileURLWithPath: string)
    }
}
