//
//  DatabaseUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/18.
//

class CharacterInfoCoreDataUseCase: CommonCoreDataUseCase {
    var bookmarkRepository = BookmarkRepository()
    var searchRepository = RecentSearchRepository()
    
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
