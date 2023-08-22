//
//  CharacterProfile.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/22.
//

import Foundation

struct CharacterProfileDTO: Decodable {
    let armoryProfile: ArmoryProfileDTO
    let armoryEquipment: ArmoryEquipmentDTO
    let armoryEngraving: ArmoryEngravingDTO
    let armoryCard: ArmoryCardDTO
    
    enum CodingKeys: String, CodingKey {
        case armoryProfile = "ArmoryProfile"
        case armoryEquipment = "ArmoryEquipment"
        case armoryEngraving = "ArmoryEngraving"
        case armoryCard = "ArmoryCard"
    }
}

struct ArmoryProfileDTO: Decodable {
    let characterImage: String
    let expeditionLevel: Int
    let title: String?
    let guildName: String?
    let usingSkillPoint: Int
    let totalSkillPoint: Int
    let stats: [StatDTO]
    let tendencies: [TendencieDTO]
    let serverName: String
    let characterName: String
    let characterLevel: Int
    let characterClassName: String
    let itemAvgLevel: String
    
    enum CodingKeys: String, CodingKey {
        case characterImage = "CharacterImage"
        case expeditionLevel = "ExpeditionLevel"
        case title = "Title"
        case guildName = "GuildName"
        case usingSkillPoint = "UsingSkillPoint"
        case totalSkillPoint = "TotalSkillPoint"
        case stats = "Stats"
        case tendencies = "Tendencies"
        case serverName = "ServerName"
        case characterName = "CharacterName"
        case characterLevel = "CharacterLevel"
        case characterClassName = "CharacterClassName"
        case itemAvgLevel = "ItemAvgLevel"
    }
}

struct StatDTO: Decodable {
    let type: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case value = "Value"
    }
}

struct TendencieDTO: Decodable {
    let type: String
    let point: Int
    
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case point = "Point"
    }
}

struct ArmoryEquipmentDTO: Decodable {
    let type: String
    let name: String
    let icon: String
    let grade: String
    let tooltip: String // 정규식을 통한 로직이 필요하다.
    
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case name = "Name"
        case icon = "Icon"
        case grade = "Grade"
        case tooltip = "Tooltip"
    }
}

struct ArmoryEngravingDTO: Decodable {
    let engravings: [EngravingDTO]
    let effects: [EffectDTO]
    
    enum CodingKeys: String, CodingKey {
        case engravings = "Engravings"
        case effects = "Effects"
    }
}

struct EngravingDTO: Decodable {
    let slot: Int
    let name: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case slot = "Slot"
        case name = "Name"
        case icon = "Icon"
    }
}

struct EffectDTO: Decodable {
    let name: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case description = "Description"
    }
}

struct ArmoryCardDTO: Decodable {
    let cards: [CardDTO]
    
    enum CodingKeys: String, CodingKey {
        case cards = "Cards"
    }
}

struct CardDTO: Decodable {
    let slot: Int
    let name: String
    let icon: String
    let awakeCount: Int
    
    enum CodingKeys: String, CodingKey {
        case slot = "Slot"
        case name = "Name"
        case icon = "Icon"
        case awakeCount = "AwakeCount"
    }
}
