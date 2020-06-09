import SwiftyGumCore
import Commander
import Foundation

let main = command(
    Argument<String>("src"),
    Argument<String>("dst")
) { src, dst in
    let core = SwifityGumCore(src: src, dst: dst)
}

main.run()
