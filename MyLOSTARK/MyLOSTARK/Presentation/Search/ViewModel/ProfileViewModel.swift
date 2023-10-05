//
//  ProfileViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/27.
//

import Foundation

protocol ProfileViewModelOUTPUT {
    var profile: Observable<CharacterProfileViewModel?> { get }
    var stats: Observable<[CharacterStatsViewModel]> { get }
    var tendencies: Observable<[CharacterTendencyViewModel]> { get }
    var equipmentList: Observable<[EquipmentItemViewModel]> { get }
    var accessoryList: Observable<[AccessoryItemViewModel]> { get }
}

class ProfileViewModel: ProfileViewModelOUTPUT {
    enum Action {
        case viewDidLoad
        case didTabBackButton
    }
    
    private let profileUseCase: CharacterProfileUseCase
//    private let interactionUseCase = InterActionCoreDataUseCase()
    private let interactionUseCase: InterActionCoreDataUseCase
    
    var profile: Observable<CharacterProfileViewModel?> = .init(nil)
    var stats: Observable<[CharacterStatsViewModel]> = .init([])
    var tendencies: Observable<[CharacterTendencyViewModel]> = .init([])
    var equipmentList: Observable<[EquipmentItemViewModel]> = .init([])
    var accessoryList: Observable<[AccessoryItemViewModel]> = .init([])
    
    init(
        profileUseCase: CharacterProfileUseCase,
        interactionUseCase: InterActionCoreDataUseCase
    ) {
        self.profileUseCase = profileUseCase
        self.interactionUseCase = interactionUseCase
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
        }
    }
}

fileprivate let accessories = ["목걸이", "귀걸이", "반지", "어빌리티 스톤", "팔찌"]
fileprivate let equipments = ["투구", "어꺠", "상의", "하의", "장갑", "무기"]
