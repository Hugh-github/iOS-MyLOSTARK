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
    private var snapshot = Snapshot()
    private let director = CollectionLayoutDirector()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.execute(.viewWillAppear)
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
                return self.director.getCalendarLayout()
            case .characterBookmark:
                return self.director.getBookmarkLayout()
            case .characterPlaceholder:
                return self.director.getPlaceHolderLayout()
            case .notice:
                return self.director.getShopNoticeLayout(environment: layoutEnvironment)
            case .event:
                return self.director.getEventLayout()
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
        snapshot.appendSections([.calendar, .characterPlaceholder, .notice, .event])
        
        self.dataSource.apply(snapshot)
    }
    
    private func dataBinding() {
        self.viewModel.contents.addObserver(on: self, applyCalendarSnapshot())
        self.viewModel.notices.addObserver(on: self, applyNoticeSnapshot())
        self.viewModel.events.addObserver(on: self, applyEventSnapshot())
        self.viewModel.bookmark.addObserver(on: self, applyBookmarkSanpshot())
    }
    
    private func applyCalendarSnapshot() -> (([Contents]) -> Void) {
        return { [weak self] contents in
            guard let self = self else { return }

            snapshot.appendItems(contents, toSection: .calendar)
            self.dataSource.apply(snapshot)
        }
    }
    
    private func applyNoticeSnapshot() -> (([Notice]) -> Void) {
        return { [weak self] notices in
            guard let self = self else { return }
            
            snapshot.appendItems(notices, toSection: .notice)
            self.dataSource.apply(snapshot)
        }
    }
    
    private func applyEventSnapshot() -> (([Event]) -> Void) {
        return { [weak self] events in
            guard let self = self else { return }
            snapshot.appendItems(events, toSection: .event)
            self.dataSource.apply(snapshot)
        }
    }
    
    private func applyBookmarkSanpshot() -> (([CharacterBookmark]?) -> Void) {
        return { [weak self] bookmarks in
            guard let bookmarks = bookmarks,
                  let self = self else { return }
            
            if bookmarks.isEmpty {
                if snapshot.sectionIdentifiers.contains(.characterBookmark) {
                    snapshot.deleteSections([.characterBookmark])
                    snapshot.insertSections([.characterPlaceholder], afterSection: .calendar)
                } else {
                    snapshot.deleteItems(in: .characterPlaceholder)
                }
                
                snapshot.appendItems([CharacterBookmark(jobClass: "", itemLevel: "", name: "")], toSection: .characterPlaceholder)
                self.dataSource.apply(snapshot)
            } else {
                if snapshot.sectionIdentifiers.contains(.characterPlaceholder) {
                    snapshot.deleteSections([.characterPlaceholder])
                    snapshot.insertSections([.characterBookmark], afterSection: .calendar)
                } else {
                    snapshot.deleteItems(in: .characterBookmark)
                }
                snapshot.appendItems(bookmarks, toSection: .characterBookmark)
                self.dataSource.apply(snapshot)
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

extension NSDiffableDataSourceSnapshot {
    mutating func deleteItems(in section: SectionIdentifierType) {
        let itemIdentifier = itemIdentifiers(inSection: section)
        deleteItems(itemIdentifier)
    }
}
