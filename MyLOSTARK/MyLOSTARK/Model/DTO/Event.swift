//
//  Event.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/19.
//

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
