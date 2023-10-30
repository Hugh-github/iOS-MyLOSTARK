//
//  ContentsCalendar.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/14.
//

import Foundation

struct Contents {
    let categoryName: String
    let contentsName: String
    let contentsIcon: String
    let minItemLevel: Int
    let startTimes: [String]?
    let location: String?
    let rewardItems: [RewardItem]?
}

struct RewardItem {
    let name: String
    let icon: String
    let grade: String
    let startTimes: [String]?
}
