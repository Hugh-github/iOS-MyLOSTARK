//
//  NoticeViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/07.
//

import Foundation

protocol NoticeViewModelOUTPUT {
    var updateNotices: Observable<[Notice]> { get }
    var checkNotices: Observable<[Notice]> { get }
    var shopNotices: Observable<[Notice]> { get }
}

class NoticeViewModel: NoticeViewModelOUTPUT, WebConnectableViewModel {
    enum Action {
        case viewDidLoad
        case selectUpdateCell(Int)
        case selectCheckCell(Int)
        case selectShopCell(Int)
    }
    
    private let noticeUseCase = NoticeUseCase()
    
    // MARK: OUTPUT
    var updateNotices: Observable<[Notice]> = Observable.init([])
    var checkNotices: Observable<[Notice]> = Observable.init([])
    var shopNotices: Observable<[Notice]> = Observable.init([])
    var webLink: Observable<WebConnectable?> = Observable.init(nil)
    
    var errorHandling: ((String) -> Void) = { _ in }
    
    func execute(_ action: Action) {
        switch action {
        case .viewDidLoad:
            Task {
                await self.fetchData()
            }
        case .selectUpdateCell(let index):
            self.webLink.value = updateNotices.value[index]
        case .selectCheckCell(let index):
            self.webLink.value = checkNotices.value[index]
        case .selectShopCell(let index):
            self.webLink.value = shopNotices.value[index]
        }
    }
}

extension NoticeViewModel {
    private func fetchData() async {
        async let updateList = try await noticeUseCase.execute("공지")
        async let checkList = try await noticeUseCase.execute("점검")
        async let shopList = try await noticeUseCase.execute("상점")
        
        do {
            self.updateNotices.value = try await updateList
            self.checkNotices.value = try await checkList
            self.shopNotices.value = try await shopList
        } catch {
            print("에러 발생")
        }
    }
}

extension NoticeViewModel: WebViewDelegate {
    func selectLink(linkCase: LinkCase, index: Int) {
        if linkCase == .update {
            self.execute(.selectUpdateCell(index))
        } else if linkCase == .check {
            self.execute(.selectCheckCell(index))
        } else if linkCase == .shop {
            self.execute(.selectShopCell(index))
        }
    }
}

