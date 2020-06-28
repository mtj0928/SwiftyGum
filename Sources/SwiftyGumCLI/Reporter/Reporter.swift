import SwiftyGumCore
import Commander

protocol Reporter {
    func report(_ editScript: EditScript)
}

enum ReporterType: String, ArgumentConvertible {

    case list, cli

    var description: String {
        return self.rawValue
    }

    init(parser: ArgumentParser) throws {
        guard let string = parser.shift(),
        let type = ReporterType(rawValue: string) else {
            throw ArgumentParserError("Failed Parse as URL")
        }
        self = type
    }

    var reporter: Reporter {
        switch self {
        case .list:
            return ListReporter()
        case .cli:
            return CliReporter()
        }
    }
}
