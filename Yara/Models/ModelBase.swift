//
//  ModelBase.swift
//  Yara
//
//  Created by Ryan Grigsby on 3/27/17.
//  Copyright © 2017 Grigs-b. All rights reserved.
//

import Foundation

protocol Model: Encodable, Decodable {
    
}

enum Kind: String {
    case more = "more"
    case listing = "Listing"
    case comment = "t1"
    case account = "t2"
    case link = "t3"
    case message = "t4"
    case subreddit = "t5"
    case award = "t6"
    case promoCampaign = "t8"
}
