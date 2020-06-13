import SwiftSyntax

extension Syntax {
    var label: String {
        var syntax = "\(customMirror.subjectType)"
        if syntax.hasSuffix("Syntax") {
            syntax = String(syntax.dropLast(6))
        }
        return syntax
    }

    var token: String? {
        guard self.isToken else {
            return nil
        }
        return self.as(TokenSyntax.self)?.text
    }
}
