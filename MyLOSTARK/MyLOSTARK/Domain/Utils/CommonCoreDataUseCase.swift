//
//  CommonCoreDataUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/16.
//

protocol CommonCoreDataUseCase {
    var bookmarkRepository: BookmarkRepository { get }
    var searchRepository: RecentSearchRepository { get }
    
    func unRegistBookmark(_ character: CharacterBookmark)
    func updateRecentSearch(_ search: RecentCharacterInfo)
}

extension CommonCoreDataUseCase {
    func unRegistBookmark(_ character: CharacterBookmark) {
        self.bookmarkRepository.delete(character)
        self.updateRecentSearch(character.toRecentSearch())
    }
}
