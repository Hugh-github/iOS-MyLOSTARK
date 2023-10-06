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
        case search(String, () -> Void)
        case didTabBookmarkButton(Int)
        case didTabDeleteButton(Int)
        case didTabDeleteAllButton
    }
    
    private let fetchCoreDataUseCase: FetchCoreDataUseCase<RecentCharacterInfo>
    private let searchUseCase: DefaultSearchUseCase
    private let interactionUseCase: InterActionCoreDataUseCase
    private let profileUseCase: CharacterProfileUseCase
    
    var itemList: Observable<[RecentSearchItemViewModel]> = .init([])
    
    var errorHandling: ((String) -> Void) = { _ in }
    
    init(
        fetchCoreDataUseCase: FetchCoreDataUseCase<RecentCharacterInfo>,
        searchUseCase: DefaultSearchUseCase,
        interactionUseCase: InterActionCoreDataUseCase,
        profileUseCase: CharacterProfileUseCase
    ) {
        self.fetchCoreDataUseCase = fetchCoreDataUseCase
        self.searchUseCase = searchUseCase
        self.interactionUseCase = interactionUseCase
        self.profileUseCase = profileUseCase
    }
    
    func execute(_ action: Action) {
        switch action {
        case .viewWillAppear:
            Task {
                await self.fetchCoreData()
            }
        case .viewWillDisappear:
            self.itemList.value.removeAll()
        case .search(let name, let completion):
            self.profileUseCase.request = .init(name: name)
            
            Task {
                await self.startSearch(completionHandler: completion)
            }
        case .didTabBookmarkButton(let index):
            if itemList.value[index].isBookmark == false {
                self.interactionUseCase.regist(itemList.value[index].toBookmarkEntity())
            } else {
                self.interactionUseCase.unregist(itemList.value[index].toBookmarkEntity())
            }
            
            self.itemList.value[index].toggle()
            self.interactionUseCase.update(itemList.value[index].toSearchEntity())
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
    
    private func startSearch(completionHandler: @escaping () -> Void) async {
        do {
            try await self.profileUseCase.execute()
            completionHandler()
        } catch NetworkError.emptyData {
            DispatchQueue.main.async {
                self.errorHandling("등록된 캐릭터가 없습니다.")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
