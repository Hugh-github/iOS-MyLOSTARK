//
//  WebConnactable.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/18.
//

protocol WebConnectable {
    var link: String { get }
}

protocol WebConnectableViewModel {
    var webLink: Observable<WebConnectable?> { get }
}
