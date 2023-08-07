//
//  ContentInfoViewController.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/28.
//

import UIKit

class ContentInfoViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, RewardItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, RewardItem>
    
    enum Section: CaseIterable {
        case main
    }
    
    private let viewModel: MainViewModel
    
    private let infoView = ContentInfoView()
    private var dataSource: DataSource!
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = infoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeViewModel()
        configureDataSource()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.viewModel.unsubscribeContent(on: self)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<HStackImageLabelCell, RewardItem>.init { cell, indexPath, itemIdentifier in
            guard let url = URL(string: itemIdentifier.icon) else { return }
            
            ImageLoader.shared.fetch(url) { image in
                cell.setContent(name: itemIdentifier.name, image: image)
            }
        }
        
        dataSource = DataSource(collectionView: self.infoView.rewardCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        })
    }
    
    private func subscribeViewModel() {
        var snapshot = Snapshot()
        
        self.viewModel.subscribeContent(on: self) { content in
            guard let content = content else { return }
            self.infoView.setContent(name: content.contentsName)

            DispatchQueue.main.async {
                snapshot.appendSections(Section.allCases)
                snapshot.appendItems(content.rewardItems, toSection: .main)
                self.dataSource.apply(snapshot)
            }
        }
    }
}

class ContentInfoView: UIView {
    private let contentNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let rewardCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .systemCyan
        collectionView.layer.cornerRadius = 10
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview()
        setLayout()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent(name: String) {
        self.contentNameLabel.text = name
    }
    
    private func addSubview() {
        addSubview(self.contentNameLabel)
        addSubview(self.rewardCollectionView)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            self.contentNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            self.contentNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            self.rewardCollectionView.topAnchor.constraint(equalTo: self.contentNameLabel.bottomAnchor, constant: 20),
            self.rewardCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            self.rewardCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            self.rewardCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func configureCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .flexible(10)
        
        let section = NSCollectionLayoutSection(group: group)
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        self.rewardCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section, configuration: configuration)
    }
}
