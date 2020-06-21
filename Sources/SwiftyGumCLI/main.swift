import SwiftyGumCore
import Commander
import Foundation

let main = command(
    Argument<URL>("src"),
    Argument<URL>("dst")
) { src, dst in
    let start = Date()

    let editScript = try! SwifityGumCore.exec(srcUrl: src, dstUrl: dst)
    printEditScript(editScript)

    let elapsed = Date().timeIntervalSince(start)
    print("")
    print("Time: \(elapsed)")
}

main.run()

private func printEditScript(_ editScript: EditScript) {
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

extension Node {
    var string: String {
        if let value = value {
            return "\(label)(\(id)) (\"\(value)\")"
        }
        return "\(label)(\(id))"
    }
}
