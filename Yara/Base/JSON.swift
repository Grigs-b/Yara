//
//  JSON.swift
//  Yara
//
//  Created by Ryan Grigsby on 3/24/17.
//  Copyright © 2017 Grigs-b. All rights reserved.
//

import Foundation

typealias JSON = Any
typealias JSONDictionary = [String: JSON]
typealias JSONArray = [JSON]

protocol Decodable {
    init(dictionary: JSONDictionary) throws
}

protocol Encodable {
    func toJSON() -> JSONDictionary
}

enum SerializationError: Error {
    case invalidData
    case missingKey(String)
    case valueTypeMismatch(String)
    case expectedDictionary
    case expectedArray
}

extension Decodable {
    /// Creates an instance of `Self` where `data` contains a valid JSON representation of `Self`
    static func make(data: Data) throws -> Self {
        guard let object = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary else {
            throw SerializationError.expectedDictionary
        }

        return try Self.init(dictionary: object)
    }

    /// Creates instances of `Self` where `data` contains a valid JSON representation of an array of `Self`
    static func make(data: Data) throws -> [Self] {
        guard let object = try JSONSerialization.jsonObject(with: data, options: []) as? [JSONDictionary] else {
            throw SerializationError.expectedArray
        }

        return try make(array: object)
    }

    /// Creates instances of `Self` where `array` contains valid JSON representations of `Self`
    static func make(array: [JSONDictionary]) throws -> [Self] {
        return try array.map { try Self.init(dictionary: $0) }
    }
}

/// Provides methods to decode values from a JSON dictionary that throw JSONParseError based on type
extension Dictionary where Key: ExpressibleByStringLiteral, Value: JSON {

    /// decode the value for `key` where `T` is not optional
    func decode<T>(_ key: Key) throws -> T {
        return try decodeNonOptionalValue(for: key)
    }

    /// decode the value for `key` where `T` can be optional. Being absent or NSNull is allowed
    func decode<T: ExpressibleByNilLiteral>(_ key: Key) throws -> T {
        let value = self[key]

        if value == nil {
            return nil
        } else {
            return try decodeNonOptionalValue(for: key)
        }
    }

    /// performs the work of decoding the value for `key` where `T` is not optional
    func decodeNonOptionalValue<T>(for key: Key) throws -> T {
        switch self[key] {
        case let value as T:
            return value

        case nil:
            throw SerializationError.missingKey(String(describing: key))

        case .some:
            throw SerializationError.valueTypeMismatch(String(describing: key))
        }
    }
}

typealias JSONPropertyValue = String
/// Provides mapping of enums to json properties
extension RawRepresentable where RawValue == JSONPropertyValue {
    var jsonValue: String {
        return self.rawValue
    }

    var propertyValue: String {
        return String(describing: self)
    }
}
