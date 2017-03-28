//
//  Link
//  Yara
//
//  Created by Ryan Grigsby on 3/27/17.
//  Copyright © 2017 Grigs-b. All rights reserved.
//

import Foundation

struct Link: Model {
    var id: String
    var fullname: String
    var title: String
    var author: String
    var thumbnail: String?
    var upvotes: Int
    var downvotes: Int
    var numComments: Int
    var subreddit: String
    var permalink: String
    var url: String

    enum Key: JSONPropertyValue {
        case id
        case fullname = "name"
        case title
        case author
        case thumbnail
        case upvotes = "ups"
        case downvotes = "downs"
        case numComments = "num_comments"
        case subreddit = "subreddit_name_prefixed"
        case permalink
        case url
    }

    init(dictionary: JSONDictionary) throws {
        id = try dictionary.decode(Key.id.jsonValue)
        fullname = try dictionary.decode(Key.fullname.jsonValue)
        title = try dictionary.decode(Key.title.jsonValue)
        author = try dictionary.decode(Key.author.jsonValue)
        thumbnail = try? dictionary.decode(Key.thumbnail.jsonValue)
        upvotes = try dictionary.decode(Key.upvotes.jsonValue)
        downvotes = try dictionary.decode(Key.downvotes.jsonValue)
        numComments = try dictionary.decode(Key.numComments.jsonValue)
        subreddit = try dictionary.decode(Key.subreddit.jsonValue)
        permalink = try dictionary.decode(Key.permalink.jsonValue)
        url = try dictionary.decode(Key.url.jsonValue)

    }

    func toJSON() -> JSONDictionary {
        //TODO
        return JSONDictionary()
    }
}
