//
//  WebView.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/27.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    private let viewModel: WebConnectableViewModel
    private var webView = WKWebView()
    
    init(viewModel: WebConnectableViewModel) {
        self.viewModel = viewModel
        
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
        
        subscribeViewModel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.viewModel.unsubscribeWebLink(on: self)
    }
    
    private func subscribeViewModel() {
        self.viewModel.subscribeWebLink(on: self) { connect in
            guard let link = connect?.link,
                  let url = URL(string: link) else { return }
            
            let request = URLRequest(url: url)
            
            DispatchQueue.main.async {
                self.webView.load(request)
            }
        }
    }
}
