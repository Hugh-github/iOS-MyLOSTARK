//
//  NetworkManager.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/15.
//

import Foundation

class NetworkManager {    
    private let urlSession: URLSessionProtocol
    
    init(
        urlSession: URLSessionProtocol
    ) {
        self.urlSession = urlSession
    }
    
    func execute(request: URLRequest) async throws  -> Data {
        let (data, response) = try await urlSession.data(for: request)
        try handleHttpError(from: response)
        
        let nsData = data as NSData
        if nsData.length <= 4  {
            throw NetworkError.emptyData
        }
        
        return data
    }
    
    private func handleHttpError(from response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        
        switch httpResponse.statusCode {
        case 100...199:
            return
        case 200...299:
            return
        case 300...399:
            throw NetworkError.redirectionError
        case 400...499:
            throw NetworkError.clientError
        default:
            throw NetworkError.serverError
        }
        
    }
}

enum NetworkError: Error {
    case unknownError
    case redirectionError
    case clientError
    case serverError
    case emptyData
}
