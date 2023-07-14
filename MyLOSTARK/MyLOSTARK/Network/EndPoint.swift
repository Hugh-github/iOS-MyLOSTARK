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
}

enum Path: String {
    case notice = "/news/notices"
    case event = "/news/events"
    case calendar = "/gamecontents/calendar"
}

struct Parameter {
    let key: String
    let value: String
}

enum HTTPMethod: String {
    case get = "GET"
}

struct Headers {
    let accept: String
    let authorization: String
    
    init(
        accept: String = "application/json",
        authorization: String
    ) {
        self.accept = accept
        self.authorization = "bearer \(authorization)"
    }
}
