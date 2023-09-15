//
//  DatabaseUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/18.
//

import Foundation

protocol DefaultCoreDataUseCase {
    var bookmarkRepository: BookmarkRepository { get }
    var searchRepository: RecentSearchRepository { get }
    
    func execute() async -> [RecentCharacterInfo]
    func unRegistBookmark(_ character: CharacterBookmark)
    func updateRecentSearch(_ search: RecentCharacterInfo)
}

extension DefaultCoreDataUseCase {
    func unRegistBookmark(_ character: CharacterBookmark) {
        self.bookmarkRepository.delete(character)
        self.updateRecentSearch(character.toRecentSearch())
    }
}

class CharacterInfoCoreDataUseCase: DefaultCoreDataUseCase {
    var bookmarkRepository = BookmarkRepository()
    var searchRepository = RecentSearchRepository()
    
    func execute() async -> [RecentCharacterInfo] {
        return await searchRepository.fetch()
    }
    
    func unRegistBookmark(_ character: RecentCharacterInfo) {
        let bookmark = character.toBookmark()
        self.bookmarkRepository.delete(bookmark)
    }
    
    func registBookmark(_ character: RecentCharacterInfo) {
        let bookmark = character.toBookmark()
        self.bookmarkRepository.create(bookmark)
    }
    
    func deleteRecentSearch(_ search: RecentCharacterInfo) {
        self.searchRepository.delete(search)
    }
    
    func deleteAllSearchList() {
        self.searchRepository.deleteAll()
    }
    
    func appendSearch(_ character: RecentCharacterInfo) {
        self.searchRepository.create(character)
    }
    
    func updateRecentSearch(_ search: RecentCharacterInfo) {
        self.searchRepository.update(search)
    }
}
