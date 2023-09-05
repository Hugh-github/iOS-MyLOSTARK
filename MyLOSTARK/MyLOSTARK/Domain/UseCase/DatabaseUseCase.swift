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
}

class RecentSearchUseCase {
    private let storage = CoreDataRecentSearchStorage()
    
    func execute() -> [RecentCharacterInfo] {
        do {
            return try storage.fetchRecentCharaterList()
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
}
