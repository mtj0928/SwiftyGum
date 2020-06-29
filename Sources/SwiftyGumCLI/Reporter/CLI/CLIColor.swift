import Foundation

enum CLIColor {
    enum ColorCode: String {
        case black = "\u{1b}[30m"
        case red = "\u{1b}[31m"
        case green = "\u{1b}[32m"
        case yellow = "\u{1b}[33m"
        case blue = "\u{1b}[34m"
        case magenta = "\u{1b}[35m"
        case cyan = "\u{1b}[36m"
        case white = "\u{1b}[37m"
        case close = "\u{1b}[0m"
    }

    private static func translate(_ text: String, with color:  ColorCode) -> String {
        return "\(color.rawValue)\(text)\(ColorCode.close.rawValue)"
    }

    static func black(_ text: String) -> String {
        return translate(text, with: .black)
    }

    static func red(_ text: String) -> String {
        return translate(text, with: .red)
    }

    static func green(_ text: String) -> String {
        return translate(text, with: .green)
    }

    static func yellow(_ text: String) -> String {
        return translate(text, with: .yellow)
    }

    static func blue(_ text: String) -> String {
        return translate(text, with: .blue)
    }

    static func magenta(_ text: String) -> String {
        return translate(text, with: .magenta)
    }

    static func cyan(_ text: String) -> String {
        return translate(text, with: .cyan)
    }

    static func white(_ text: String) -> String {
        return translate(text, with: .white)
    }
}
