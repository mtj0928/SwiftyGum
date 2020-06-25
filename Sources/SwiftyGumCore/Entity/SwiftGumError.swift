//
//  SwiftGumError.swift
//  SwiftyGumCore
//
//  Created by 松本淳之介 on 2020/06/26.
//

import Foundation

public enum SwiftGumError: Error {
    case isNotSwiftFile(src: URL, dst: URL)
}
