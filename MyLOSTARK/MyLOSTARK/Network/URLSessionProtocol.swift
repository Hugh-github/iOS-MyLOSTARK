//
//  URLSessionProtocol.swift
//  APIServiceTest
//
//  Created by dhoney96 on 2023/07/18.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }
