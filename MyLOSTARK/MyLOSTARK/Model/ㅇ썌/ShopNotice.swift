//
//  ShopNotice.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/19.
//

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
