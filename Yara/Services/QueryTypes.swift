//
//  QueryTypes.swift
//  Yara
//
//  Created by Ryan Grigsby on 3/27/17.
//  Copyright © 2017 Grigs-b. All rights reserved.
//

import Foundation

protocol URLQueryItemQueryable {
    var queryItems: [URLQueryItem] { get }
}

struct SubredditQuery {
    var name: String
    var count: Int = 0
    enum Pagination {
        case before(String)
        case after(String)

        var name: String {
            switch self {
            case .before: return "before"
            case .after: return "after"
            }
        }
        var link: String {
            switch self {
            case .after(let link), .before(let link): return link
            }
        }
    }
    var page: Pagination?

    init() {
        name = ""
    }

    init(_ subreddit: String) {
        name = subreddit
    }

    init(_ subreddit: String, before link: String) {
        name = subreddit
        page = Pagination.before(link)
    }

    init(_ subreddit: String, after link: String) {
        name = subreddit
        page = Pagination.after(link)
    }
}

extension SubredditQuery: URLQueryItemQueryable {
    var queryItems: [URLQueryItem] {

        if let page = page {
            let pageItem = URLQueryItem(name: page.name, value: page.link)
            return [pageItem]
        }

        return []
    }

    var path: String {
        // added sanitization for if we add user ability to type in subreddit to visit, that way if they type it with/without the r/ prefix we can still search
        let sanitized = name.replacingOccurrences(of: "/r/", with: "").replacingOccurrences(of: "r/", with: "")
        return "/r/\(sanitized)/"
    }
}
