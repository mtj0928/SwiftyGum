class Fuga {
    private func hoge(_ string: String) {
        print(string.count)
    }

    func min(x: Int, y: Int) -> Int {
        if x > y {
            return y
        } else if x <= y {
            return x
        }
    }
}
