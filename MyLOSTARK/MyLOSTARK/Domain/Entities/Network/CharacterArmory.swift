//
//  CharacterArmory.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/23.
//

struct CharacterArmory {
    let armoryProfile: ArmoryProfile
    let armoryEquipment: [ArmoryEquipment]?
}

struct ArmoryProfile {
    let characterImage: String?
    let expeditionLevel: Int
    let title: String?
    let stats: [Stats]
    let tendencies: [Tendencies]
    let serverName: String
    let characterName: String
    let characterLevel: Int
    let characterClassName: String
    let itemAvgLevel: String
}

struct Stats {
    let type: String
    let value: String
}

struct Tendencies {
    let type: String
    let point: Int
}

struct ArmoryEquipment {
    let type: String
    let name: String
    let icon: String
    let grade: String
    let tooltip: String
}
