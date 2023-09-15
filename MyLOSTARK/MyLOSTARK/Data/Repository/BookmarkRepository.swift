//
//  BookmarkRepository.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/13.
//

import Foundation

class BookmarkRepository: DefualtRepository {
    typealias T = CharacterBookmark
    
    private let bookmarkStorage = CoreDataBookmarkStorage()

    func fetch() async -> [CharacterBookmark] {
        var bookmarkList = [CharacterBookmark]()
        
        do {
            let list = try await bookmarkStorage.fetchBookmark()
            list.forEach { bookmark in
                bookmarkList.append(bookmark.toDomain())
            }
        } catch {
            bookmarkStorage.rollBack()
        }
        
        return bookmarkList
    }
    
    func create(_ character: CharacterBookmark) {
        self.bookmarkStorage.createBookmark(character)
    }
    
    func delete(_ character: CharacterBookmark) {
        self.bookmarkStorage.deleteBookmark(character.name)
    }
}

class RecentSearchRepository: DefualtRepository {
    typealias T = RecentCharacterInfo
    
    private let recentSearchStorage = CoreDataRecentSearchStorage()
    
    func fetch() async -> [RecentCharacterInfo] {
        var searchList = [RecentCharacterInfo]()
        
        do {
            let list = try await recentSearchStorage.fetchRecentSearch()
            list.forEach { search in
                searchList.append(search.toDomain())
            }
        } catch {
            recentSearchStorage.rollBack()
        }
        
        return searchList
    }
    
    func create(_ search: RecentCharacterInfo) {
        self.recentSearchStorage.createRecentSearch(search)
    }
    
    func delete(_ search: RecentCharacterInfo) {
        guard let name = search.name else { return }
        
        self.recentSearchStorage.deleteRecentSearch(name)
    }
    
    func deleteAll() {
        self.recentSearchStorage.deleteAllSearch()
    }
    
    func update(_ search: RecentCharacterInfo) {
        self.recentSearchStorage.updateResultSearch(search)
    }
}
