//
//  BookmarkRepository.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/13.
//

class BookmarkRepository: DefaultCoreDataRepository, InteractiveBookmarkRepository {
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
