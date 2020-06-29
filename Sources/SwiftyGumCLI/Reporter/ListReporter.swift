import SwiftyGumCore

class ListReporter: Reporter {
    func report(_ editScript: EditScript) {
        editScript.actions.forEach { action in
            printEditAction(action)
        }
    }

    private func printEditAction(_ editAction: EditAction) {
        switch editAction {
        case .insert(let node, let to, let pos):
            print("INS: \(node.string)\tto\t\(to.string)\tat\t\(pos)")
        case .delete(let node):
            print("DEL: \(node.string)")
        case .update(let node, let newValue):
            print("UPD: \(node.string)\tto\t\"\(newValue ?? "nil")\"")
        case .move(let node, let to, let pos):
            print("MOV: \(node.string)\tto\t\(to.string)\tat\t\(pos)")
        }
    }
}
