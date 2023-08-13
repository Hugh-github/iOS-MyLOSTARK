//
//  WebConnactableViewModelProtocol.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/12.
//

protocol WebConnectableViewModel {
    var webLink: Observable<WebConnectable?> { get }
    
    func subscribeWebLink(on object: AnyObject, handling: @escaping ((WebConnectable?) -> Void))
    func unsubscribeWebLink(on object: AnyObject)
}
