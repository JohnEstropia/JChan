//
//  JChan.swift
//  JChan
//
//  Created by John Estropia on 2016/09/14.
//  Copyright © 2016年 eureka, Inc. All rights reserved.
//

import Foundation


// MARK: - JChan

public struct JChan {
    
    public let reference: JChanReferenceType
    
    
    // MARK: Initialization
    
    public init(_ data: Data) throws {
        
        self.init(try JSONSerialization.jsonObject(with: data, options: .allowFragments))
    }
    
    public init(_ any: Any?) {
        
        switch any {
            
        case let reference as NSDictionary:
            self.init(reference)
            
        case let reference as NSArray:
            self.init(reference)
            
        case let reference as NSString:
            self.init(reference)
            
        case let reference as NSNumber:
            self.init(reference)
            
        case let reference as NSNull:
            self.init(reference)
            
        case nil:
            self.init(NSNull())
            
        default:
            fatalError()
        }
    }
    
    public init(_ reference: NSDictionary) {
        
        self.reference = reference
    }
    
    public init(_ reference: NSArray) {
        
        self.reference = reference
    }
    
    public init(_ reference: NSString) {
        
        self.reference = reference
    }
    
    public init(_ reference: NSNumber) {
        
        self.reference = reference
    }
    
    public init(_ reference: NSNull) {
        
        self.reference = reference
    }
    
    
    // MARK: Subscripts
    
    public subscript(_ key: String) -> JChan {
        
        switch self.reference {
            
        case let reference as NSDictionary:
            return JChan(reference[key])
            
        default:
            return nil
        }
    }
    
    
    // MARK: Accessors
    
    public var isNull: Bool {
        
        return self.reference is NSNull
    }
    
    public var null: Void? {
        
        return self.isNull ? () : nil
    }
    
    public var integer: Int? {
        
        return (self.reference as? NSNumber)?.intValue
    }
    
    public var boolean: Bool? {
        
        return (self.reference as? NSNumber)?.boolValue
    }
    
    public var float: Float? {
        
        return (self.reference as? NSNumber)?.floatValue
    }
    
    public var double: Double? {
        
        return (self.reference as? NSNumber)?.doubleValue
    }
    
    public var array: [JChan]? {
        
        guard let reference = (self.reference as? NSArray) else {
            
            return nil
        }
        return self.cachedArray.value({ reference.map({ JChan($0) }) })
    }
    
    public var dictionary: [String: JChan]? {
        
        guard let reference = (self.reference as? NSDictionary) else {
            
            return nil
        }
        return self.cachedDictionary.value({
            
            var dictionary = Dictionary<String, JChan>(minimumCapacity: reference.count)
            for (key, value) in reference {
                
                dictionary[key as! NSString as String] = JChan(value)
            }
            return dictionary
        })
    }
    
    public func integerValue(fallback: @autoclosure () -> Int = 0) -> Int {
        
        return self.integer ?? fallback()
    }
    
    public func booleanValue(fallback: @autoclosure () -> Bool = false) -> Bool {
        
        return self.boolean ?? fallback()
    }
    
    public func floatValue(fallback: @autoclosure () -> Float = 0) -> Float {
        
        return self.float ?? fallback()
    }
    
    public func doubleValue(fallback: @autoclosure () -> Double = 0) -> Double {
        
        return self.double ?? fallback()
    }
    
    public func arrayValue(fallback: @autoclosure () -> [JChan] = []) -> [JChan] {
        
        return self.array ?? fallback()
    }
    
    public func dictionaryValue(fallback: @autoclosure () -> [String: JChan] = [:]) -> [String: JChan] {
        
        return self.dictionary ?? fallback()
    }
    
    
    // MARK: Private
    
    private static let booleanObjCType = String(cString: NSNumber(value: true).objCType)
    
    private let cachedArray = LazyBox<[JChan]>()
    private let cachedDictionary = LazyBox<[String: JChan]>()
}


// MARK: - JChan: ExpressibleByDictionaryLiteral

extension JChan: ExpressibleByDictionaryLiteral {
    
    public init(dictionaryLiteral elements: (String, Any)...) {
        
        var dictionary = [String: JChanReferenceType](minimumCapacity: elements.count)
        for (key, value) in elements {
            
            dictionary[key] = (value as AnyObject as! JChanReferenceType)
        }
        self.init(dictionary as NSDictionary)
    }
}


// MARK: - JChan: ExpressibleByArrayLiteral

extension JChan: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: JChanReferenceType...) {
        
        self.init(elements as NSArray)
    }
}


// MARK: - JChan: ExpressibleByStringLiteral

extension JChan: ExpressibleByStringLiteral {
    
    public init(unicodeScalarLiteral value: String) {

        self.init(value as NSString)
    }

    public init(extendedGraphemeClusterLiteral value: String) {

        self.init(value as NSString)
    }

    public init(stringLiteral value: String) {

        self.init(value as NSString)
    }
}


// MARK: - JChan: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, ExpressibleByBooleanLiteral

extension JChan: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, ExpressibleByBooleanLiteral {
    
    public init(integerLiteral value: Int) {
        
        self.init(value as NSNumber)
    }

    public init(floatLiteral value: Double) {
        
        self.init(value as NSNumber)
    }

    public init(booleanLiteral value: Bool) {
        
        self.init(value as NSNumber)
    }
}


// MARK: - JChan: ExpressibleByNilLiteral

extension JChan: ExpressibleByNilLiteral {
    
    public init(nilLiteral: ()) {
        
        self.init(NSNull())
    }
}


// MARK: - JChan: CustomStringConvertible

extension JChan: CustomStringConvertible {
    
    public var description: String {
    
        return (self.reference as NSObjectProtocol).description
    }
}


// MARK: - JChan: CustomDebugStringConvertible

extension JChan: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        return (self.reference as NSObjectProtocol).debugDescription
            ?? (self.reference as NSObjectProtocol).description
    }
}


// MARK: - JChan: Hashable

extension JChan: Hashable {
    
    public var hashValue: Int {
        
        return (self.reference as NSObjectProtocol).hash
    }
}


// MARK: - JChan: Equatable

extension JChan: Equatable {
    
    public static func == (lhs: JChan, rhs: JChan) -> Bool {
        
        return (lhs.reference as NSObjectProtocol).isEqual(rhs.reference)
    }
}


protocol JChanReferenceConvertable {
    
    var asJChanReference: JChanReferenceType { get }
    
    static func convert(from: JChanReferenceType) -> Self
}


// MARK: - JChanValueType

public protocol JChanValueType {}


// MARK: - JChanReferenceType

public protocol JChanReferenceType: AnyObject, NSObjectProtocol, NSCopying, NSCoding {}


// MARK: - NSDictionary: JChanReferenceType

extension NSDictionary: JChanReferenceType {}


// MARK: - NSArray: JChanReferenceType

extension NSArray: JChanReferenceType {}


// MARK: - NSString: JChanReferenceType

extension NSString: JChanReferenceType {}


// MARK: - NSNumber: JChanReferenceType

extension NSNumber: JChanReferenceType {}


// MARK: - NSNull: JChanReferenceType

extension NSNull: JChanReferenceType {}



// MARK: - Private utilities

fileprivate enum LazyValue<T> {
    
    case pending
    case value(T)
}

fileprivate final class LazyBox<T> {
    
    fileprivate func value(_ computation: () -> T) -> T {
        
        switch self.boxed {
            
        case .pending:
            let result = computation()
            self.boxed = .value(result)
            return result
            
        case .value(let result):
            return result
        }
    }
    
    private var boxed: LazyValue<T> = .pending
}
