import Foundation

public struct SourceCode {
    public let text: String
    public let url: URL

    init(url: URL) throws {
        self.url = url
        self.text = try String(contentsOf: url)
    }
}
