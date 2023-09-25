//
//  UIViewController+extension.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/25.
//

import UIKit

fileprivate var backgroundView: UIView?

extension UIViewController {
    func showSpinner() {
        backgroundView = UIView(frame: view.bounds)
        backgroundView?.backgroundColor = .white
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        activityIndicator.center = backgroundView!.center
        activityIndicator.backgroundColor = .black
        activityIndicator.color = .white
        activityIndicator.layer.cornerRadius = 40
        activityIndicator.startAnimating()
        backgroundView?.addSubview(activityIndicator)
        view.addSubview(backgroundView!)
    }
    
    func hideSpinner() {
        backgroundView?.removeFromSuperview()
        backgroundView = nil
    }
}
