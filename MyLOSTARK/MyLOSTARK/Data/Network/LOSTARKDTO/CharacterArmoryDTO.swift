//
//  CharacterArmoryDTO.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/22.
//

import Foundation

struct CharacterArmoryDTO: Decodable {
    let armoryProfile: ArmoryProfileDTO
    let armoryEquipment: [ArmoryEquipmentDTO]?
    
    enum CodingKeys: String, CodingKey {
        case armoryProfile = "ArmoryProfile"
        case armoryEquipment = "ArmoryEquipment"
    }
    
    func toDomain() -> CharacterArmory {
        return CharacterArmory(
            armoryProfile: armoryProfile.toDomain(),
            armoryEquipment: armoryEquipment?.map{ $0.toDomain() }
        )
    }
}

struct ArmoryProfileDTO: Decodable {
    let characterImage: String?
    let expeditionLevel: Int
    let title: String?
    let stats: [StatsDTO]
    let tendencies: [TendenciesDTO]
    let serverName: String
    let characterName: String
    let characterLevel: Int
    let characterClassName: String
    let itemAvgLevel: String
    
    enum CodingKeys: String, CodingKey {
        case characterImage = "CharacterImage"
        case expeditionLevel = "ExpeditionLevel"
        case title = "Title"
        case stats = "Stats"
        case tendencies = "Tendencies"
        case serverName = "ServerName"
        case characterName = "CharacterName"
        case characterLevel = "CharacterLevel"
        case characterClassName = "CharacterClassName"
        case itemAvgLevel = "ItemAvgLevel"
    }
    
    func toDomain() -> ArmoryProfile {
        return ArmoryProfile(
            characterImage: characterImage,
            expeditionLevel: expeditionLevel,
            title: title,
            stats: stats.map { $0.toDomain() },
            tendencies: tendencies.map { $0.toDomain() },
            serverName: serverName,
            characterName: characterName,
            characterLevel: characterLevel,
            characterClassName: characterClassName,
            itemAvgLevel: itemAvgLevel
        )
    }
}

struct StatsDTO: Decodable {
    let type: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case value = "Value"
    }
    
    func toDomain() -> Stats {
        return Stats(type: type, value: value)
    }
}

struct TendenciesDTO: Decodable {
    let type: String
    let point: Int
    
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case point = "Point"
    }
    
    func toDomain() -> Tendencies {
        return Tendencies(type: type, point: point)
    }
}

struct ArmoryEquipmentDTO: Decodable {
    let type: String
    let name: String
    let icon: String
    let grade: String
    let tooltip: String
    
    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case name = "Name"
        case icon = "Icon"
        case grade = "Grade"
        case tooltip = "Tooltip"
    }
    
    func toDomain() -> ArmoryEquipment {
        return ArmoryEquipment(
            type: type,
            name: name,
            icon: icon,
            grade: grade,
            tooltip: tooltip
        )
    }
}
