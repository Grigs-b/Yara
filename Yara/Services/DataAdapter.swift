//
//  DataAdapter.swift
//  Yara
//
//  Created by Ryan Grigsby on 3/27/17.
//  Copyright © 2017 Grigs-b. All rights reserved.
//

import Foundation
import UIKit

protocol DataAdapter {
    // Browsing
    func getListing(_ query: SubredditQuery, completion: @escaping ((Result<ListingContainer, Error>) -> Void)) -> URLSessionDataTask?

    // Images
    func getImage(_ url: URL, completion: @escaping ((Result<UIImage, Error>) -> Void))
}
