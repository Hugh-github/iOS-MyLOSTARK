//
//  CharacterProfileItemViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/10/04.
//

import Foundation

struct CharacterProfileViewModel: Hashable {
    let characterImage: String?
    let serverName: String
    let characterName: String
    let characterLevel: Int
    let characterClassName: String
    let itemAvgLevel: String
    
    init(profile: CharacterArmory) {
        self.characterImage = profile.armoryProfile.characterImage
        self.serverName = profile.armoryProfile.serverName
        self.characterName = profile.armoryProfile.characterName
        self.characterLevel = profile.armoryProfile.characterLevel
        self.characterClassName = profile.armoryProfile.characterClassName
        self.itemAvgLevel = profile.armoryProfile.itemAvgLevel
    }
}

struct CharacterStatsViewModel: Hashable {
    let type: String
    let value: String
    
    init(stat: Stats) {
        self.type = stat.type
        self.value = stat.value
    }
}

struct CharacterTendencyViewModel: Hashable {
    let type: String
    let point: Int
    
    init(tendency: Tendencies) {
        self.type = tendency.type
        self.point = tendency.point
    }
}

struct EquipmentItemViewModel: Hashable {
    let name: String
    let icon: String
    
    init(_ equipment: ArmoryEquipment) {
        self.name = equipment.name
        self.icon = equipment.icon
    }
}

struct AccessoryItemViewModel: Hashable {
    let id = UUID()
    let name: String
    let icon: String
    
    init(_ equipment: ArmoryEquipment) {
        self.name = equipment.name
        self.icon = equipment.icon
    }
}
