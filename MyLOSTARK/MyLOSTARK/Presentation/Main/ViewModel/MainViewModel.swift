//
//  TestViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/17.
//

import Foundation

// MARK: 네이밍 변경
protocol MainViewModelOUTPUT {
    var contents: Observable<[Contents]> { get }
    var events: Observable<[Event]> { get }
    var notices: Observable<[Notice]> { get }
    var bookmark: Observable<[CharacterBookmark]?> { get }
    var content: Observable<Contents?> { get }
}

// 정상적으로 동작한다.
final class MainViewModel: MainViewModelOUTPUT, WebConnectableViewModel {
    enum Action {
        case viewDidLoad
        case viewWillAppear
        case selectContentCell(Int)
        case selectNoticeCell(Int)
        case selectEventCell(Int)
        case unRegistCharacter(Int)
    }
    
    private let contentUseCase = ContentUseCase()
    private let eventUseCase = EventUseCase()
    private let noticeUseCase = NoticeUseCase()
    private let bookmarkUseCase = BookmarkUseCase()
    
    // MARK: OUTPUT
    var contents: Observable<[Contents]> = .init([])
    var events: Observable<[Event]> = .init([])
    var notices: Observable<[Notice]> = .init([])
    var bookmark: Observable<[CharacterBookmark]?> = .init(nil) // 이 부분도 고민해 보자
    var content: Observable<Contents?> = .init(nil)
    var webLink: Observable<WebConnectable?> = .init(nil)
    
    func execute(_ action: Action) {
        switch action {
        case .viewDidLoad:
            Task {
                await self.fetchData()
            }
        case .viewWillAppear:
            self.bookmark.value = bookmarkUseCase.execute()
        case .selectContentCell(let index):
            self.content.value = contents.value[index]
        case .selectNoticeCell(let index):
            self.webLink.value = notices.value[index]
        case .selectEventCell(let index):
            self.webLink.value = events.value[index]
        case .unRegistCharacter(let index):
            self.bookmarkUseCase.unRegistBookmark(bookmark.value![index]) // 옵셔널 바인딩 처리 필요
            self.bookmark.value?.remove(at: index)
        }
    }
}

extension MainViewModel {
    private func fetchData() async {
        async let contentList = self.contentUseCase.execute()
        async let noticeList = self.noticeUseCase.execute()
        async let eventList = self.eventUseCase.execute()
        
        do {
            self.contents.value = try await contentList
            self.notices.value = try await noticeList
            self.events.value = try await eventList
        } catch {
            print("에러 발생")
        }
    }
}

extension MainViewModel: WebViewDelegate {
    func selectLink(linkCase: LinkCase, index: Int) {
        if linkCase == .all {
            self.execute(.selectNoticeCell(index))
        } else if linkCase == .event {
            self.execute(.selectEventCell(index))
        }
    }
}
