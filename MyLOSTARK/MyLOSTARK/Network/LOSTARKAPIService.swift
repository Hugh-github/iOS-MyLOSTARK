//
//  LostArkAPIService.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/17.
//

import Foundation

class LOSTARKAPIService {
    let networkManager = NetworkManager.shared
    let jsonManager = JSONManager.shared
    
    func getEventList() async throws -> [Event] {
        let endPoint = EndPoint(
            path: .event,
            parameter: nil,
            httpMethod: .get,
            headers: .init(authorization: "My Token Key")
        )
        
        guard let request = endPoint.request else { throw ServiceError.fail }
        let data = try await networkManager.execute(request: request)
        let model: [Event] = try jsonManager.decodeListData(data)
        
        return model
    }
    
    func getContents() async throws -> [Contents] {
        let endPoint = EndPoint(
            path: .calendar,
            parameter: nil,
            httpMethod: .get,
            headers: .init(authorization: "My Token Key")
        )
        
        guard let request = endPoint.request else { throw ServiceError.fail }
        let data = try await networkManager.execute(request: request)
        let model: [Contents] = try jsonManager.decodeListData(data)
        
        return model
    }
    
    func getShopNoticeList() async throws -> [ShopNotice] {
        let endPoint = EndPoint(
            path: .notice,
            parameter: nil,
            httpMethod: .get,
            headers: .init(authorization: "My Token Key")
        )
        
        guard let request = endPoint.request else { throw ServiceError.fail }
        let data = try await networkManager.execute(request: request)
        let model: [ShopNotice] = try jsonManager.decodeListData(data)
        
        return model
    }
}

enum ServiceError: Error {
    case fail
}
