//
//  RecentSearchViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/05.
//

import Foundation

protocol RecentSearchViewModelOUTPUT {
    var searchList: Observable<[RecentCharacterInfo]> { get }
}

class RecentSearchViewModel: RecentSearchViewModelOUTPUT {
    enum Action {
        case viewDidLoad
        case search(String)
        case didTabBookmarkButton(Int)
        case didTabDeleteButton(Int)
        case didTabDeleteAllButton
    }
    
    private let recentUseCase = RecentSearchUseCase()
    
    var searchList: Observable<[RecentCharacterInfo]> = .init([])
    
    func execute(_ action: Action) {
        switch action {
        case .viewDidLoad:
            self.searchList.value = recentUseCase.execute()
        case .search(_):
            break
        case .didTabBookmarkButton(let index):
            self.searchList.value[index].toggle()
        case .didTabDeleteButton(let index):
            self.searchList.value.remove(at: index)
        case .didTabDeleteAllButton:
            self.searchList.value.removeAll()
        }
    }
}
