import SwiftyGumCore
import Darwin
import Darwin.ncurses
import SwiftSyntax
import Foundation

class CLIReporter: Reporter {
    func report(_ editScript: EditScript) {
        var w = winsize()
        guard ioctl(STDOUT_FILENO, TIOCGWINSZ, &w) == 0 else {
            return
        }
        // let width = w.ws_col != 0 ? w.ws_col : 120

        print(CLIColor.cyan.text("--- \(editScript.srcSourceCode.url.path)"))
        let srcColorText = stringWithColorForSrc(of: editScript)
        print(srcColorText.string)

        print(CLIColor.cyan.text("+++ \(editScript.dstSourceCode.url.path)"))
        let dstColorText = stringWithColorForDst(of: editScript)
        print(dstColorText.string)
    }

    private func stringWithColorForSrc(of editScript: EditScript) -> CLIString {
        let actions = extractActionsForSrc(from: editScript)
            .sorted(by: { $0.node.distanceFromRoot <= $1.node.distanceFromRoot })

        guard !actions.isEmpty else {
            return CLIString(text: "".utf8)
        }

        let sourceCodeText = editScript.srcSourceCode.text.utf8
        var stringWithColor = CLIString(text: sourceCodeText)

        actions.forEach { action in
            let range = action.node.offSet..<(action.node.offSet + action.node.length)
            stringWithColor.append(ColorRange(range: range, color: action.color))
        }

        return stringWithColor
    }

    private func extractActionsForSrc(from editScript: EditScript) -> [EditAction] {
        editScript.actions
            .filter {
                switch $0 {
                case .insert(_, _, _):
                    return false
                default:
                    return true
                }
        }
    }

    private func stringWithColorForDst(of editScript: EditScript) -> CLIString {
        let mappingStore = editScript.mappingStore
        let actions = extractActionsForDst(from: editScript)
            .sorted(by: { mappingStore.mathcedDstNode(with: $0.node)!.distanceFromRoot <= mappingStore.mathcedDstNode(with: $1.node)!.distanceFromRoot })

        guard !actions.isEmpty else {
            return CLIString(text: "".utf8)
        }

        let sourceCodeText = editScript.dstSourceCode.text.utf8
        var stringWithColor = CLIString(text: sourceCodeText)

        actions.forEach { action in
            guard let node = editScript.mappingStore.mathcedDstNode(with: action.node) else {
                return
            }
            let range = node.offSet ..< (node.offSet + node.length)
            stringWithColor.append(ColorRange(range: range, color: action.color))
        }

        return stringWithColor
    }

    private func extractActionsForDst(from editScript: EditScript) -> [EditAction] {
        editScript.actions
            .filter {
                switch $0 {
                case .delete(_):
                    return false
                default:
                    return true
                }
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

    fileprivate func contains(index: Int) -> Order {
        if index < offSet {
            return .previouse
        } else if offSet <= index && index <= offSet + length {
            return .contain
        } else {
            return .next
        }
    }
}

extension EditAction {
    var color: CLIColor {
        switch self {
        case .insert:
            return .green
        case .delete:
            return .red
        case .move:
            return .magenta
        case .update:
            return .yellow
        }
    }
}

private enum Order {
    case previouse, contain, next
}
