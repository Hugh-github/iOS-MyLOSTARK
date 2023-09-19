//
//  RecentCharacterInfo.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/04.
//

struct RecentCharacterInfo {
    let name: String?
    let jobClass: String?
    let itemLevel: String?
    let isBookmark: Bool
    
    // MARK: 해당 함수는 순수함수이다. -> SideEffect가 발생하지 않는다.
    func toBookmark() -> CharacterBookmark {
        return CharacterBookmark(jobClass: jobClass!, itemLevel: itemLevel!, name: name!)
    }
}
