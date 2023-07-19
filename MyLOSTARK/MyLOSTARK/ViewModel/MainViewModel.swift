//
//  MainViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/19.
//

import Foundation

/*
 MainView에서 모든 Model은 필요하지만 모든 Model의 데이터는 필요하지 않다.
 -> 필요한 데이터만 Output으로 반환?
 */

class MainViewModel {
    private let apiService = LOSTARKAPIService()
    
    private var shopNotices: Observable<[ShopNotice]?> = Observable.init([])
    private var contents: Observable<[Contents]?> = Observable.init([])
    private var events: Observable<[Event]?> = Observable.init([])
    
    var errorHandling: ((String) -> Void) = { _ in }
    
    enum Action {
        case didTappedCalendar(Int)
        case didTappedEvent(Int)
        case didTappedShopNotice(Int)
    }
    
    enum Output {
        case shopNotice(ShopNotice)
        case contents(Contents)
        case event(Event)
    }
    
    // execute를 하면 아쉬운 점은 리턴 값이 있는 경우 사용이 제한된다. (사용하기 위해서는 protocol로 추상화가 필요?)
    // 추상화를 한다고 하더라도 화면을 구현하는 데이터가 다르기 때문에 타입 캐스팅이 필요하다.
    func execute(action: Action) -> Output {
        switch action {
        case .didTappedEvent(let index):
            return .event(self.events.value![index])
        case .didTappedCalendar(let index):
            return .contents(self.contents.value![index])
        case .didTappedShopNotice(let index):
            return .shopNotice(self.shopNotices.value![index])
        }
    }
    
    func fetchData() {
        Task {
            do {
                self.shopNotices.value = try await apiService.getShopNoticeList()
                self.contents.value = try await apiService.getContents()
                self.events.value = try await apiService.getEventList()
            } catch {
                errorHandling("에러 발생")
            }
        }
    }
}

class Observable<T> {
    
    struct Observer<T> {
        weak var observer: AnyObject?
        let listener: (T) -> Void
    }
    
    var value: T {
        didSet {
            notifyObservers()
        }
    }
    
    private var observers = [Observer<T>]()
    
    init(_ value: T) {
        self.value = value
    }
    
    func addObserver(on observer: AnyObject, _ closure: @escaping (T) -> Void) {
        observers.append(Observer(observer: observer, listener: closure))
    }
    
    func removeObserver(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer.listener(value)
        }
    }
}
