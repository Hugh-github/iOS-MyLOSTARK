//
//  EventViewModel.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/23.
//

struct EventViewModel: Hashable, WebConnectable {
    let title: String
    let thumbnail: String
    var link: String
    
    init(event: Event) {
        self.title = event.title
        self.thumbnail = event.thumbnail
        self.link = event.link
    }
}
