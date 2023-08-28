//
//  SearchViewController.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/09.
//

import UIKit

// Cell 커스텀 해야 한다.
class SearchViewController: UIViewController {
    private var collectionView: UICollectionView! = nil
    private let layoutBuilder = CollectionViewLayoutBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar()
        self.configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: setCollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.register(
            CommonHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CommonHeaderView.reuseIdentifier
        )
        
        view.addSubview(collectionView)
    }
    
    private func setCollectionViewLayout() -> UICollectionViewLayout {
        guard let section = layoutBuilder.setItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
            .setGroup(width: .fractionalHeight(1.0), height: .fractionalHeight(0.15), direction: .horizontal)
            .getSectionLayout() else {
            return UICollectionViewLayout()
        }
        section.boundarySupplementaryItems = [self.createHeader()]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
        
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
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
