//
//  Response.swift
//  HappyFilms
//
//  Created by JinYoung Jang on 11/1/22.
//

import Foundation

enum ErrorResponse: Error {
    case error(String?)
    case empty
}

class Response<T: Decodable> {
    public let statusCode: Int
    public let header: [String: String]
    public let data: T?

    public init(statusCode: Int, header: [String: String], data: T?) {
        self.statusCode = statusCode
        self.header = header
        self.data = data
    }

    public convenience init(response: HTTPURLResponse, data: T?) {
        let rawHeader = response.allHeaderFields
        var header = [String: String]()
        for case let (key, value) as (String, String) in rawHeader {
            header[key] = value
        }
        
        self.init(statusCode: response.statusCode, header: header, data: data)
    }
}
