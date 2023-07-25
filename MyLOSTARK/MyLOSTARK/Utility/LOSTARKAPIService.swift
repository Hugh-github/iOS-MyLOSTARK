//
//  LostArkAPIService.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/17.
//

import Foundation

class LOSTARKAPIService {
    private let myAPIKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IktYMk40TkRDSTJ5NTA5NWpjTWk5TllqY2lyZyIsImtpZCI6IktYMk40TkRDSTJ5NTA5NWpjTWk5TllqY2lyZyJ9.eyJpc3MiOiJodHRwczovL2x1ZHkuZ2FtZS5vbnN0b3ZlLmNvbSIsImF1ZCI6Imh0dHBzOi8vbHVkeS5nYW1lLm9uc3RvdmUuY29tL3Jlc291cmNlcyIsImNsaWVudF9pZCI6IjEwMDAwMDAwMDAyNzgyMjIifQ.dTzj4THlABCbfUmBdSs02dQBTb2DWXNoFNAsfko6l8v9E99h4VCOe5fn_pRlRwxbLf6d0G0nu1qyib0xL00hvKjvJDRuNJhoGPFOZXYgxec3v_oEt8-J81fnTY-8bDuyaOMcE5d6GVrmQUBvg35BVqJnNePTfcVZBFNchLKampumdtdV6TW_nHUzE8SnB45uFJbrDDsduKstvRjM84LepEx3ohivegyUJMp9QvBrKcF0RM3oll0I5Me5_qZx2Y7V5TTTzzPMWvlTCmN2tjo7OWT5A7dyecbJO43yqq9cA6n0K3Ps3vqH5gennGajY2PAx8XHSDPnrosrbzlHwFoLZw"
    
    private let networkManager: NetworkManager
    private let jsonManager = JSONManager.shared
    
    init(
        networkManager: NetworkManager = NetworkManager.shared
    ) {
        self.networkManager = networkManager
    }
    
    func getEventList() async throws -> [Event] {
        let endPoint = EndPoint(
            path: .event,
            parameter: nil,
            httpMethod: .get,
            headers: .init(authorization: self.myAPIKey)
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
            headers: .init(authorization: self.myAPIKey)
        )
        
        guard let request = endPoint.request else { throw ServiceError.fail }
        let data = try await networkManager.execute(request: request)
        let model: [Contents] = try jsonManager.decodeListData(data).filter{ content in
            content.categoryName == "모험 섬"
        }
        
        return model
    }
    
    func getShopNoticeList() async throws -> [ShopNotice] {
        let endPoint = EndPoint(
            path: .notice,
            parameter: .init(key: "type", value: "상점"),
            httpMethod: .get,
            headers: .init(authorization: self.myAPIKey)
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
