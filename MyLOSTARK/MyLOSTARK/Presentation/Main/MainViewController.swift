//
//  ViewController.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/14.
//

import UIKit

final class MainViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<MainViewSection, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MainViewSection, AnyHashable>
    
    enum MainViewSection: CaseIterable {
        case calendar
        case characterBookmark
        case characterPlaceholder
        case notice
        case event
        
        var headerTitle: String {
            switch self {
            case .calendar:
                return "모험 섬"
            case .characterBookmark:
                return "즐겨찾는 캐릭터"
            case .characterPlaceholder:
                return "즐겨찾는 캐릭터"
            case .notice:
                return "공지 사항"
            case .event:
                return "Event"
            }
        }
    }
    
    private var collectionView: UICollectionView! = nil
    private var dataSource: DataSource! = nil
    private let collectionViewLayoutBuilder = CollectionViewLayoutBuilder()
    
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.setNavigationItem()
        self.configureCollectionView()
        self.configureDataSource()
        self.configureSupplementaryView()
        self.initialSnapshot()
        self.dataBinding()
        
        self.viewModel.execute(.viewDidLoad)
    }
}

// MARK: BookmarkCell Delegate
extension MainViewController: BookmarkCellDelegate {
    func didTabBookmarkButton(cell: BookmarkCell) {
        guard let index = self.collectionView.indexPath(for: cell) else { return }
        self.viewModel.execute(.unRegistCharacter(index.row))
    }
}

// MARK: CollectionView Delegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionId = self.dataSource.sectionIdentifier(for: indexPath.section)
        
        switch sectionId {
        case .calendar:
            self.presentContentView(indexPath.row)
        case .characterBookmark:
            return
        case .notice:
            self.presentWebView(.all, index: indexPath.row)
        case .event:
            self.presentWebView(.event, index: indexPath.row)
        default:
            return
        }
    }
    
    private func presentContentView(_ index: Int) {
        let infoViewController = ContentInfoViewController(viewModel: self.viewModel, indexPath: index)
        
        infoViewController.modalPresentationStyle = .pageSheet
        
        if let sheet = infoViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        present(infoViewController, animated: true, completion: nil)
    }
    
    private func presentWebView(_ link: LinkCase, index: Int) {
        let webViewController = WebViewController(
            viewModel: self.viewModel,
            linkCase: link,
            index: index
        )
        webViewController.delegate = viewModel
        present(webViewController, animated: false)
    }
}

// MARK: Configure CollectionView
extension MainViewController {
    private func configureCollectionView() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: setSectionLayout())
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .systemGray6
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.register(
            CommonHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CommonHeaderView.reuseIdentifier
        )
        self.collectionView.register(
            ButtonFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: ButtonFooterView.reuseIdentifier
        )
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
            case .characterPlaceholder:
                return setPlaceholderLayout()
            case .notice:
                return setShopNoticeLayout(environment: layoutEnvironment)
            case .event:
                return setEventLayout()
            case .none:
                return nil
            }
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: configuration)
        layout.register(SectionBackgroundView.self, forDecorationViewOfKind: SectionBackgroundView.reuseIdentifier)
        
        return layout
    }
    
    private func setCalendarLayout() -> NSCollectionLayoutSection? {
        let section = collectionViewLayoutBuilder
            .setItem(width: .fractionalWidth(0.33), height: .fractionalHeight(1.0))
            .setGroup(width: .fractionalWidth(1.0), height: .fractionalHeight(0.26), direction: .horizontal)
            .getSectionLayout()
        section?.boundarySupplementaryItems = [self.createHeader()]
        
        return section
    }
    
    private func setBookmarkLayout() -> NSCollectionLayoutSection? {
        let section = collectionViewLayoutBuilder
            .setItem(width: .fractionalWidth(0.3), height: .fractionalHeight(1.0))
            .setGroup(width: .fractionalWidth(1.0), height: .fractionalHeight(0.26), direction: .horizontal)
            .setItemSpacing(10)
            .setGroupInset(top: 10, leading: 10, bottom: 10, trailing: 10)
            .getSectionLayout()
        
        section?.setScrollingBehavior(.continuous)
        section?.boundarySupplementaryItems = [self.createHeader()]
        section?.decorationItems = [
            NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.reuseIdentifier)
        ]
        
        return section
    }
    
    private func setPlaceholderLayout() -> NSCollectionLayoutSection? {
        let section = collectionViewLayoutBuilder
            .setItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
            .setGroup(width: .fractionalWidth(1.0), height: .fractionalHeight(0.19), direction: .horizontal)
            .getSectionLayout()
        
        section?.boundarySupplementaryItems = [self.createHeader(), self.createFooter()]
        section?.decorationItems = [
            NSCollectionLayoutDecorationItem.background(elementKind: SectionBackgroundView.reuseIdentifier)
        ]
        
        return section
    }
    
    private func setShopNoticeLayout(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        let section = NSCollectionLayoutSection.list(using: listConfiguration, layoutEnvironment: environment)
        section.boundarySupplementaryItems = [self.createHeader(), self.createFooter()]
        
        return section
    }
    
    private func setEventLayout() -> NSCollectionLayoutSection? {
        let section = collectionViewLayoutBuilder
            .setItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
            .setGroup(width: .fractionalWidth(0.8), height: .fractionalHeight(0.28), direction: .horizontal)
            .getSectionLayout()
        
        section?.setScrollingBehavior(.groupPaging)
        section?.boundarySupplementaryItems = [self.createHeader()]
        
        return section
    }
    
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.07))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        return header
    }
    
    private func createFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.07))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        return footer
    }
}

// MARK: Configure DataSource
extension MainViewController {
    private func configureDataSource() {
        let calendarRegistration = createCalendarSectionCell()
        let shopNoticeRegistration = createShopNoticeSectionCell()
        let eventRegistration = createEventSectionCell()
        let bookmarkRegistration = createBookmarkSectionCell()
        let placeholderRegistration = createPlaceholderSectionCell()
        
        self.dataSource = DataSource(collectionView: self.collectionView) { (collectionView, indexPath, itemIdentifier) in
            let sectionIdentifier = self.dataSource.sectionIdentifier(for: indexPath.section)
            
            switch sectionIdentifier {
            case .calendar:
                return collectionView.dequeueConfiguredReusableCell(
                    using: calendarRegistration,
                    for: indexPath,
                    item: itemIdentifier as? Contents
                )
            case .characterBookmark:
                return collectionView.dequeueConfiguredReusableCell(
                    using: bookmarkRegistration,
                    for: indexPath,
                    item: itemIdentifier as? CharacterBookmark
                )
            case .characterPlaceholder:
                return collectionView.dequeueConfiguredReusableCell(
                    using: placeholderRegistration,
                    for: indexPath,
                    item: itemIdentifier as? CharacterBookmark
                )
            case .notice:
                return collectionView.dequeueConfiguredReusableCell(
                    using: shopNoticeRegistration,
                    for: indexPath,
                    item: itemIdentifier as? Notice
                )
            case .event:
                return collectionView.dequeueConfiguredReusableCell(
                    using: eventRegistration,
                    for: indexPath,
                    item: itemIdentifier as? Event
                )
            case .none:
                return UICollectionViewCell()
            }
        }
    }
    
    private func configureSupplementaryView() {
        self.dataSource.supplementaryViewProvider = { [self] (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            let section = self.dataSource.sectionIdentifier(for: indexPath.section)
            
            if elementKind == UICollectionView.elementKindSectionHeader {
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: CommonHeaderView.reuseIdentifier,
                    for: indexPath
                ) as? CommonHeaderView else {
                    return nil
                }
                
                switch section {
                case .calendar:
                    header.configureHeader(title: section?.headerTitle)
                case .characterBookmark:
                    header.configureHeader(title: section?.headerTitle)
                case .characterPlaceholder:
                    header.configureHeader(title: section?.headerTitle)
                case .notice:
                    header.configureHeader(title: section?.headerTitle)
                case .event:
                    header.configureHeader(title: section?.headerTitle, color: .darkGray)
                case .none:
                    break
                }
                
                return header
            } else {
                guard let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: ButtonFooterView.reuseIdentifier,
                    for: indexPath
                ) as? ButtonFooterView else {
                    return nil
                }
                
                switch section {
                case .characterPlaceholder:
                    footer.setTitle("추가하기 +")
                    footer.button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
                case .notice:
                    footer.setTitle("모두 보기")
                    footer.button.addTarget(self, action: #selector(didTapViewAllButton), for: .touchUpInside)
                default:
                    break
                }
                
                return footer
            }
        }
    }
    
    @objc private func didTapAddButton() {
        tabBarController?.selectedIndex = 1
    }
    
    @objc private func didTapViewAllButton() {
        let noticeViewController = NoticeListViewController()
        navigationController?.pushViewController(noticeViewController, animated: true)
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
    
    private func createBookmarkSectionCell() -> UICollectionView.CellRegistration<BookmarkCell, CharacterBookmark> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.setContent(
                image: UIImage(named: itemIdentifier.jobClass),
                level: String(itemIdentifier.itemLevel),
                name: itemIdentifier.name
            )
            cell.delegate = self
            cell.bookmarkButton.isSelected = true
            cell.backgroundColor = .white
        }
    }
    
    private func createPlaceholderSectionCell() -> UICollectionView.CellRegistration<BookmarkPlaceholderCell, CharacterBookmark> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.setContent(
                image: UIImage(named: "placeholder"),
                text: "등록된 캐릭터가 없습니다."
            )
            cell.backgroundColor = .white
        }
    }
    
    private func createShopNoticeSectionCell() -> UICollectionView.CellRegistration<UICollectionViewListCell, Notice> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = itemIdentifier.title
            cell.contentConfiguration = configuration
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
}

// MARK: Snapshot
extension MainViewController {
    private func initialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(MainViewSection.allCases)
        
        self.dataSource.apply(snapshot)
    }
    
    private func dataBinding() {
        self.viewModel.contents.addObserver(on: self, applyCalendarSnapshot())
        self.viewModel.notices.addObserver(on: self, applyNoticeSnapshot())
        self.viewModel.events.addObserver(on: self, applyEventSnapshot())
        self.viewModel.bookmark.addObserver(on: self, applyBookmarkSanpshot())
    }
    
    private func applyCalendarSnapshot() -> (([Contents]) -> Void) {
        return { contents in
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
            sectionSnapshot.append(contents)
            self.dataSource.apply(sectionSnapshot, to: .calendar)
        }
    }
    
    private func applyNoticeSnapshot() -> (([Notice]) -> Void) {
        return { notices in
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
            sectionSnapshot.append(notices)
            self.dataSource.apply(sectionSnapshot, to: .notice)
        }
    }
    
    private func applyEventSnapshot() -> (([Event]) -> Void) {
        return { events in
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
            sectionSnapshot.append(events)
            self.dataSource.apply(sectionSnapshot, to: .event)
        }
    }
    
    private func applyBookmarkSanpshot() -> (([CharacterBookmark]?) -> Void) {
        var snapshot = self.dataSource.snapshot()

        return { bookmarks in
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
            guard let bookmarks = bookmarks else { return }

            if bookmarks.isEmpty {
                snapshot.deleteSections([.characterBookmark])
                self.dataSource.apply(snapshot)
                sectionSnapshot.append([CharacterBookmark(jobClass: "placeholder", itemLevel: "0", name: "없음")])
                self.dataSource.apply(sectionSnapshot, to: .characterPlaceholder)
            } else {
                snapshot.deleteSections([.characterPlaceholder])
                self.dataSource.apply(snapshot)
                sectionSnapshot.append(bookmarks)
                self.dataSource.apply(sectionSnapshot, to: .characterBookmark)
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
    }
}
