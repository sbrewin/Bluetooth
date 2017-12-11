//
//  BitMaskOption.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

// MARK: - BitMaskOption

#if swift(>=4.0)
    
    /// Enum that represents a bit mask flag / option.
    ///
    /// Basically `Swift.OptionSet` for enums.
    public protocol BitMaskOption: RawRepresentable, Hashable where RawValue: FixedWidthInteger {
    
        /// All the cases of the enum.
        static var all: BitMaskOptionSet<Self> { get }
    
    }
    
#elseif swift(>=3.0.2)
    
    /// Enum that represents a bit mask flag / option.
    ///
    /// Basically `Swift.OptionSet` for enums.
    public protocol BitMaskOption: RawRepresentable, Hashable {
        
        associatedtype RawValue: Integer
        
        /// All the cases of the enum.
        static var all: Set<Self> { get }
    }
    
#endif

#if swift(>=4.0)
    
    public extension Sequence where Element: BitMaskOption {
    
        /// Convert Swift enums for option flags into their raw values OR'd.
        var flags: Element.RawValue {
    
            @inline(__always)
            get { return reduce(0, { $0 | $1.rawValue }) }
        }
    }
    
#elseif swift(>=3.0.2)
    
    public extension Sequence where Iterator.Element: BitMaskOption {
        
        /// Convert Swift enums for option flags into their raw values OR'd.
        var flags: Iterator.Element.RawValue {
            
            @inline(__always)
            get { return reduce(0, { $0 | $1.rawValue }) }
        }
    }
    
#endif

public extension BitMaskOption {
    
    /// Whether the enum case is present in the raw value.
    @inline(__always)
    func isContained(in rawValue: RawValue) -> Bool {
        
        return (self.rawValue & rawValue) != 0
    }
    
    @inline(__always)
    static func from(flags: RawValue) -> Set<Self> {
        
        #if swift(>=4.0)
            return Self.all.filter({ $0.isContained(in: flags) })
        #elseif swift(>=3.0.2)
            return Set(Array(Self.all).filter({ $0.isContained(in: flags) }))
        #endif
    }
}

// MARK: - BitMaskOptionSet

/// Integer-backed array type for `BitMaskOption`.
///
/// The elements are packed in the integer with bitwise math and stored on the stack.
public struct BitMaskOptionSet <Element: BitMaskOption>: RawRepresentable {
    
    public typealias RawValue = Element.RawValue
    
    public fileprivate(set) var rawValue: RawValue
    
    @inline(__always)
    public init(rawValue: RawValue) {
        
        self.rawValue = rawValue
    }
    
    @inline(__always)
    public init() {
        
        self.rawValue = 0
    }
    
    public static var all: BitMaskOptionSet<Element> {
        
        return BitMaskOptionSet<Element>.init(Element.all)
    }
    
    @inline(__always)
    public mutating func insert(_ element: Element) {
        
        rawValue = rawValue | element.rawValue
    }
    
    @inline(__always)
    public mutating func removeAll() {
    
        self.rawValue = 0
    }
    
    @inline(__always)
    public func contains(_ element: Element) -> Bool {
        
        return element.isContained(in: rawValue)
    }
    
    public func contains <S: Sequence> (_ other: S) -> Bool where S.Iterator.Element == Element {
        
        for element in other {
            
            guard element.isContained(in: rawValue)
                else { return false }
        }
        
        return true
    }
    
    public var containsAll: Bool {
        
        return self == .all
    }
    
    public var count: Int {
        
        return Element.all.reduce(0, { $0.0 + ($0.1.isContained(in: rawValue) ? 1 : 0) })
    }
    
    public var isEmpty: Bool {
        
        return rawValue == 0
    }
}

// MARK: - Sequence Conversion

public extension BitMaskOptionSet {
    
    public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
        
        self.rawValue = sequence.flags
    }
}

// MARK: - Set Conversion

public extension BitMaskOptionSet {
    
    public var set: Set<Element> {
        
        get { return Element.from(flags: rawValue) }
    }
}

// MARK: - Equatable

extension BitMaskOptionSet: Equatable {
    
    @inline(__always)
    public static func == (lhs: BitMaskOptionSet, rhs: BitMaskOptionSet) -> Bool {
        
        return lhs.rawValue == rhs.rawValue
    }
}

// MARK: - Hashable

extension BitMaskOptionSet: Hashable {
    
    public var hashValue: Int {
        
        return rawValue.hashValue
    }
}

// MARK: -  ExpressibleByArrayLiteral

extension BitMaskOptionSet: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: Element...) {
        
        self.init(elements)
    }
}

// MARK: - Collection

extension BitMaskOptionSet: Sequence {
    
    public func makeIterator() -> SetIterator<Element> {
        
        return self.set.makeIterator()
    }
}
