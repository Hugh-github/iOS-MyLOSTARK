//
//  SearchViewController.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/09.
//

import UIKit

// Cell 커스텀 해야 한다.
// 기존의 CommenHeaderView를 조금 수정하자.
class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.configureNavigationBar()
    }
    
}

extension SearchViewController {
    func configureNavigationBar() {
        let searchController = UISearchController()
        searchController.searchBar.barTintColor = .black
        searchController.searchBar.tintColor = .black
        searchController.searchBar.placeholder = "캐릭터 이름"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.title = "캐릭터 검색"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
    }
}
