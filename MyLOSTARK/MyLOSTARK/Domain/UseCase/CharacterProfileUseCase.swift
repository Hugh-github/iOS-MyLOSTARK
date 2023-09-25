//
//  CharacterProfileUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/23.
//

class CharacterProfileUseCase {
    struct RequestValue {
        var name: String
        var responseValue: ArmoryProfile?
    }
    
    private let repository: DefaultFetchProfileRepository
    var request: RequestValue = RequestValue(name: "") // 수정
    
    init(
        repository: DefaultFetchProfileRepository
    ) {
        self.repository = repository
    }
    
    func execute() async throws {
        if request.name == "" {
            return
        }
        
        self.request.responseValue = try await repository.fetch(request.name)
    }
    
    func fetch() -> ArmoryProfile {
        return request.responseValue!
    }
}
