//
//  MockURLSession.swift
//  APIServiceTest
//
//  Created by dhoney96 on 2023/07/18.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    var statusCode: Int
    
    init(
        statusCode: Int
    ) {
        self.statusCode = statusCode
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let url = Bundle.main.url(forResource: "MockContentsData", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let urlResponse = HTTPURLResponse(
            url: url,
            statusCode: self.statusCode,
            httpVersion: nil,
            headerFields: nil
        )! as URLResponse
        
        return (data, urlResponse)
    }
}
