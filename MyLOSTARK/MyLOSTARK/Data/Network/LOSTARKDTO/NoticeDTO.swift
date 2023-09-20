//
//  NoticeDTO.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/20.
//

import Foundation

struct NoticeDTO: Decodable {
    let title: String
    var link: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case link = "Link"
        case type = "Type"
    }
    
    func toDomain() -> Notice {
        return Notice(title: title, link: link, type: type)
    }
}
