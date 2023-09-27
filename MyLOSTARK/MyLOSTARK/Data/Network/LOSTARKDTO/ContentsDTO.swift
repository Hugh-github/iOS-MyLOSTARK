//
//  ContentsDTO.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/22.
//

import Foundation

struct ContentsDTO: Decodable {
    let categoryName: String
    let contentsName: String
    let contentsIcon: String
    let minItemLevel: Int
    let startTimes: [String]?
    let location: String?
    let rewardItems: [RewardItemDTO]
    
    enum CodingKeys: String, CodingKey {
        case categoryName = "CategoryName"
        case contentsName = "ContentsName"
        case contentsIcon = "ContentsIcon"
        case minItemLevel = "MinItemLevel"
        case startTimes = "StartTimes"
        case location = "Location"
        case rewardItems = "RewardItems"
    }
    
    func toDomain() -> Contents {
        let items = self.rewardItems.map { dto in
            return dto.toDomain()
        }
        
        return Contents(
            categoryName: categoryName,
            contentsName: contentsName,
            contentsIcon: contentsIcon,
            minItemLevel: minItemLevel,
            startTimes: startTimes,
            location: location,
            rewardItems: items
        )
    }
}

struct RewardItemDTO: Decodable {
    let name: String
    let icon: String
    let grade: String
    let startTimes: [String]?
    
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case icon = "Icon"
        case grade = "Grade"
        case startTimes = "StartTimes"
    }
    
    func toDomain() -> RewardItem {
        return RewardItem(
            name: name,
            icon: icon,
            grade: grade,
            startTimes: startTimes
        )
    }
}
