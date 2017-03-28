//
//  Endpoint.swift
//  Yara
//
//  Created by Ryan Grigsby on 3/24/17.
//  Copyright © 2017 Grigs-b. All rights reserved.
//

import Foundation


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol Routable {
    var route: String {get}
}

protocol HTTPRequestBuildable {
    var request: URLRequest {get}
}

enum DevelopmentError: Error {
    case notImplemented
}

enum Endpoint {

    enum Root: String {

        case production = "https://api.reddit.com"
        // when you can, make sure you have another environment to test against!
        //case staging

        func baseURL() -> URL {
            return URL(string: self.rawValue)!
        }
    }
}

extension Dictionary where Key: ExpressibleByStringLiteral, Value: ExpressibleByStringLiteral {
    func queryParams() -> [URLQueryItem] {
        return flatMap { (element) -> URLQueryItem? in
            URLQueryItem(name: String(describing: element.key), value: String(describing: element.value))
        }
    }
}
