//
//  TestViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/17.
//

import Foundation

protocol TestViewModelOUTPUT {
    var contents: Observable<[Contents]> { get }
    var events: Observable<[Event]> { get }
    var notices: Observable<[Notice]> { get }
    var bookmark: Observable<[CharacterBookmark]?> { get }
    var content: Observable<Contents?> { get }
}

// 정상적으로 동작한다.
final class MainViewModel: TestViewModelOUTPUT, WebConnectableViewModel {
    enum Action {
        case viewDidLoad
        case selectContentCell(Int)
        case selectNoticeCell(Int)
        case selectEventCell(Int)
    }
    
    private let contentUseCase = ContentUseCase()
    private let eventUseCase = EventUseCase()
    private let noticeUseCase = NoticeUseCase()
    private let bookmarkUseCase = BookmarkUseCase()
    
    // MARK: OUTPUT
    var contents: Observable<[Contents]> = .init([])
    var events: Observable<[Event]> = .init([])
    var notices: Observable<[Notice]> = .init([])
    var bookmark: Observable<[CharacterBookmark]?> = .init(nil)
    var content: Observable<Contents?> = .init(nil)
    var webLink: Observable<WebConnectable?> = .init(nil)
    
    func execute(_ action: Action) {
        switch action {
        case .viewDidLoad:
            Task {
                await self.fetchData()
            }
            
            self.bookmark.value = bookmarkUseCase.execute()
        case .selectContentCell(let index):
            self.content.value = contents.value[index]
        case .selectNoticeCell(let index):
            self.webLink.value = notices.value[index]
        case .selectEventCell(let index):
            self.webLink.value = events.value[index]
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
