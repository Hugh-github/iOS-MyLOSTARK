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
    typealias DataSource = UICollectionViewDiffableDataSource<MainViewSection, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MainViewSection, AnyHashable>
    
    private let mainView = MainCollectionView()
    private let viewModel = MainViewModel()
    
    private lazy var dataSource = DataSource(collectionView: self.mainView.collectionView) { (collectionView, indexPath, itemIdentifier) in
        let section = MainViewSection(rawValue: indexPath.section)
        
        switch section {
        case .calendar:
            return self.mainView.collectionView.dequeueConfiguredReusableCell(
                using: self.createCalendarSectionCell(),
                for: indexPath,
                item: itemIdentifier as? Contents
            )
        case .characterBookmark:
            break
        case .shopNotice:
            return self.mainView.collectionView.dequeueConfiguredReusableCell(
                using: self.createShopNoticeSectionCell(),
                for: indexPath,
                item: itemIdentifier as? ShopNotice
            )
        case .event:
            return self.mainView.collectionView.dequeueConfiguredReusableCell(
                using: self.createEventSectionCell(),
                for: indexPath,
                item: itemIdentifier as? Event
            )
        default:
            return nil
        }
        
        return UICollectionViewCell()
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNavigationItem()
        
        viewModel.fetchData()
    }
    
    // MARK: 초기 Snapshot을 만들고 NSDiffableSectionSnapshot을 이용해 각각의 Section을 업데이트 한다.
}

// MARK: Create Cell
extension MainViewController {
    func createCalendarSectionCell() -> UICollectionView.CellRegistration<VStackImageLabelCell, Contents> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            guard let url = URL(string: itemIdentifier.contentsIcon) else { return }
            
            ImageLoader.shared.fetch(url) { image in
                cell.setContent(text: itemIdentifier.contentsName, image: image)
            }
        }
    }
    
    func createEventSectionCell() -> UICollectionView.CellRegistration<VStackImageLabelCell, Event> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            guard let url = URL(string: itemIdentifier.thumbnail) else { return }
            
            ImageLoader.shared.fetch(url) { image in
                cell.setContent(text: itemIdentifier.title, image: image)
            }
        }
    }
    
    func createShopNoticeSectionCell() -> UICollectionView.CellRegistration<UICollectionViewListCell, ShopNotice> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemIdentifier.title
            cell.contentConfiguration = configuration
        }
    }
}

extension MainViewController {
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
