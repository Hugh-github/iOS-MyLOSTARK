//
//  RecentCharacterInfo.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/04.
//

struct RecentCharacterInfo: Hashable {
    let name: String?
    let jobClass: String?
    let itemLevel: String?
    var isBookmark: Bool
    
    mutating func toggle() {
        self.isBookmark.toggle()
    }
    
    func toBookmark() -> CharacterBookmark {
        return CharacterBookmark(jobClass: jobClass!, itemLevel: itemLevel!, name: name!)
    }
    
    static func == (lhs: RecentCharacterInfo, rhs: RecentCharacterInfo) -> Bool {
        return lhs.name == rhs.name && lhs.isBookmark == rhs.isBookmark
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
