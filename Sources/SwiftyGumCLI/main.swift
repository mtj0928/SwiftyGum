import SwiftyGumCore
import Commander
import Foundation

let main = command(
    Argument<URL>("src"),
    Argument<URL>("dst")
) { src, dst in
    let core = try! SwifityGumCore(srcUrl: src, dstUrl: dst)
}

main.run()
