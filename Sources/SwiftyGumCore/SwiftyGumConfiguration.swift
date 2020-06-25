//
//  SwiftyGumConfiguration.swift
//  SwiftyGumCore
//
//  Created by 松本淳之介 on 2020/06/25.
//

import Foundation

public struct SwiftyGumConfiguration {

    public enum Default {
        public static let minHeight = 1
        public static let simBorder = 0.2
    }

    public let minHeight: Int
    public let simBoder: Double

    public init(minHeight: Int, simBoder: Double) {
        self.minHeight = minHeight
        self.simBoder = simBoder
    }
}
