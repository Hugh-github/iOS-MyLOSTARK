//
//  RecentCharacterInfo.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/04.
//

struct RecentCharacterInfo: Hashable {
    let name: String
    let jobClass: String
    let itemLevel: String
    let isBookmark: Bool
    
    static func == (lhs: RecentCharacterInfo, rhs: RecentCharacterInfo) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
