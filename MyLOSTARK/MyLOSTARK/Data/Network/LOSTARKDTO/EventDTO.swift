//
//  EventDTO.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/23.
//

import Foundation

struct EventDTO: Decodable {
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
    
    func toDomain() -> Event {
        return Event(title: title, thumbnail: thumbnail, link: link, startDate: startDate, endDate: endDate)
    }
}
