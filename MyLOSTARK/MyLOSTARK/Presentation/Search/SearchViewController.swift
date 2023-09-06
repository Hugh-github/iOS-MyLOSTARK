//
//  SearchViewController.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/09.
//

import UIKit

// Cell 커스텀 해야 한다.
class SearchViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<SearchViewSection, RecentCharacterInfo>
    
    enum SearchViewSection: CaseIterable {
        case main
    }
    
    private var collectionView: UICollectionView! = nil
    private var dataSource: DataSource! = nil
    private let layoutBuilder = CollectionViewLayoutBuilder()
    
    private let viewModel = RecentSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.configureNavigationBar()
        self.configureCollectionView()
        self.configureDataSource()
        self.configureSupplementaryView()
        self.initialSnapshot()
        self.dataBinding()
        
        self.viewModel.execute(.viewDidLoad)
    }
}

// MARK: Configure CollectionView
extension SearchViewController {
    private func configureCollectionView() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            CommonHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CommonHeaderView.reuseIdentifier
        )
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            self.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setCollectionViewLayout() -> UICollectionViewLayout {
        guard let section = layoutBuilder.setItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
            .setGroup(width: .fractionalWidth(1.0), height: .fractionalHeight(0.1), direction: .vertical)
            .getSectionLayout() else {
            return UICollectionViewLayout()
        }
        section.boundarySupplementaryItems = [self.createHeader()]
        section.setGroupSpacing(10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
        
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.1))

        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}

// MARK: ConfigureDataSource
extension SearchViewController {
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<RecentCharacterCell, RecentCharacterInfo> { cell, indexPath, itemIdentifier in
            // MARK: Cell 각각의 View에 직접 접근해서 설정하는 방법이 어떤지 고민해보자(supplymentaryView도 마찬가지)
            cell.thumbnailView.image = UIImage(named: itemIdentifier.jobClass)?.resize(newWidth: cell.frame.height * 0.8)
            cell.nameLabel.text = itemIdentifier.name
            cell.levelLabel.text = itemIdentifier.itemLevel
            cell.bookmarkButton.isHighlighted = !itemIdentifier.isBookmark
            cell.bookmarkButton.addAction(self.didTapBookmarkButton(indexPath.row), for: .touchUpInside)
        }
        
        self.dataSource = DataSource.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
    }
    
    private func configureSupplementaryView() {
        self.dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath -> UICollectionReusableView? in
            
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind,
                withReuseIdentifier: CommonHeaderView.reuseIdentifier,
                for: indexPath
            ) as? CommonHeaderView else {
                return nil
            }
            
            header.configureHeader(title: "최근 검색어")
            header.configureButton(title: "전체 삭제")
            
            header.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
            header.button.addAction(self.didTabDeleteAllButton(), for: .touchUpInside)
            
            return header
        }
    }
    
    private func didTabDeleteAllButton() -> UIAction {
        return UIAction { _ in
            // MARK: 함수로 변경(CoreData에도 반영 가능하도록)
            self.viewModel.searchList.value.removeAll()
        }
    }
    
    private func didTapBookmarkButton(_ index: Int) -> UIAction {
        return UIAction { _ in
            // MARK: index를 이용해 CoreData 추가 변경
            print("안녕")
        }
    }
    
    private func initialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SearchViewSection, RecentCharacterInfo>()
        snapshot.appendSections(SearchViewSection.allCases)
        
        self.dataSource.apply(snapshot)
    }
}

// MARK: DataBinding
extension SearchViewController {
    private func dataBinding() {
        self.viewModel.searchList.addObserver(on: self) { searchList in
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<RecentCharacterInfo>()
            sectionSnapshot.append(searchList)
            self.dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: true)
        }
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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.viewModel.searchList.value.append(RecentCharacterInfo(name: searchBar.text!, jobClass: "건슬링어", itemLevel: "1565.0", isBookmark: false))
    }
}
