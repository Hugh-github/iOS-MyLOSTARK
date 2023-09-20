//
//  NoticeItemViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/20.
//

struct NoticeItemViewModel: Hashable, WebConnectable {
    let title: String
    var link: String
    let type: String
    
    init(notice: Notice) {
        self.title = notice.title
        self.link = notice.link
        self.type = notice.type
    }
}
