//
//  EndPoint.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/14.
//

import Foundation

struct EndPoint {
    private let baseURL: String
    private let path: Path
    private let parameter: Parameter? // 앱 구현에 필요한 Parameter는 하나만 사용
    private let httpMethod: HTTPMethod
    private let headers: Headers
    
    init(
        baseURL: String = "https://developer-lostark.game.onstove.com",
        path: Path,
        parameter: Parameter?,
        httpMethod: HTTPMethod,
        headers: Headers
    ) {
        self.baseURL = baseURL
        self.path = path
        self.parameter = parameter
        self.httpMethod = httpMethod
        self.headers = headers
    }
    
    var request: URLRequest? {
        return makeRequest()
    }
    
    private func makeRequest() -> URLRequest? {
        guard let url = self.makeURL() else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod.rawValue
        request.setValue(headers.accept, forHTTPHeaderField: "accept")
        request.setValue(headers.authorization, forHTTPHeaderField: "authorization")
        
        if let queryItem = self.makeQueryItem() {
            request.url?.append(queryItems: [queryItem])
        }
        
        return request
    }
    
    private func makeURL() -> URL? {
        var url = URL(string: baseURL)
        
        self.path.list.forEach { path in
            url?.appendPathComponent(path)
        }
        
        return url
    }
    
    private func makeQueryItem() -> URLQueryItem? {
        guard let parameter = self.parameter else { return nil }
        
        return URLQueryItem(name: parameter.key, value: parameter.value)
    }
}
