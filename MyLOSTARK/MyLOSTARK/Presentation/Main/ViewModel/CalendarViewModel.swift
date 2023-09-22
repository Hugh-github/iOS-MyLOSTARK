//
//  CalendarViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/22.
//

class CalendarViewModel: Hashable {
    private let dateFormatter = DateFormatterManager.shared
    
    let contentsName: String
    let contentsIcon: String
    private let rewardItems: [RewardItemViewModel]
    
    private var amStartTime: String {
        return "\(dateFormatter.getTodyDate())T11:00:00"
    }
    
    private var pmStartTime: String {
        return "\(dateFormatter.getTodyDate())T19:00:00"
    }
    
    init(content: Contents) {
        self.contentsName = content.contentsName
        self.contentsIcon = content.contentsIcon
        self.rewardItems = content.rewardItems.map(RewardItemViewModel.init)
    }
    
    var rewards: [RewardItemViewModel] {
        return rewardItems.filter { item in
            if let startTimes = item.startTimes {
                return startTimes.contains(amStartTime) || startTimes.contains(pmStartTime)
            } else {
                return true
            }
        }
    }
    
    static func == (lhs: CalendarViewModel, rhs: CalendarViewModel) -> Bool {
        return lhs.contentsName == rhs.contentsName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(contentsName)
    }
}

struct RewardItemViewModel: Hashable {
    let name: String
    let icon: String
    let grade: String
    let startTimes: [String]?
    
    init(rewardItem: RewardItem) {
        self.name = rewardItem.name
        self.icon = rewardItem.icon
        self.grade = rewardItem.grade
        self.startTimes = rewardItem.startTimes
    }
}
