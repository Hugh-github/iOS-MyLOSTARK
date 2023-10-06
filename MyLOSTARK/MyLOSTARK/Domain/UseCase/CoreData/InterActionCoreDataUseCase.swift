//
//  DatabaseUseCase.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/18.
//

// BookmarkRepository와 RecentSearchRepository를 추상화 해야 한다.

class InterActionCoreDataUseCase {
    private let bookmarkRepository: InteractiveBookmarkRepository
    private let searchRepository: InteractiveSearchRepository
    
    init(
        bookmarkRepository: InteractiveBookmarkRepository = BookmarkRepository.shared,
        searchRepository: InteractiveSearchRepository = RecentSearchRepository()
    ) {
        self.bookmarkRepository = bookmarkRepository
        self.searchRepository = searchRepository
    }
    
    func regist(_ character: CharacterBookmark) {
        self.bookmarkRepository.create(character)
    }
    
    func unregist(_ character: CharacterBookmark) {
        self.bookmarkRepository.delete(character)
    }
    
    func update(_ character: RecentCharacterInfo) {
        self.searchRepository.update(character)
    }
    
    func isBookmark(name: String) -> Bool {
        return bookmarkRepository.hasCharacter(name: name)
    }
}
