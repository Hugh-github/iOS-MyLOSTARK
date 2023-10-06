//
//  InteractiveBookmarkRepository.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/21.
//

protocol InteractiveBookmarkRepository {
    func create(_ character: CharacterBookmark)
    func delete(_ character: CharacterBookmark)
    func hasCharacter(name: String) -> Bool
}
