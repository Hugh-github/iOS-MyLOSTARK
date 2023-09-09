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
    
    // MARK: CoreData 연동작업 필요 
    func execute(_ action: Action) {
        switch action {
        case .viewDidLoad:
            self.searchList.value = recentUseCase.execute()
        case .search(let name):
            // MARK: Test용 코드
            let info = RecentCharacterInfo(
                name: name,
                jobClass: "슬레이어",
                itemLevel: "1600",
                isBookmark: false
            )
            self.searchList.value.append(info)
            self.recentUseCase.appendSearch(info)
        case .didTabBookmarkButton(let index):
            // MARK: toggle 상태에 따라 로직 처리
            
            if searchList.value[index].isBookmark == false {
                self.recentUseCase.registBookmark(searchList.value[index])
            } else {
                self.recentUseCase.unRegistBookmark(searchList.value[index])
            }
            
            self.searchList.value[index].toggle()
        case .didTabDeleteButton(let index):
            self.recentUseCase.deleteRecentSearch(searchList.value[index])
            self.searchList.value.remove(at: index)
        case .didTabDeleteAllButton:
            self.recentUseCase.deleteAllSearchList()
            self.searchList.value.removeAll()
        }
    }
}
