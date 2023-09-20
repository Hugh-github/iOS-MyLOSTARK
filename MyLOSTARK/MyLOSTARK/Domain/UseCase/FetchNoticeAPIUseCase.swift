//
//  FetchNoticeAPIUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/20.
//

enum NoticeType {
    case all
    case update
    case check
    case shop
    
    var parameter: String? {
        switch self {
        case .all:
            return nil
        case .check:
            return "점검"
        case .update:
            return "공지"
        case .shop:
            return "상점"
        }
    }
}

class FetchNoticeAPIUseCase {
    private let repository: DefaultNoticeRepository
    private var maxCount = 5
    
    init(repository: DefaultNoticeRepository) {
        self.repository = repository
    }
    
    func execute(_ type: NoticeType) async throws -> [Notice] {
        if type == .all {
            return try await Array(self.repository.fetch(type).prefix(maxCount))
        }
        
        return try await self.repository.fetch(type)
    }
}
