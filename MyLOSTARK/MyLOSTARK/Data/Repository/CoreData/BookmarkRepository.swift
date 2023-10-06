//
//  BookmarkRepository.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/13.
//

class BookmarkRepository: DefaultCoreDataRepository, InteractiveBookmarkRepository {
    typealias T = CharacterBookmark
    
    static let shared = BookmarkRepository()
    private let bookmarkStorage = CoreDataBookmarkStorage()
    
    private var dictionary = [String: Bookmark]()
    
    func fetch() async -> [CharacterBookmark] {
        var bookmarkList = [CharacterBookmark]()
        
        do {
            let list = try await bookmarkStorage.fetchBookmark()
            list.forEach { bookmark in
                self.dictionary.updateValue(bookmark, forKey: bookmark.name!)
                bookmarkList.append(bookmark.toDomain())
            }
        } catch {
            bookmarkStorage.rollBack()
        }
        
        return bookmarkList
    }
    
    func create(_ character: CharacterBookmark) {
        if dictionary[character.name] != nil {
            return
        }
        
        self.bookmarkStorage.createBookmark(character) { bookmark in
            self.dictionary.updateValue(bookmark, forKey: character.name)
        }
    }
    
    func delete(_ character: CharacterBookmark) {
        self.bookmarkStorage.deleteBookmark(character.name) { bookmark in
            self.dictionary.removeValue(forKey: character.name)
        }
    }
    
    func hasCharacter(name: String) -> Bool {
        if self.dictionary[name] != nil {
            return true
        }
        
        return false
    }
}
