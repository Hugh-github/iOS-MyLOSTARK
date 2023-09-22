//
//  TestViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/17.
//

import Foundation

protocol MainViewModelOUTPUT {
    var contents: Observable<[CalendarViewModel]> { get }
    var events: Observable<[Event]> { get }
    var notices: Observable<[NoticeItemViewModel]> { get }
    var bookmark: Observable<[BookmarkItemViewModel]?> { get }
    var content: Observable<CalendarViewModel?> { get }
}

final class MainViewModel: MainViewModelOUTPUT, WebConnectableViewModel {
    enum Action {
        case viewDidLoad
        case viewWillAppear
        case selectContentCell(Int)
        case selectNoticeCell(Int)
        case selectEventCell(Int)
        case unRegistCharacter(Int)
    }
    
    private let contentUseCase = ContentUseCase(repository: ContentsRepository())
    private let eventUseCase = EventUseCase()
    private let fetchCoreDataUseCase = FetchCoreDataUseCase<CharacterBookmark>(repository: BookmarkRepository())
    private let interactiveUseCase: InterActionCoreDataUseCase
    private let noticeUseCase: FetchNoticeAPIUseCase

    
    // MARK: OUTPUT
    var contents: Observable<[CalendarViewModel]> = .init([])
    var events: Observable<[Event]> = .init([])
    var notices: Observable<[NoticeItemViewModel]> = .init([])
    var bookmark: Observable<[BookmarkItemViewModel]?> = .init(nil)
    var content: Observable<CalendarViewModel?> = .init(nil)
    var webLink: Observable<WebConnectable?> = .init(nil)
    
    init(
        interactiveUseCase: InterActionCoreDataUseCase,
        noticeUseCase: FetchNoticeAPIUseCase
    ) {
        self.interactiveUseCase = interactiveUseCase
        self.noticeUseCase = noticeUseCase
    }
    
    func execute(_ action: Action) {
        switch action {
        case .viewDidLoad:
            Task {
                await self.fetchAPIData()
            }
        case .viewWillAppear:
            Task {
                await self.fetchCoreData()
            }
        case .selectContentCell(let index):
            self.content.value = contents.value[index]
        case .selectNoticeCell(let index):
            self.webLink.value = notices.value[index]
        case .selectEventCell(let index):
            self.webLink.value = events.value[index]
        case .unRegistCharacter(let index):
            guard let bookmark = self.bookmark.value?[index] else { return }
            
            self.interactiveUseCase.unregist(bookmark.toBookmarkEntity())
            self.interactiveUseCase.update(bookmark.toSearchEntity())
            self.bookmark.value?.remove(at: index)
        }
    }
}

extension MainViewModel {
    private func fetchAPIData() async {
        async let contentList = self.contentUseCase.execute()
        async let noticeList = self.noticeUseCase.execute(.all)
        async let eventList = self.eventUseCase.execute()
        
        do {
            self.contents.value = try await contentList.map(CalendarViewModel.init)
            self.notices.value = try await noticeList.map(NoticeItemViewModel.init)
            self.events.value = try await eventList
        } catch {
            print("에러 발생")
        }
    }
    
    private func fetchCoreData() async {
        async let bookmarkList = self.fetchCoreDataUseCase.execute()
        
        self.bookmark.value = await bookmarkList.map(BookmarkItemViewModel.init)
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
