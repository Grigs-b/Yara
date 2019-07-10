//
//  NetworkAdapter.swift
//  Yara
//
//  Created by Ryan Grigsby on 3/24/17.
//  Copyright © 2017 Grigs-b. All rights reserved.
//

import Foundation

enum HTTPStatusCode: Int {
    case success = 200
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case serverError = 500
    case serviceUnavailable = 503
}

enum NetworkError: Error {
    case networkError(statusCode: HTTPStatusCode, error: Error?)
    case unexpectedData
    case noConnection
    case cancelled
    case other(error: Error)
    case unknown
}

class NetworkAdapter: NSObject, URLSessionDelegate {
    typealias ConfigurationHeaders = [String:String]
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
        ]
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    var logger: Logger?

    init(logger: Logger? = nil) {
        // definitely not final
        self.logger = logger
    }

    func request<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? {
        let task = self.request(request) { (result: Result<JSONDictionary, Error>) in
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(let json):
                do {
                    let response = try T(dictionary: json)
                    completion(Result.success(response))
                } catch {
                    completion(Result.failure(error))
                }
            }
        }
        return task
    }

    func request(_ request: URLRequest, completion: @escaping (Result<JSONDictionary, Error>) -> Void) -> URLSessionDataTask? {
        guard let url = request.url else {
            completion(Result.failure(NetworkError.unexpectedData))
            return nil
        }

        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data, error == nil else {
                completion(Result.failure(error ?? NetworkError.unknown))
                return
            }

            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDictionary
                completion(Result.success(jsonObject))
            } catch {
                completion(Result.failure(error))
            }
        }
        task.resume()
        return task
    }


    func requestArray<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<[T], Error>) -> Void) -> URLSessionDataTask? {
        let task = self.requestArray(request) { (result: Result<JSONArray, Error>) in
            switch result {
            case .failure(let error):
                completion(Result.failure(error))
            case .success(let jsonArray):
                do {
                    var response: [T] = []
                    for json in jsonArray {
                        let object = try T(dictionary: json as! JSONDictionary)
                        response.append(object)
                    }

                    completion(Result.success(response))
                } catch {
                    completion(Result.failure(error))
                }
            }
        }
        return task
    }

    func requestArray(_ request: URLRequest, completion: @escaping (Result<JSONArray, Error>) -> Void) -> URLSessionDataTask? {
        guard let url = request.url else {
            completion(Result.failure(NetworkError.unexpectedData))
            return nil
        }

        let task = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data, error == nil else {
                completion(Result.failure(error ?? NetworkError.unknown))
                return
            }
            
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as! JSONArray
                completion(Result.success(jsonArray))
            } catch {
                completion(Result.failure(error))
            }
        }
        task.resume()
        return task
    }
}

