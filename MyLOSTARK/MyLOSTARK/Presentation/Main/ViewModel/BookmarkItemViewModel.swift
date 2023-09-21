//
//  BookmarkItemViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/21.
//

struct BookmarkItemViewModel: Hashable {
    let name: String
    let jobClass: String
    let itemLevel: String
    
    init(
        name: String = "",
        jobClass: String = "",
        itemLevel: String = ""
    ) {
        self.name = name
        self.jobClass = jobClass
        self.itemLevel = itemLevel
    }
    
    init(bookmark: CharacterBookmark) {
        self.init(name: bookmark.name, jobClass: bookmark.jobClass, itemLevel: bookmark.itemLevel)
    }
    
    func toSearchEntity() -> RecentCharacterInfo {
        return RecentCharacterInfo(name: name, jobClass: jobClass, itemLevel: itemLevel, isBookmark: false)
    }
    
    func toBookmarkEntity() -> CharacterBookmark {
        return CharacterBookmark(jobClass: jobClass, itemLevel: itemLevel, name: name)
    }
}
