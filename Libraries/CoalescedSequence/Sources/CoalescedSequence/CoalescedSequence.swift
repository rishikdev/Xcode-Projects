// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A sequence wrapper that leaves out adjacent duplicate elements of a base sequence.
public struct CoalescedSequence<Base: Sequence> where Base.Element: Equatable {
    /// The base collection.
    @usableFromInline
    internal let base: Base

    @usableFromInline
    internal init(base: Base) {
        self.base = base
    }
}

extension CoalescedSequence: Sequence {
    /// The iterator for a `CoalescedSequence` instance.
    public struct Iterator: IteratorProtocol {
        @usableFromInline
        internal var base: Base.Iterator

        @usableFromInline
        internal var previousElement: Base.Element?

        @usableFromInline
        internal init(base: Base.Iterator) {
            self.base = base
            self.previousElement = nil
        }

        @inlinable
        public mutating func next() -> Base.Element? {
            while let element = base.next() {
                if previousElement == nil {
                    previousElement = element
                    return element
                } else if element != previousElement {
                    previousElement = element
                    return element
                }
            }
            return nil
        }
    }
    
    @inlinable
    public func makeIterator() -> Iterator {
        Iterator(base: base.makeIterator())
    }
}

extension CoalescedSequence: LazySequenceProtocol where Base: LazySequenceProtocol {}

//===----------------------------------------------------------------------===//
// coalescingAdjacentDuplicates()
//===----------------------------------------------------------------------===//

extension Sequence where Element: Equatable {

    /// Returns a sequence with no adjacent duplicate elements of this sequence, while
    /// maintaining the order of the sequence.
    ///
    ///     let numbers = [1, 2, 2, 3, 3, 3, 1]
    ///     print(Array(numbers.coalescingAdjacentDuplicates()))
    ///     // Prints "[1, 2, 3, 1]"
    ///
    /// - Returns: A sequence with no adjacent duplicate elements of this sequence.
    ///
    /// - Complexity: O(*n*), where *n* is the number of elements in the sequence.
    @inlinable
    public func coalescingAdjacentDuplicates() -> CoalescedSequence<Self> {
        CoalescedSequence(base: self)
    }
}
