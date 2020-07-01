import Foundation

public struct SwiftyGumConfiguration {

    public enum Default {
        public static let minHeight = 1
        public static let simBorder = 0.2
    }

    public let minHeight: Int
    public let simBorder: Double

    public init(minHeight: Int = Default.minHeight, simBorder: Double = Default.simBorder) {
        self.minHeight = minHeight
        self.simBorder = simBorder
    }
}
