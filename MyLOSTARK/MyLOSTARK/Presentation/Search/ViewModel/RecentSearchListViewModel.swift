//
//  RecentSearchViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/05.
//

import Foundation

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
    private let profileUseCase = CharacterProfileUseCase(repository: CharacterProfileRepository())
    
    var itemList: Observable<[RecentSearchItemViewModel]> = .init([])
    
    var errorHandling: ((String) -> Void) = { _ in }
    
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
            self.profileUseCase.request = .init(name: name)
            
            Task {
                await self.startSearch()
            }
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
    
    private func startSearch() async {
        do {
            try await self.profileUseCase.execute()
        } catch NetworkError.emptyData {
            DispatchQueue.main.async {
                self.errorHandling("등록된 캐릭터가 없습니다.")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
