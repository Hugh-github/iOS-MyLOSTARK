//
//  ViewController.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/14.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

struct ShopNotice: Decodable {
    let title: String
    let date: String
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case date = "Date"
        case link = "Link"
    }
}

struct Event: Decodable, Equatable {
    let title: String
    let thumbnail: String
    let link: String
    let startDate: String
    let endDate: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case thumbnail = "Thumbnail"
        case link = "Link"
        case startDate = "StartDate"
        case endDate = "EndDate"
    }
}

struct Contents: Decodable {
    let categoryName: String
    let contentsName: String
    let contentsIcon: String
    let minItemLevel: Int
    let startTimes: [String]
    let location: String
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

struct RewardItem: Decodable {
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
