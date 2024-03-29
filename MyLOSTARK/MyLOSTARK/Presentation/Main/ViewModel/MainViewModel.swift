//
//  TestViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/17.
//

import Foundation

protocol MainViewModelOUTPUT {
    var contents: Observable<[CalendarViewModel]> { get }
    var events: Observable<[EventViewModel]> { get }
    var notices: Observable<[NoticeItemViewModel]> { get }
    var bookmark: Observable<[BookmarkItemViewModel]?> { get }
    var content: Observable<CalendarViewModel?> { get }
}

final class MainViewModel: MainViewModelOUTPUT, WebConnectableViewModel {
    enum Action {
        case viewDidLoad(() -> Void)
        case viewWillAppear
        case selectContentCell(Int)
        case selectBookmarkCell(Int, () -> Void)
        case selectNoticeCell(Int)
        case selectEventCell(Int)
        case unRegistCharacter(Int)
    }
    
    private let contentUseCase = ContentUseCase(repository: ContentsRepository())
    private let eventUseCase = EventUseCase(repository: EventRepository())
    private let fetchCoreDataUseCase = FetchCoreDataUseCase<CharacterBookmark>(repository: BookmarkRepository.shared)
    private let interactiveUseCase: InterActionCoreDataUseCase
    private let noticeUseCase: FetchNoticeAPIUseCase
    private let profileUseCase: CharacterProfileUseCase

    
    // MARK: OUTPUT
    var contents: Observable<[CalendarViewModel]> = .init([])
    var events: Observable<[EventViewModel]> = .init([])
    var notices: Observable<[NoticeItemViewModel]> = .init([])
    var bookmark: Observable<[BookmarkItemViewModel]?> = .init(nil)
    var content: Observable<CalendarViewModel?> = .init(nil)
    var webLink: Observable<WebConnectable?> = .init(nil)
    
    init(
        interactiveUseCase: InterActionCoreDataUseCase,
        noticeUseCase: FetchNoticeAPIUseCase,
        profileUseCase: CharacterProfileUseCase
    ) {
        self.interactiveUseCase = interactiveUseCase
        self.noticeUseCase = noticeUseCase
        self.profileUseCase = profileUseCase
    }
    
    func execute(_ action: Action) {
        switch action {
        case .viewDidLoad(let completionHandler):
            Task {
                await self.fetchAPIData()
                completionHandler()
            }
        case .viewWillAppear:
            Task {
                await self.fetchCoreData()
            }
        case .selectContentCell(let index):
            self.content.value = contents.value[index]
        case .selectBookmarkCell(let index, let completion):
            guard let characterName = self.bookmark.value?[index].name else { return }
            self.profileUseCase.request = .init(name: characterName)
            Task {
                try await self.profileUseCase.execute()
                completion()
            }
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
            self.events.value = try await eventList.map(EventViewModel.init)
        } catch {
            print(error)
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
