//
//  NoticeRepository.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/20.
//

class NoticeRepository: DefaultNoticeRepository { // Notice는 Generic 하게 만들기 힘들다.
    private var cacheRepository = [NoticeType: [NoticeDTO]]()
    private let apiService = LOSTARKAPIService()
    
    func fetch(_ type: NoticeType) async throws -> [Notice] {
        if let data = cacheRepository[type] {
            return data.map { dto in
                dto.toDomain()
            }
        }
        
        let data = try await self.apiService.getNoticeList(type.parameter) // Data 타입으로 변경
        self.cacheRepository.updateValue(data, forKey: type)
        
        return data.map { $0.toDomain() }
    }
}
