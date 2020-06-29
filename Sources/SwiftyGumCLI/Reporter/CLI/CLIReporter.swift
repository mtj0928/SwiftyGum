import SwiftyGumCore
import Darwin
import Darwin.ncurses

class CLIReporter: Reporter {
    func report(_ editScript: EditScript) {
        var w = winsize()
        guard ioctl(STDOUT_FILENO, TIOCGWINSZ, &w) == 0 else {
            return
        }
        let width = w.ws_col != 0 ? w.ws_col : 120

        editScript.actions.forEach { action in
            printEditAction(action)
        }
    }

    private func printEditAction(_ editAction: EditAction) {
        switch editAction {
        case .insert(let node, let to, let pos):
            print("\(CLIColor.green("INS")): \(node.string)\tto\t\(to.string)\tat\t\(pos)")
        case .delete(let node):
            print("\(CLIColor.red("DEL")): \(node.string)")
        case .update(let node, let newValue):
            print("\(CLIColor.yellow("UPD")): \(node.string)\tto\t\"\(newValue ?? "nil")\"")
        case .move(let node, let to, let pos):
            print("\(CLIColor.magenta("MOV")): \(node.string)\tto\t\(to.string)\tat\t\(pos)")
        }
    }
}

extension Node {
    var string: String {
        if let value = value {
            return "\(label)(\(id)) (\"\(value)\")"
        }
        return "\(label)(\(id))"
    }
}
