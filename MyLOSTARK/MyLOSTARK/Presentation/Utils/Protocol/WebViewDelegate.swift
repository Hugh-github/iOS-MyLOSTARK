//
//  WebViewDelegate.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/21.
//

enum LinkCase {
    case all
    case event
    case update
    case check
    case shop
}

protocol WebViewDelegate {
    func selectLink(linkCase: LinkCase, index: Int)
}
