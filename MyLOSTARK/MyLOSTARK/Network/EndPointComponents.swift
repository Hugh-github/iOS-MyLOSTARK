//
//  EndPointComponents.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/17.
//

enum Path {
    case notice
    case event
    case calendar
    
    var list: [String] {
        switch self {
        case .notice:
            return ["news", "notices"]
        case .event:
            return ["news", "events"]
        case .calendar:
            return ["gamecontents", "calendar"]
        }
    }
}

struct Parameter {
    let key: String
    let value: String
}

enum HTTPMethod: String {
    case get = "GET"
}

struct Headers { // 효율적으로 바꿀 필요가 있다.
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
