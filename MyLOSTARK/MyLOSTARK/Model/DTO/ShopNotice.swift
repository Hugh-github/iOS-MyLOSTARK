//
//  ShopNoti.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/14.
//

protocol WebConnectable {
    var link: String { get }
}

struct ShopNotice: Decodable, Hashable, WebConnectable {
    let title: String
    let date: String
    var link: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case date = "Date"
        case link = "Link"
    }
}
