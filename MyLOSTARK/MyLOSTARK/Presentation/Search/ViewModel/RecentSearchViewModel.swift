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
        case viewWillAppear
        case viewWillDisappear
        case search(String)
        case didTabBookmarkButton(Int)
        case didTabDeleteButton(Int)
        case didTabDeleteAllButton
    }
    
    private let fetchCoreDataUseCase = FetchCoreDataUseCase<RecentCharacterInfo>(repository: RecentSearchRepository())
    private let coreDataUseCase = CharacterInfoCoreDataUseCase()
    
    var searchList: Observable<[RecentCharacterInfo]> = .init([])
    
    func execute(_ action: Action) {
        switch action {
        case .viewWillAppear:
            Task {
                await self.fetchCoreData()
            }
        case .viewWillDisappear:
            self.searchList.value.removeAll()
        case .search(let name):
            // MARK: Test용 코드
            let info = RecentCharacterInfo(
                name: name,
                jobClass: "슬레이어",
                itemLevel: "1600",
                isBookmark: false
            )
            self.searchList.value.append(info)
            self.coreDataUseCase.appendSearch(info)
        case .didTabBookmarkButton(let index):
            if searchList.value[index].isBookmark == false {
                self.coreDataUseCase.registBookmark(searchList.value[index])
            } else {
                self.coreDataUseCase.unRegistBookmark(searchList.value[index])
            }
            
            self.searchList.value[index].toggle()
            self.coreDataUseCase.updateRecentSearch(searchList.value[index])
        case .didTabDeleteButton(let index):
            self.coreDataUseCase.deleteRecentSearch(searchList.value[index])
            self.searchList.value.remove(at: index)
        case .didTabDeleteAllButton:
            self.coreDataUseCase.deleteAllSearchList()
            self.searchList.value.removeAll()
        }
    }
}

extension RecentSearchViewModel {
    private func fetchCoreData() async {
        async let searchList = fetchCoreDataUseCase.execute()
        
        self.searchList.value = await searchList
    }
}
