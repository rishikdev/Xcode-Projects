typealias MyClosure = (_ a: Int, _ b: Int) -> Int

func doSomething(closure: MyClosure) {
    print(closure(1, 2))
}

doSomething { a, b in
    a + b * 2
}
