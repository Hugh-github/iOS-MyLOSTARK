//
//  CharacterProfile.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/23.
//

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
