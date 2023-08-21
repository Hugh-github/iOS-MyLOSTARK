//
//  WebView.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/27.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    private let viewModel: WebConnectableViewModel
    private let linkCase: LinkCase
    private let index: Int
    
    var delegate: WebViewDelegate?
    
    private var webView = WKWebView()
    
    init(
        viewModel: WebConnectableViewModel,
        linkCase: LinkCase,
        index: Int
    ) {
        self.viewModel = viewModel
        self.linkCase = linkCase
        self.index = index
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.webLink.addObserver(on: self, loadWebView())
        delegate?.selectLink(linkCase: linkCase, index: index)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.viewModel.webLink.removeObserver(observer: self)
    }
    
    private func loadWebView() -> ((WebConnectable?) -> Void) {
        return { connect in
            guard let link = connect?.link,
                  let url = URL(string: link) else {
                return
            }
            
            let request = URLRequest(url: url)
            
            self.webView.load(request)
        }
    }
}
