import SwiftyGumCore
import Commander
import Foundation

let main = command(
    Argument<URL>("src"),
    Argument<URL>("dst")
) { src, dst in
    print("Start")
    let start = Date()
    _ = try! SwifityGumCore(srcUrl: src, dstUrl: dst)
    let elapsed = Date().timeIntervalSince(start)
    print("Time: \(elapsed)")
}

main.run()
