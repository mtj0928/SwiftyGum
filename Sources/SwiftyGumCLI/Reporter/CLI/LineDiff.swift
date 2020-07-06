import Foundation

class Diff {

    static func exec(src: URL, dst: URL) {
        let script = diffScript(src: src, dst: dst)
        var process: Process? = Process.launchedProcess(launchPath: "/bin/sh", arguments: ["-c", script])
        process?.waitUntilExit()
        process?.terminate()
        process = nil
    }

    private static func diffScript(src: URL, dst: URL) -> String {
        """
        if type "colordiff" > /dev/null 2>&1; then
            diffcommand="diff"
        else
            diffcommand="colordiff"
        fi

        $diffcommand -u \(src.path) \(dst.path)
        """
    }
}
