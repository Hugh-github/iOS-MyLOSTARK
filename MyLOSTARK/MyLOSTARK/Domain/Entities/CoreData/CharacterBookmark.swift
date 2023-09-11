//
//  CharacterBookmark.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/03.
//

struct CharacterBookmark: Hashable {
    var jobClass: String
    var itemLevel: String
    var name: String
    
    func toRecentSearch() -> RecentCharacterInfo {
        return RecentCharacterInfo(
            name: name,
            jobClass: jobClass,
            itemLevel: itemLevel,
            isBookmark: false
        )
    }
}
