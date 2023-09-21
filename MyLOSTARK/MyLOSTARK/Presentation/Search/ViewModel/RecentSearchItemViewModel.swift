//
//  RecentSearchItemViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/19.
//

class RecentSearchItemViewModel: Hashable {
    var name: String
    var jobClass: String
    var itemLevel: String
    var isBookmark: Bool
    
    init(name: String, jobClass: String, itemLevel: String, isBookmark: Bool) {
        self.name = name
        self.jobClass = jobClass
        self.itemLevel = itemLevel
        self.isBookmark = isBookmark
    }
    
    convenience init(
        search: RecentCharacterInfo
    ) {
        self.init(
            name: search.name ?? "",
            jobClass: search.jobClass ?? "",
            itemLevel: search.itemLevel ?? "",
            isBookmark: search.isBookmark
        )
    }
    
    static func == (lhs: RecentSearchItemViewModel, rhs: RecentSearchItemViewModel) -> Bool {
        return lhs.name == rhs.name && lhs.isBookmark == rhs.isBookmark
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension RecentSearchItemViewModel {
    func toggle() {
        self.isBookmark.toggle()
    }
    
    func toSearchEntity() -> RecentCharacterInfo {
        return RecentCharacterInfo(name: name, jobClass: jobClass, itemLevel: itemLevel, isBookmark: isBookmark)
    }
    
    func toBookmarkEntity() -> CharacterBookmark {
        return CharacterBookmark(jobClass: jobClass, itemLevel: itemLevel, name: name)
    }
}
