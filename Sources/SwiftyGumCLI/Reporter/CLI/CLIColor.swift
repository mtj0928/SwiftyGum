import Foundation

enum CLIColor: String {

    case black = "\u{1b}[30m"
    case red = "\u{1b}[31m"
    case green = "\u{1b}[32m"
    case yellow = "\u{1b}[33m"
    case blue = "\u{1b}[34m"
    case magenta = "\u{1b}[35m"
    case cyan = "\u{1b}[36m"
    case white = "\u{1b}[37m"
    case none = "\u{1b}[0m"

    func text(_ text: String) -> String {
        "\(self.rawValue)\(text)\(CLIColor.none.rawValue)"
    }
}
