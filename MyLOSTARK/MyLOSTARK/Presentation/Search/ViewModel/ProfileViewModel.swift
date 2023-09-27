//
//  ProfileViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/27.
//

import Foundation

protocol ProfileViewModelOUTPUT {
    var imageURL: Observable<URL?> { get }
    var profile: Observable<CharacterProfileViewModel?> { get }
    var stats: Observable<[CharacterStatsViewModel]> { get }
    var tendencies: Observable<[CharacterTendencyViewModel]> { get }
}

class ProfileViewModel: ProfileViewModelOUTPUT {
    enum Action {
        case viewDidLoad
    }
    
    private let profileUseCase: CharacterProfileUseCase
    
    // MARK: image와 profile은 계속해서 화면에 유지
    var imageURL: Observable<URL?> = .init(nil)
    var profile: Observable<CharacterProfileViewModel?> = .init(nil)
    var stats: Observable<[CharacterStatsViewModel]> = .init([])
    var tendencies: Observable<[CharacterTendencyViewModel]> = .init([])
    
    init(profileUseCase: CharacterProfileUseCase) {
        self.profileUseCase = profileUseCase
    }
    
    func execute(_ action: Action) {
        switch action {
        case .viewDidLoad:
            let entity = self.profileUseCase.fetch()
            guard let charcterImage = entity.characterImage else { return }
            
            self.imageURL.value = URL(string: charcterImage)
            self.profile.value = CharacterProfileViewModel(profile: entity)
            self.stats.value = entity.stats.map(CharacterStatsViewModel.init)
            self.tendencies.value = entity.tendencies.map(CharacterTendencyViewModel.init)
        }
    }
}

struct CharacterProfileViewModel {
    let expeditionLevel: Int
    let title: String?
    let serverName: String
    let characterName: String
    let characterClassName: String
    let itemAvgLevel: String
    
    init(profile: ArmoryProfile) {
        self.expeditionLevel = profile.expeditionLevel
        self.title = profile.title
        self.serverName = profile.serverName
        self.characterName = profile.characterName
        self.characterClassName = profile.characterClassName
        self.itemAvgLevel = profile.itemAvgLevel
    }
}

struct CharacterStatsViewModel {
    let type: String
    let value: String
    
    init(stat: Stats) {
        self.type = stat.type
        self.value = stat.value
    }
}

struct CharacterTendencyViewModel {
    let type: String
    let point: String
    
    init(tendency: Tendencies) {
        self.point = tendency.type
        self.point = tendency.point
    }
}
