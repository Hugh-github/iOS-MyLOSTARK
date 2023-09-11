//
//  DatabaseUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/18.
//

import Foundation

class BookmarkUseCase {
    private let bookmarkStorage = CoreDataBookmarkStorage()
    private let recentSearchStorage = CoreDataRecentSearchStorage()
    
    func execute() -> [CharacterBookmark] {
        do {
            return  try bookmarkStorage.fetchBookmark()
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func unRegistBookmark(_ character: CharacterBookmark) {
        self.bookmarkStorage.deleteBookmark(character.name)
        self.recentSearchStorage.updateResultSearch(character.toRecentSearch())
    }
}

class RecentSearchUseCase {
    private let recentSearchStorage = CoreDataRecentSearchStorage()
    private let bookmarkStorage = CoreDataBookmarkStorage() // BookmarkStorage의 모든 기능이 필요하지 않기 때문에 추상화를 하는 것은 어떨까?
    
    func execute() -> [RecentCharacterInfo] {
        do {
            return try recentSearchStorage.fetchRecentCharaterList()
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func appendSearch(_ character: RecentCharacterInfo) {
        // MARK: 임시로 사용하는 테스트 코드 나중에 변경 필요
        self.recentSearchStorage.createRecentSearch(character)
    }
    
    func unRegistBookmark(_ character: RecentCharacterInfo) {
        let bookmark = character.toBookmark()
        self.bookmarkStorage.deleteBookmark(bookmark.name)
    }
    
    func registBookmark(_ character: RecentCharacterInfo) {
        let bookmark = character.toBookmark()
        self.bookmarkStorage.createBookmark(bookmark)
    }
    
    func updateIsBookmark(_ search: RecentCharacterInfo) {
        self.recentSearchStorage.updateResultSearch(search)
    }
    
    func deleteRecentSearch(_ search: RecentCharacterInfo) {
        guard let name = search.name else { return }
        
        self.recentSearchStorage.deleteRecentSearch(name)
    }
    
    func deleteAllSearchList() {
        self.recentSearchStorage.deleteAllSearch()
    }
}
