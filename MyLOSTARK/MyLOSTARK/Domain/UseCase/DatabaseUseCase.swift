//
//  DatabaseUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/18.
//

import Foundation

class BookmarkUseCase {
    private let storage = CoreDataBookmarkStorage()
    
    func execute() -> [CharacterBookmark] {
        do {
            return  try storage.fetchBookmark()
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    func unRegistBookmark(_ character: CharacterBookmark) {
        self.storage.deleteBookmark(character.name) // 최근 검색어에 반영이 안된다 (refresh가 절실하다.)
    }
}

class RecentSearchUseCase {
    private let recentSearchStorage = CoreDataRecentSearchStorage()
    private let bookmarkStorage = CoreDataBookmarkStorage()
    
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
    
    func deleteRecentSearch(_ search: RecentCharacterInfo) {
        self.recentSearchStorage.deleteRecentSearch(search.name)
    }
    
    func deleteAllSearchList() {
        self.recentSearchStorage.deleteAllSearch()
    }
}
