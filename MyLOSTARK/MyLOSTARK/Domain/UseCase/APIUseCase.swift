//
//  APIUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/18.
//

import Foundation

class ContentUseCase {
    private let apiService = LOSTARKAPIService.shared
    
    func execute() async throws -> [Contents] {
        return try await apiService.getContents()
    }
}

class EventUseCase {
    private let apiService = LOSTARKAPIService.shared
    
    func execute() async throws -> [Event] {
        return try await apiService.getEventList()
    }
}

class NoticeUseCase {
    private let apiService = LOSTARKAPIService.shared
    
    func execute(_ type: String? = nil) async throws -> [Notice] {
        let notices = try await apiService.getNoticeList()
        
        if type == nil {
            return Array(notices.prefix(5))
        }
        
        return notices
    }
}
