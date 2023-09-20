//
//  NoticeViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/07.
//

protocol NoticeViewModelOUTPUT {
    var updateNotices: Observable<[NoticeItemViewModel]> { get }
    var checkNotices: Observable<[NoticeItemViewModel]> { get }
    var shopNotices: Observable<[NoticeItemViewModel]> { get }
}

class NoticeViewModel: NoticeViewModelOUTPUT, WebConnectableViewModel {
    enum Action {
        case viewDidLoad
        case selectUpdateCell(Int)
        case selectCheckCell(Int)
        case selectShopCell(Int)
    }
    
    private let noticeUseCase: FetchNoticeAPIUseCase
    
    // MARK: OUTPUT
    var updateNotices: Observable<[NoticeItemViewModel]> = Observable.init([])
    var checkNotices: Observable<[NoticeItemViewModel]> = Observable.init([])
    var shopNotices: Observable<[NoticeItemViewModel]> = Observable.init([])
    var webLink: Observable<WebConnectable?> = Observable.init(nil)
    
    var errorHandling: ((String) -> Void) = { _ in }
    
    init(noticeUseCase: FetchNoticeAPIUseCase) {
        self.noticeUseCase = noticeUseCase
    }
    
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
        async let updateList = try await noticeUseCase.execute(.update)
        async let checkList = try await noticeUseCase.execute(.check)
        async let shopList = try await noticeUseCase.execute(.all)
        
        do {
            self.updateNotices.value = try await updateList.map(NoticeItemViewModel.init)
            self.checkNotices.value = try await checkList.map(NoticeItemViewModel.init)
            self.shopNotices.value = try await shopList.map(NoticeItemViewModel.init)
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
