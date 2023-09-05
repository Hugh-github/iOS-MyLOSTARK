//
//  RecentCharacterInfo.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/04.
//

struct RecentCharacterInfo: Hashable {
    // MARK: 현재 검색어를 저장하는 과정에서 문제가 발생(고유한 식별값이 없어서 DataSource를 사용하는데 문제가 발생)
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
