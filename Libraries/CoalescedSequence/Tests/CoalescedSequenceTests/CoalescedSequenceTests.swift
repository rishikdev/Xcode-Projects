import Testing
@testable import CoalescedSequence

@Suite("CoalescingAdjacentDuplicatesTests")
struct CoalescingAdjacentDuplicatesTests {
    // MARK: - Basic Tests

    @Test("Test Empty Sequence")
    func testEmptySequence() {
        let empty: [Int] = []
        let result = Array(empty.coalescingAdjacentDuplicates())
        #expect(result == [])
    }

    @Test("Test No Duplicates")
    func testNoDuplicates() {
        let input = [1, 2, 3, 4, 5]
        let result = Array(input.coalescingAdjacentDuplicates())
        #expect(result == input)
    }

    @Test("Test Adjacent Duplicates Integers")
    func testAdjacentDuplicatesIntegers() {
        let input = [1, 2, 2, 3, 3, 3, 1]
        let expected = [1, 2, 3, 1]
        let result = Array(input.coalescingAdjacentDuplicates())
        #expect(result == expected)
    }

    @Test("Test Adjacent Duplicates Strings")
    func testAdjacentDuplicatesStrings() {
        let input = ["a", "a", "b", "c", "c"]
        let expected = ["a", "b", "c"]
        let result = Array(input.coalescingAdjacentDuplicates())
        #expect(result == expected)
    }

    @Test("Test Non Adjacent Duplicates")
    func testNonAdjacentDuplicates() {
        let input = [1, 2, 1, 3, 2]
        let result = Array(input.coalescingAdjacentDuplicates())
        #expect(result == input)
    }

    @Test("Test Mixed Duplicates")
    func testMixedDuplicates() {
        let input = [1, 1, 2, 3, 3, 2, 1]
        let expected = [1, 2, 3, 2, 1]
        let result = Array(input.coalescingAdjacentDuplicates())
        #expect(result == expected)
    }

    @Test("Test Repeated First Element")
    func testRepeatedFirstElement() {
        let input = [1, 1, 1, 2, 3]
        let expected = [1, 2, 3]
        let result = Array(input.coalescingAdjacentDuplicates())
        #expect(result == expected)
    }

    @Test("Test Repeated Last Element")
    func testRepeatedLastElement() {
        let input = [1, 2, 3, 1, 1, 1]
        let expected = [1, 2, 3, 1]
        let result = Array(input.coalescingAdjacentDuplicates())
        #expect(result == expected)
    }

    @Test("Test Only Duplicates")
    func testOnlyDuplicates() {
        let input = [1, 1, 1, 1]
        let expected = [1]
        let result = Array(input.coalescingAdjacentDuplicates())
        #expect(result == expected)
    }

    // MARK: - Chained Operations Tests

    @Test("Test Reversed")
    func testReversed() {
        let input = [1, 2, 2, 3]
        let expected = [3, 2, 1]
        let result = Array(input.coalescingAdjacentDuplicates().reversed())
        #expect(result == expected)
    }

    @Test("Test Prefix")
    func testPrefix() {
        let input = [1, 2, 2, 3]
        let expected = [1, 2]
        let result = Array(input.coalescingAdjacentDuplicates().prefix(2))
        #expect(result == expected)
    }

    @Test("Test Map")
    func testMap() {
        let input = [1, 2, 2, 3]
        let expected = [2, 4, 6]
        let result = Array(input.coalescingAdjacentDuplicates().map { $0 * 2 })
        #expect(result == expected)
    }

    @Test("Test Combined Chained Operations")
    func testCombinedChainedOperations() {
        let input = [1, 2, 2, 3, 3, 1]
        let expected = [2, 4, 3]
        let result = Array(input.coalescingAdjacentDuplicates().reversed().prefix(3).map { $0 + 1 })
        #expect(result == expected)
    }

    // MARK: - Custom Equatable Types Test

    struct TestStruct: Equatable {
        let value: Int
    }

    @Test("Test Custom Equatable Types")
    func testCustomEquatableTypes() {
        let input = [TestStruct(value: 1), TestStruct(value: 1), TestStruct(value: 2)]
        let expected = [TestStruct(value: 1), TestStruct(value: 2)]
        let result = Array(input.coalescingAdjacentDuplicates())
        #expect(result == expected)
    }

    // MARK: - Large Sequences Test

    @Test("Test Large Sequence")
    func testLargeSequence() {
        let largeInput = (0..<1000).flatMap { [$0, $0] }
        let expected = Array(0..<1000)
        let result = Array(largeInput.coalescingAdjacentDuplicates())
        #expect(result == expected)
    }
}

