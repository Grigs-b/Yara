//
//  Listing.swift
//  Yara
//
//  Created by Ryan Grigsby on 3/28/17.
//  Copyright © 2017 Grigs-b. All rights reserved.
//

import Foundation

enum ModelError: Error {
    case unsupportedType
}

struct ListingContainer: Model {
    var after: String?
    var before: String?
    var children: [Listing]
    var modhash: String?


    enum Key: JSONPropertyValue {
        case after
        case before
        case children
        case modhash
    }

    init(dictionary: JSONDictionary) throws {
        guard let kindString = dictionary["kind"] as? String,
            Kind(rawValue: kindString) == .listing,
            let data = dictionary["data"] as? JSONDictionary,
            let childrenArray = data["children"] as? [JSONDictionary] else {
                throw SerializationError.invalidData
        }

        after = try? data.decode(Key.after.jsonValue)
        before = try? data.decode(Key.before.jsonValue)
        modhash = try? data.decode(Key.modhash.jsonValue)
        children = try Listing.make(array: childrenArray)
    }

    func toJSON() -> JSONDictionary {
        return JSONDictionary()
    }
}

struct Listing: Model {
    var kind: Kind
    var data: Model

    init(dictionary: JSONDictionary) throws {
        guard let kindString = dictionary["kind"] as? String,
            let kind = Kind(rawValue: kindString),
            let data = dictionary["data"] as? JSONDictionary else {
                throw SerializationError.invalidData
        }
        self.kind = kind

        switch kind {
        case .link:
            self.data = try Link(dictionary: data)
        default:
            // Learn on your own, go support all the types
            throw ModelError.unsupportedType
        }
    }

    func toJSON() -> JSONDictionary {
        return JSONDictionary()
    }
}
