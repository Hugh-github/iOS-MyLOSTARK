//
//  NoticeViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/07.
//

import Foundation

class NoticeViewModel {
    private let apiService = LOSTARKAPIService()
    
    private var updateNotices: Observable<[Notice]> = Observable.init([])
    private var checkNotices: Observable<[Notice]> = Observable.init([])
    private var shopNotices: Observable<[Notice]> = Observable.init([])
    
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
    
    func subscribeUpdateNotices(on object: AnyObject, handling: @escaping ([Notice]) -> Void) {
        self.updateNotices.addObserver(on: object, handling)
    }
    
    func subscribeCheckNotices(on object: AnyObject, handling: @escaping ([Notice]) -> Void) {
        self.checkNotices.addObserver(on: object, handling)
    }
    
    func subscribeShopNotices(on object: AnyObject, handling: @escaping ([Notice]) -> Void) {
        self.shopNotices.addObserver(on: object, handling)
    }
}
