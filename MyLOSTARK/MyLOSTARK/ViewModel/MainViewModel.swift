//
//  MainViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/19.
//

import Foundation

class MainViewModel: WebConnectableViewModel {
    private let apiService = LOSTARKAPIService.shared
    private let repository = CoreDataManager.shared
    
    // MARK: OUTPUT
    private var shopNotices: Observable<[Notice]> = Observable.init([])
    private var contents: Observable<[Contents]> = Observable.init([])
    private var events: Observable<[Event]> = Observable.init([])
    private var characterBookmarks: Observable<[CharacterBookmark]?> = Observable.init(nil)
    var webLink: Observable<WebConnectable?> = Observable.init(nil)
    private var content: Observable<Contents?> = Observable.init(nil)
    
    var errorHandling: ((String) -> Void) = { _ in }
    
    func fetchData() {
        Task {
            do {
                self.shopNotices.value = try await apiService.getNoticeList("상점")
            } catch {
                errorHandling("에러 발생")
            }
        }
        
        Task {
            do {
                self.contents.value = try await apiService.getContents()
            } catch {
                errorHandling("에러 발생")
            }
        }
        
        Task {
            do {
                self.events.value = try await apiService.getEventList()
            } catch {
                errorHandling("에러 발생")
            }
        }
        
        self.characterBookmarks.value = repository.fetchCoreData()
    }
    
    func subscribeWebLink(on object: AnyObject, handling: @escaping ((WebConnectable?) -> Void)) {
        self.webLink.addObserver(on: object, handling)
    }
    
    func unsubscribeWebLink(on object: AnyObject) {
        self.webLink.removeObserver(observer: object)
    }
    
    func subscribeContent(on object: AnyObject, handling: @escaping ((Contents?) -> Void)) {
        self.content.addObserver(on: object, handling)
    }
    
    func unsubscribeContent(on object: AnyObject) {
        self.content.removeObserver(observer: object)
    }
}

// MARK: Content
extension MainViewModel {
    func subscribeContents(on object: AnyObject, handling: @escaping ([Contents]) -> Void) {
        self.contents.addObserver(on: object, handling)
    }
    
    func selectContent(index: Int) {
        self.content.value = self.contents.value[index]
    }
}

// MARK: ShopNotice
extension MainViewModel {
    func subscribeShopNotice(on object: AnyObject, handling: @escaping ([Notice]) -> Void) {
        self.shopNotices.addObserver(on: object, handling)
    }
    
    func selectShopNotice(index: Int) {
        self.webLink.value = self.shopNotices.value[index]
    }
}

// MARK: Event
extension MainViewModel {
    func subscribeEvent(on object: AnyObject, handling: @escaping ([Event]) -> Void) {
        self.events.addObserver(on: object, handling)
    }
    
    func selectEvent(index: Int) {
        self.webLink.value = self.events.value[index]
    }
}

// MARK: Bookmark
extension MainViewModel {
    func subscribeBookmark(on object: AnyObject, handling: @escaping ([CharacterBookmark]?) -> Void) {
        self.characterBookmarks.addObserver(on: object, handling)
    }
}
