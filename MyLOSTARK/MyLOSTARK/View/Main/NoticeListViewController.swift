//
//  NoticeListViewController.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/08/07.
//

import UIKit

final class NoticeListViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<NoticeSection, AnyHashable>
    
    enum NoticeSection: CaseIterable {
        case update
        case check
        case shop
    }
    
    private var collectionView: UICollectionView! = nil
    private var dataSource: DataSource! = nil
        
    private let viewModel = NoticeViewModel()
    
    override func viewDidLoad() {
        navigationItem.title = "업데이트 내역"
        view.backgroundColor = .white
        
        self.configureCollectionView()
        self.configureDataSource()
        self.initialSnapshot()
        self.subscribeViewModel()
        
        self.viewModel.execute(.viewDidLoad)
    }
}

extension NoticeListViewController {
    private func configureCollectionView() {
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        self.collectionView.delegate = self
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.register(
            CommonHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CommonHeaderView.reuseIdentifier
        )
        
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout.init { sectionIndex, layoutEnvironment in
            let config = UICollectionLayoutListConfiguration(appearance: .sidebar)
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            
            return section
        }
    }
}

extension NoticeListViewController {
    private func configureDataSource() {
        let cellRegistration = createCellRegistration()
        let headerCellRegistration = createHeaderCellRegistration()
 
        self.dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            if let item = itemIdentifier as? String {
                return collectionView.dequeueConfiguredReusableCell(
                    using: headerCellRegistration,
                    for: indexPath,
                    item: item
                )
            } else {
                return collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: itemIdentifier as? Notice
                )
            }
        }
    }
    
    private func createCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Notice> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            var content = cell.defaultContentConfiguration()
            content.text = itemIdentifier.title
            cell.contentConfiguration = content
        }
    }
    
    private func createHeaderCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, String> {
        return UICollectionView.CellRegistration { cell, indexPath, title in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = title
            contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.contentConfiguration = contentConfiguration
            
            let disclosureOptions = UICellAccessory.OutlineDisclosureOptions(style: .header, tintColor: .systemBlue)
            cell.accessories = [.outlineDisclosure(options: disclosureOptions)]
        }
    }
}

extension NoticeListViewController {
    private func initialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<NoticeSection, AnyHashable>()
        snapshot.appendSections(NoticeSection.allCases)
        
        self.dataSource.apply(snapshot)
    }
    
    private func subscribeViewModel() {
        self.viewModel.updateNotices.addObserver(on: self, applyUpdateSnapshot())
        self.viewModel.checkNotices.addObserver(on: self, applyCheckSnapshot())
        self.viewModel.shopNotices.addObserver(on: self, applyShopSnapshot())
    }
    
    private func applyUpdateSnapshot() -> (([Notice]) -> Void) {
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        
        return { notices in
            sectionSnapshot.append(["공지"])
            sectionSnapshot.append(notices, to: "공지")
            self.dataSource.apply(sectionSnapshot, to: .update)
        }
    }
    
    private func applyCheckSnapshot() -> (([Notice]) -> Void) {
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        
        return { notices in
            sectionSnapshot.append(["점검"])
            sectionSnapshot.append(notices, to: "점검")
            self.dataSource.apply(sectionSnapshot, to: .check)
        }
    }
    
    private func applyShopSnapshot() -> (([Notice]) -> Void) {
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        
        return { notices in
            sectionSnapshot.append(["상점"])
            sectionSnapshot.append(notices, to: "상점")
            self.dataSource.apply(sectionSnapshot, to: .shop)
        }
    }
}

extension NoticeListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = self.dataSource.sectionIdentifier(for: indexPath.section)

        let webViewController = WebViewController(viewModel: self.viewModel)
        present(webViewController, animated: true)

        switch section {
        case .update:
            self.viewModel.execute(.selectUpdateCell(indexPath.row))
        case .check:
            self.viewModel.execute(.selectCheckCell(indexPath.row))
        case .shop:
            self.viewModel.execute(.selectShopCell(indexPath.row))
        case .none:
            break
        }
    }
}
