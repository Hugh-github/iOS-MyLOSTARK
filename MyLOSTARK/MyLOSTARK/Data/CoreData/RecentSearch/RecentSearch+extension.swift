//
//  Bookmark+extension.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/04.
//

extension RecentSearch {
    var isBookmark: Bool {
        if let data = value(forKey: "isBookmark") as? [Bookmark] {
            return !data.isEmpty
        }
        
        return false
    }
    
    func toDomain() -> RecentCharacterInfo {
        return RecentCharacterInfo(
            name: name!,
            jobClass: jobClass!,
            itemLevel: itemLevel!,
            isBookmark: isBookmark
        )
    }
}
