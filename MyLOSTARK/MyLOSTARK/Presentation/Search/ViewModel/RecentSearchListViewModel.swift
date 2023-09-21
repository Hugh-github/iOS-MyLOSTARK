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
    
    private let fetchCoreDataUseCase: FetchCoreDataUseCase<RecentCharacterInfo>
    private let searchUseCase: DefaultSearchUseCase
    private let interactiveUseCase = InterActionCoreDataUseCase()
    
    var itemList: Observable<[RecentSearchItemViewModel]> = .init([])
    
    init(fetchRepo: any DefaultCoreDataRepository, searchRepo: DefaultRecentSearchRepository) {
        self.fetchCoreDataUseCase = FetchCoreDataUseCase<RecentCharacterInfo>(repository: fetchRepo)
        self.searchUseCase = DefaultSearchUseCase(repository: searchRepo)
    }
    
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
            self.searchUseCase.create(info.toSearchEntity())
        case .didTabBookmarkButton(let index):
            if itemList.value[index].isBookmark == false {
                self.interactiveUseCase.regist(itemList.value[index].toBookmarkEntity())
            } else {
                self.interactiveUseCase.unregist(itemList.value[index].toBookmarkEntity())
            }
            
            self.itemList.value[index].toggle()
            self.interactiveUseCase.update(itemList.value[index].toSearchEntity())
        case .didTabDeleteButton(let index):
            self.searchUseCase.delete(itemList.value[index].toSearchEntity())
            self.itemList.value.remove(at: index)
        case .didTabDeleteAllButton:
            self.searchUseCase.deleteAll()
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
