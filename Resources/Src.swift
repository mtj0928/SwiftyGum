class Hoge {
    func hoge(_ string: String) {
        let length = string.count
        print(length)
    }

    func min(x: Int, y: Int) -> Int {
        if x > y {
            return y
        } else if x <= y {
            return x
        }
    }
}
