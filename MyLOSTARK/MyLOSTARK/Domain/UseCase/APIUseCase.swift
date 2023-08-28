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
        let contentList  = try await apiService.getContents()
        let todayDate = DateFormatterManager.shared.getTodyDate()
        
        return contentList.filter { content in
            if content.categoryName == "모험 섬" {
                return content.startTimes.contains("\(todayDate)T11:00:00") || content.startTimes.contains("\(todayDate)T19:00:00")
            }
            
            return false
        }
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
        let notices = try await apiService.getNoticeList(type)
        
        if type == nil {
            return Array(notices.prefix(5))
        }
        
        return notices
    }
}
