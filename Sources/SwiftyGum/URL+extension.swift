//
//  URL+extension.swift
//  Commander
//
//  Created by 松本淳之介 on 2020/06/09.
//

import Foundation
import Commander

extension URL: ArgumentConvertible {
    public init(parser: ArgumentParser) throws {
        if let value = parser.shift() {
            self.init(fileURLWithPath: value)
        } else {
            throw ArgumentError.missingValue(argument: nil)
        }
    }
}
