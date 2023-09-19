//
//  RecentSearchViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/05.
//

protocol RecentSearchListViewModelOUTPUT {
    var itemList: Observable<[RecentSearchItemViewModel]> { get }
}

class RecentSearchListViewModel: RecentSearchListViewModelOUTPUT {
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
    
    var itemList: Observable<[RecentSearchItemViewModel]> = .init([])
    
    func execute(_ action: Action) {
        switch action {
        case .viewWillAppear:
            Task {
                await self.fetchCoreData()
            }
        case .viewWillDisappear:
            self.itemList.value.removeAll()
        case .search(let name):
            // MARK: Test용 코드
            let info = RecentSearchItemViewModel(
                name: name,
                jobClass: "슬레이어",
                itemLevel: "1600",
                isBookmark: false
            )
            
            self.itemList.value.append(info)
            self.coreDataUseCase.appendSearch(info.toDomain())
        case .didTabBookmarkButton(let index):
            if itemList.value[index].isBookmark == false {
                self.coreDataUseCase.registBookmark(itemList.value[index].toDomain())
            } else {
                self.coreDataUseCase.unRegistBookmark(itemList.value[index].toDomain())
            }
            
            self.itemList.value[index].toggle()
            self.coreDataUseCase.updateRecentSearch(itemList.value[index].toDomain())
        case .didTabDeleteButton(let index):
            self.coreDataUseCase.deleteRecentSearch(itemList.value[index].toDomain())
            self.itemList.value.remove(at: index)
        case .didTabDeleteAllButton:
            self.coreDataUseCase.deleteAllSearchList()
            self.itemList.value.removeAll()
        }
    }
}

extension RecentSearchListViewModel {
    private func fetchCoreData() async {
        async let searchList = fetchCoreDataUseCase.execute()
        
        self.itemList.value = await searchList.map{ info in
            RecentSearchItemViewModel(search: info)
        }
    }
}
