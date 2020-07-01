import Foundation

enum CLIColor: String {

    case black      = "\u{001b}[30m"
    case red        = "\u{001b}[31m"
    case green      = "\u{001b}[32m"
    case yellow     = "\u{001b}[33m"
    case blue       = "\u{001b}[34m"
    case magenta    = "\u{001b}[35m"
    case cyan       = "\u{001b}[36m"
    case white      = "\u{001b}[37m"
    case none       = "\u{001b}[0m"

    func text(_ text: String) -> String {
        "\(self.rawValue)\(text)\(CLIColor.none.rawValue)"
    }
}
