//
//  Bookmark+extension.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/04.
//

extension Bookmark {
    func toDomain() -> CharacterBookmark {
        return CharacterBookmark(
            jobClass: jobClass!,
            itemLevel: itemLevel!,
            name: name!
        )
    }
}
