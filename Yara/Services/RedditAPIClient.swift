//
//  RedditAPIClient.swift
//  Yara
//
//  Created by Ryan Grigsby on 3/27/17.
//  Copyright © 2017 Grigs-b. All rights reserved.
//

import Foundation
import UIKit

enum RedditError: Error {
    case invalidURL
    case noData
}

protocol APIClient {
    var data: NetworkAdapter { get set }
}

struct RedditAPIClient: APIClient {

    let host = "api.reddit.com"
    var data: NetworkAdapter

    init() {
        data = NetworkAdapter()
    }
    
}

extension RedditAPIClient: DataAdapter {
    func getListing(_ query: SubredditQuery, completion: @escaping ((Result<ListingContainer, Error>) -> Void)) -> URLSessionDataTask? {

        var components = URLComponents()
        components.host = host
        components.scheme = "https"
        components.path = query.path
        components.queryItems = query.queryItems

        guard let url = components.url else {
            completion(Result.failure(RedditError.invalidURL))
            return nil
        }

        let request = URLRequest(url: url)
        let task = data.request(request) {
            (result: Result<ListingContainer, Error>) in

            completion(result)
        }
        return task
    }

    func getImage(_ url: URL, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        let queue = DispatchQueue(label: "com.yara.imageQueue")
        queue.async {
            if let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                completion(Result.success(image))
            } else {
                completion(.failure(NetworkError.unexpectedData))
            }
        }

    }
}
