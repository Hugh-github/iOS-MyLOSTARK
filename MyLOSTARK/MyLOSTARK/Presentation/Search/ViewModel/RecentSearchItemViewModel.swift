//
//  RecentSearchItemViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/19.
//

class RecentSearchItemViewModel: Hashable {
    var name: String
    var jobClass: String
    var itemLevel: String
    var isBookmark: Bool
    
    init(name: String, jobClass: String, itemLevel: String, isBookmark: Bool) {
        self.name = name
        self.jobClass = jobClass
        self.itemLevel = itemLevel
        self.isBookmark = isBookmark
    }
    
    convenience init(
        search: RecentCharacterInfo
    ) {
        self.init(
            name: search.name ?? "",
            jobClass: search.jobClass ?? "",
            itemLevel: search.itemLevel ?? "",
            isBookmark: search.isBookmark
        )
    }
    
    static func == (lhs: RecentSearchItemViewModel, rhs: RecentSearchItemViewModel) -> Bool {
        return lhs.name == rhs.name && lhs.isBookmark == rhs.isBookmark
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension RecentSearchItemViewModel {
    func toggle() {
        self.isBookmark.toggle()
    }
    
    // viewModel에서 Domain에 데이터를 전달하기 위해 toDomain 함수가 반드시 필요한지 고민할 필요는 있다.
    func toDomain() -> RecentCharacterInfo {
        return RecentCharacterInfo(name: name, jobClass: jobClass, itemLevel: itemLevel, isBookmark: isBookmark)
    }
}
