//
//  ViewController.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/14.
//

import UIKit

class MainViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<MainViewSection, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MainViewSection, AnyHashable>
    
    enum MainViewSection: CaseIterable {
        case calendar
        case characterBookmark
        case shopNotice
        case event
    }
    
    private var collectionView: UICollectionView! = nil
    private var dataSource: DataSource! = nil
    
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setNavigationItem()
        self.configureCollectionView()
        self.createCell()
        self.createHeaderView()
        self.initailSnapshot()
        self.subscribeViewModel()
        
        self.viewModel.fetchData()
    }
}

// MARK: CollectionView Delegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let infoViewController = ContentInfoViewController(viewModel: self.viewModel)
            infoViewController.modalPresentationStyle = .pageSheet
            
            if let sheet = infoViewController.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            
            present(infoViewController, animated: true, completion: nil)
            self.viewModel.selectContent(index: indexPath.row)
            
            return
        }
        
        let webViewController = WebViewController(viewModel: self.viewModel)
        present(webViewController, animated: false)
        
        if indexPath.section == 2 {
            self.viewModel.selectShopNotice(index: indexPath.row)
        } else if indexPath.section == 3 {
            self.viewModel.selectEvent(index: indexPath.row)
        }
    }
}

// MARK: Configure CollectionView
extension MainViewController {
    private func configureCollectionView() {
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: setSectionLayout())
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .systemGray6
        self.collectionView.register(
            CommonHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "Header"
        )
        
        view.addSubview(collectionView)
    }
    
    private func setSectionLayout() -> UICollectionViewLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let sectionKind = dataSource.sectionIdentifier(for: sectionIndex)
            
            switch sectionKind {
            case .calendar:
                return setCalendarLayout()
            case .characterBookmark:
                return setBookmarkLayout()
            case .shopNotice:
                return setShopNoticeLayout(environment: layoutEnvironment)
            case .event:
                return setEventLayout()
            case .none:
                return nil
            }
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 15
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: configuration)
    }
    
    private func setCalendarLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.22))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [self.getHeader()]
        
        return section
    }
    
    private func setBookmarkLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [self.getHeader()]
        
        return section
    }
    
    private func setShopNoticeLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: environment)
        section.boundarySupplementaryItems = [self.getHeader()]
        
        return section
    }
    
    private func setEventLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(0.22))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [self.getHeader()]
        
        return section
    }
    
    private func getHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.05))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        return header
    }
}

// MARK: Configure DataSource
extension MainViewController {
    private func createCell() {
        let calendarRegistration = createCalendarSectionCell()
        let shopNoticeRegistration = createShopNoticeSectionCell()
        let eventRegistration = createEventSectionCell()
        
        self.dataSource = DataSource(collectionView: self.collectionView) { (collectionView, indexPath, itemIdentifier) in
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
        
        self.viewModel.subscribeContents(on: self) { contents in
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
