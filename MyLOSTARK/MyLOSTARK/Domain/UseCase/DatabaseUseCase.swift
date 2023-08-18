//
//  DatabaseUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/18.
//

import Foundation

class BookmarkUseCase {
    private let manager = CoreDataManager()
    
    func execute() -> [CharacterBookmark] {
        return manager.fetchCoreData()
    }
}
