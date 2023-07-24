//
//  ShopNoti.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/14.
//

struct ShopNotice: Decodable, Hashable {
    let title: String
    let date: String
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case date = "Date"
        case link = "Link"
    }
}
