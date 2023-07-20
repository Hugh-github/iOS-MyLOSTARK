//
//  ViewController.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/14.
//

import UIKit

enum MainViewSection: Int, CaseIterable {
    case calendar = 0
    case characterBookmark
    case shopNotice
    case event
}

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNavigationItem()
    }
    
    private func setNavigationItem() {
        let logoImageView = UIImageView(image: UIImage(named: "LogoImage"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.frame = CGRect(x: 0, y: 0, width: 180, height: 44)
        
        let leftBarButtonItem = UIBarButtonItem(customView: logoImageView)
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let infoImageButton = UIButton()
        infoImageButton.setImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        infoImageButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        infoImageButton.contentVerticalAlignment = .fill
        infoImageButton.contentHorizontalAlignment = .fill
        
        let rightBarButtonItem = UIBarButtonItem(customView: infoImageButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}
