//
//  NoticeViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/07.
//

import Foundation

class NoticeViewModel: WebConnectableViewModel {
    enum Kind {
        case update
        case check
        case shop
    }
    
    private let apiService = LOSTARKAPIService.shared
    
    // MARK: OUTPUT
    private var updateNotices: Observable<[Notice]> = Observable.init([])
    private var checkNotices: Observable<[Notice]> = Observable.init([])
    private var shopNotices: Observable<[Notice]> = Observable.init([])
    
    var webLink: Observable<WebConnectable?> = Observable.init(nil)
    
    var errorHandling: ((String) -> Void) = { _ in }
    
    func fetchData() {
        Task {
            do {
                self.updateNotices.value = try await apiService.getNoticeList("공지")
            } catch {
                errorHandling("에러 발생")
            }
        }
        
        Task {
            do {
                self.checkNotices.value = try await apiService.getNoticeList("점검")
            } catch {
                errorHandling("에러 발생")
            }
        }
        
        Task {
            do {
                self.shopNotices.value = try await apiService.getNoticeList("상점")
            } catch {
                errorHandling("에러 발생")
            }
        }
    }
    
    func selectItem(_ kind: Kind, on index: Int) {
        if kind == .update {
            self.webLink.value = updateNotices.value[index - 1]
        } else if kind == .check {
            self.webLink.value = checkNotices.value[index - 1]
        } else if kind == .shop {
            self.webLink.value = shopNotices.value[index - 1]
        }
    }
}

extension NoticeViewModel {
    func subscribeUpdateNotices(on object: AnyObject, handling: @escaping ([Notice]) -> Void) {
        self.updateNotices.addObserver(on: object, handling)
    }
    
    func subscribeCheckNotices(on object: AnyObject, handling: @escaping ([Notice]) -> Void) {
        self.checkNotices.addObserver(on: object, handling)
    }
    
    func subscribeShopNotices(on object: AnyObject, handling: @escaping ([Notice]) -> Void) {
        self.shopNotices.addObserver(on: object, handling)
    }
    
    func subscribeWebLink(on object: AnyObject, handling: @escaping ((WebConnectable?) -> Void)) {
        self.webLink.addObserver(on: object, handling)
    }
    
    func unsubscribeWebLink(on object: AnyObject) {
        self.webLink.removeObserver(observer: object)
    }
}
