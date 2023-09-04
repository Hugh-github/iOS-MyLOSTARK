//
//  ContentsCalendar.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/14.
//

import Foundation

struct Contents: Decodable, Hashable {
    let categoryName: String
    let contentsName: String
    let contentsIcon: String
    let minItemLevel: Int
    let startTimes: [String]
    let location: String?
    let rewardItems: [RewardItem]
    
    enum CodingKeys: String, CodingKey {
        case categoryName = "CategoryName"
        case contentsName = "ContentsName"
        case contentsIcon = "ContentsIcon"
        case minItemLevel = "MinItemLevel"
        case startTimes = "StartTimes"
        case location = "Location"
        case rewardItems = "RewardItems"
    }
}

struct RewardItem: Decodable, Hashable {
    let id = UUID()
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
}
