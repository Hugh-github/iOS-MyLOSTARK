//
//  ProfileViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/27.
//

import Foundation

protocol ProfileViewModelOUTPUT {
    var profile: Observable<CharacterProfileViewModel?> { get }
    var isBookmark: Observable<Bool> { get }
    var stats: Observable<[CharacterStatsViewModel]> { get }
    var tendencies: Observable<[CharacterTendencyViewModel]> { get }
    var equipmentList: Observable<[EquipmentItemViewModel]> { get }
    var accessoryList: Observable<[AccessoryItemViewModel]> { get }
}

class ProfileViewModel: ProfileViewModelOUTPUT {
    enum Action {
        case viewDidLoad
        case didTabBackButton
        case didTabBookmarkButton
    }
    
    private let profileUseCase: CharacterProfileUseCase
    private let interactionUseCase: InterActionCoreDataUseCase
    private let searchUseCase: DefaultSearchUseCase
    
    var profile: Observable<CharacterProfileViewModel?> = .init(nil)
    var isBookmark: Observable<Bool> = .init(false)
    var stats: Observable<[CharacterStatsViewModel]> = .init([])
    var tendencies: Observable<[CharacterTendencyViewModel]> = .init([])
    var equipmentList: Observable<[EquipmentItemViewModel]> = .init([])
    var accessoryList: Observable<[AccessoryItemViewModel]> = .init([])
    
    init(
        profileUseCase: CharacterProfileUseCase,
        interactionUseCase: InterActionCoreDataUseCase,
        searchUseCase: DefaultSearchUseCase
    ) {
        self.profileUseCase = profileUseCase
        self.interactionUseCase = interactionUseCase
        self.searchUseCase = searchUseCase
    }
    
    func execute(_ action: Action) {
        switch action {
        case .viewDidLoad:
            let entity = self.profileUseCase.fetch()
            
            self.profile.value = CharacterProfileViewModel(profile: entity)
            self.stats.value = entity.armoryProfile.stats.map(CharacterStatsViewModel.init)
            self.tendencies.value = entity.armoryProfile.tendencies.map(CharacterTendencyViewModel.init)
            
            entity.armoryEquipment?.forEach { equipment in
                if equipments.contains(equipment.type) {
                    equipmentList.value.append(EquipmentItemViewModel(equipment))
                } else if accessories.contains(equipment.type) {
                    accessoryList.value.append(AccessoryItemViewModel(equipment))
                }
            }
            
            self.isBookmark.value = interactionUseCase.isBookmark(name: entity.armoryProfile.characterName)
        case .didTabBackButton:
            guard let profile = self.profile.value else { return }
            self.searchUseCase.create(createQuery(profile))
            
            if isBookmark.value {
                self.interactionUseCase.regist(createBookmark(profile))
            } else {
                self.interactionUseCase.unregist(createBookmark(profile))
            }
            
        case .didTabBookmarkButton:
            self.isBookmark.value.toggle()
        }
    }
}

extension ProfileViewModel {
    private func createBookmark(_ profile: CharacterProfileViewModel) -> CharacterBookmark {
        return CharacterBookmark(
            jobClass: profile.characterClassName,
            itemLevel: profile.itemAvgLevel,
            name: profile.characterName
        )
    }
    
    private func createQuery(_ profile: CharacterProfileViewModel) -> RecentCharacterInfo {
        return RecentCharacterInfo(
            name: profile.characterName,
            jobClass: profile.characterClassName,
            itemLevel: profile.itemAvgLevel,
            isBookmark: isBookmark.value
        )
    }
}

fileprivate let accessories = ["목걸이", "귀걸이", "반지", "어빌리티 스톤", "팔찌"]
fileprivate let equipments = ["투구", "어꺠", "상의", "하의", "장갑", "무기"]
