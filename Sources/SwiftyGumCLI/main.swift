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
    Option<ReporterType>("report", default: .cli, description: "Report format of EditScript"),
    Option<Int>("min-height",
                default: SwiftyGumConfiguration.Default.minHeight,
                description: "Minimum height that AST nodes are matched in TopDown Matching"
    ),
    Option<Double>("sim-border",
                   default: SwiftyGumConfiguration.Default.simBorder,
                   description: "The boundary value that determins two different node should be matched."
    )
) { src, dst, reportType, minHeight, simBorder in
    let start = Date()
    do {
        let configuration = SwiftyGumConfiguration(minHeight: minHeight, simBoder: simBorder)

        let editScript = try SwifityGumCore.exec(srcUrl: src, dstUrl: dst, configuration: configuration)
        reportType.reporter.report(editScript)
    } catch let e {
        print(e.localizedDescription)
    }

    let elapsed = Date().timeIntervalSince(start)
    print("")
    print("Time: \(elapsed)")
}

main.run()
