//
//  ShopNoti.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/14.
//

struct Notice: Decodable, Hashable, WebConnectable {
    let title: String
    var link: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case link = "Link"
        case type = "Type"
    }
}
