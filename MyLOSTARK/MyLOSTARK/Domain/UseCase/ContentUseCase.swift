//
//  ContentUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/22.
//

class ContentUseCase {
    private let dateFormatter = DateFormatterManager.shared
    private let repository: any DefaultFetchAPIDataRepository // fetch를 통해 가져오는 타입이 [Any]이다.
    
    private var categoryKeyword: String {
        return "모험 섬"
    }
    
    private var amStartTime: String {
        return "\(dateFormatter.getTodyDate())T11:00:00"
    }
    
    private var pmStartTime: String {
        return "\(dateFormatter.getTodyDate())T19:00:00"
    }
    
    init(repository: any DefaultFetchAPIDataRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [Contents] {
        guard let entity = try await self.repository.fetch() as? [Contents] else { return [] }
        
        return entity.filter { content in
            if content.categoryName == categoryKeyword {
                guard let startTimes = content.startTimes else { return false }
                
                if startTimes.contains(amStartTime) || startTimes.contains(pmStartTime) {
                    return true
                }
            }
            
            return false
        }
    }
}
