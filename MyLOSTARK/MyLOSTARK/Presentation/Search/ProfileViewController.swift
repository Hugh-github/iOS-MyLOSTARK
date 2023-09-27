//
//  ProfileViewController.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/09/27.
//

import UIKit

class ProfileViewController: UIViewController {
    private let profileUseCase: CharacterProfileUseCase
    
    init(profileUseCase: CharacterProfileUseCase) {
        self.profileUseCase = profileUseCase
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
