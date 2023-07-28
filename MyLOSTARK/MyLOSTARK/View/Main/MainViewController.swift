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
    private var dataSource: DataSource!
    
    override func loadView() {
        mainView.collectionView.delegate = self
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setNavigationItem()
        self.createCell()
        self.createHeaderView()
        self.initailSnapshot()
        self.subscribeViewModel()
        
        self.viewModel.fetchData()
    }
    
    private func createCell() {
        let calendarRegistration = createCalendarSectionCell()
        let shopNoticeRegistration = createShopNoticeSectionCell()
        let eventRegistration = createEventSectionCell()
        
        self.dataSource = DataSource(collectionView: self.mainView.collectionView) { (collectionView, indexPath, itemIdentifier) in            
            if let item = itemIdentifier as? Contents {
                return collectionView.dequeueConfiguredReusableCell(
                    using: calendarRegistration,
                    for: indexPath,
                    item: item
                )
            } else if let item = itemIdentifier as? ShopNotice {
                return collectionView.dequeueConfiguredReusableCell(
                    using: shopNoticeRegistration,
                    for: indexPath,
                    item: item
                )
            } else if let item = itemIdentifier as? Event {
                return collectionView.dequeueConfiguredReusableCell(
                    using: eventRegistration,
                    for: indexPath,
                    item: item
                )
            }
            
            return UICollectionViewCell()
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let webViewController = WebViewController(viewModel: self.viewModel)
        present(webViewController, animated: false)
        
        if indexPath.section == 2 {
            self.viewModel.selectShopNotice(index: indexPath.row)
        } else if indexPath.section == 3 {
            self.viewModel.selectEvent(index: indexPath.row)
        }
    }
}

// MARK: Snapshot
extension MainViewController {
    private func initailSnapshot() {
        var snapshot = Snapshot()
        
        snapshot.appendSections(MainViewSection.allCases)
        self.dataSource.apply(snapshot)
    }
    
    private func subscribeViewModel() {
        self.subscribeContent()
        self.subscribeShopNotice()
        self.subscribeEvent()
    }
    
    private func subscribeContent() {
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        
        self.viewModel.subscribeContent(on: self) { contents in
            DispatchQueue.main.async {
                sectionSnapshot.append(contents)
                self.dataSource.apply(sectionSnapshot, to: .calendar)
            }
        }
    }
    
    private func subscribeShopNotice() {
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        
        self.viewModel.subscribeShopNotice(on: self) { notice in
            DispatchQueue.main.async {
                sectionSnapshot.append(notice)
                self.dataSource.apply(sectionSnapshot, to: .shopNotice)
            }
        }
    }
    
    private func subscribeEvent() {
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        
        self.viewModel.subscribeEvent(on: self) { events in
            DispatchQueue.main.async {
                sectionSnapshot.append(events)
                self.dataSource.apply(sectionSnapshot, to: .event)
            }
        }
    }
}

// MARK: Create Cell & Header
extension MainViewController {
    private func createHeaderView() {
        self.dataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            guard elementKind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: elementKind,
                withReuseIdentifier: "Header",
                for: indexPath
            ) as? CommonHeaderView else {
                return nil
            }
            
            let snapshot = self.dataSource.snapshot()
            let section = snapshot.sectionIdentifiers[indexPath.section]
            
            switch section {
            case .calendar:
                header.configureHeader(title: "모험 섬", color: .white)
            case .characterBookmark:
                header.configureHeader(title: "즐겨찾는 캐릭터", color: .white)
            case .shopNotice:
                header.configureHeader(title: "상점 업데이트", color: .white)
            case .event:
                header.configureHeader(title: "Event", color: .darkGray)
            }
            
            return header
        }
    }
    
    private func createCalendarSectionCell() -> UICollectionView.CellRegistration<VStackImageLabelCell, Contents> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            guard let url = URL(string: itemIdentifier.contentsIcon) else { return }
            
            ImageLoader.shared.fetch(url) { image in
                cell.setContent(title: itemIdentifier.contentsName, image: image)
            }
            cell.backgroundColor = .white
        }
    }
    
    private func createEventSectionCell() -> UICollectionView.CellRegistration<VStackImageLabelCell, Event> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            guard let url = URL(string: itemIdentifier.thumbnail) else { return }
            
            ImageLoader.shared.fetch(url) { image in
                cell.setContent(title: itemIdentifier.title, image: image)
            }
            cell.backgroundColor = .darkGray
            cell.setTextColor(.white)
        }
    }
    
    private func createShopNoticeSectionCell() -> UICollectionView.CellRegistration<UICollectionViewListCell, ShopNotice> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemIdentifier.title
            cell.contentConfiguration = configuration
        }
    }
}

// MARK: Set Navigation
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
        infoImageButton.tintColor = .lightGray
        infoImageButton.contentVerticalAlignment = .fill
        infoImageButton.contentHorizontalAlignment = .fill
        
        let rightBarButtonItem = UIBarButtonItem(customView: infoImageButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}