import SwiftyGumCore
import Commander
import Foundation

let main = command(
    Argument<URL>("src",
                  description: "Source file (orifinal file)"
    ),
    Argument<URL>("dst",
                  description: "Destination file (editted file)"
    ),
    Option<Int>("min-height",
                default: SwiftyGumConfiguration.Default.minHeight,
                description: "Minimum height that AST nodes are matched in TopDown Matching"
    ),
    Option<Double>("sim-border",
                   default: SwiftyGumConfiguration.Default.simBorder,
                   description: "The boundary value that determins two different node should be matched."
    )
) { src, dst, minHeight, simBorder in
    let start = Date()
    do {
        let configuration = SwiftyGumConfiguration(minHeight: minHeight, simBoder: simBorder)

        let editScript = try SwifityGumCore.exec(srcUrl: src, dstUrl: dst, configuration: configuration)
        printEditScript(editScript)
    } catch (_) {
    }

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
