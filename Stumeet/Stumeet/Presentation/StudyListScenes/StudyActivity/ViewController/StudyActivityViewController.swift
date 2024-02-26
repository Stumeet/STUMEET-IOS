//
//  StudyActivityViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/22/24.
//

import UIKit

class StudyActivityViewController: BaseViewController {

    // MARK: - UIComponents
    
    private lazy var allCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createAllLayout(type: .all(nil)))
        collectionView.register(StudyActivityAllCell.self, forCellWithReuseIdentifier: StudyActivityAllCell.identifier)
        collectionView.register(
            StudyActivityHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: StudyActivityHeaderView.identifier)
        collectionView.backgroundColor = StumeetColor.primary50.color
        
        return collectionView
    }()
    
    private let floatingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = StumeetColor.primaryInfo.color
        button.layer.cornerRadius = 36
        
        return button
    }()
    
    // MARK: - Properties
    
    var datasource: UICollectionViewDiffableDataSource<StudyActivitySection, StudyActivityItem>?

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatasource()
    }
    
    // MARK: - SetUp
    
    override func setupStyles() {
        view.backgroundColor = .white
    }
    
    override func setupAddView() {
        [
            allCollectionView,
            floatingButton
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        
        allCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(48)
            make.width.height.equalTo(72)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        var currentType: [StudyActivityItem] = []
        Activity.allData.forEach {
            currentType.append(.all($0))
        }
        
        currentType.publisher
            .receive(on: RunLoop.main)
            .sink { [weak self] item in
                guard let self = self, let datasource = self.datasource else { return }

                var snapshot = NSDiffableDataSourceSnapshot<StudyActivitySection, StudyActivityItem>()
                snapshot.appendSections([.main])
                
                switch item {
                case .all:
                    snapshot.appendItems(currentType, toSection: .main)
                    allCollectionView.setCollectionViewLayout(createAllLayout(type: .all(nil)), animated: true)
                default: break
                }
                
                datasource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - DataSource

extension StudyActivityViewController {
    func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: allCollectionView, cellProvider: { collectionView, indexPath, item in
            
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StudyActivityAllCell.identifier,
                for: indexPath) as? StudyActivityAllCell else { return UICollectionViewCell() }
            
            switch item {
            case .all(let item):
                cell.configureAllUI(item: item!)
            case .group(let item):
                cell.configureGroupUI(item: item!)
            case .task(let item):
                cell.configureTaskUI(item: item!)
            }
            
            return cell
        })
        
        datasource?.supplementaryViewProvider = { collectionview, _, indexPath in
            guard let header = collectionview.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: StudyActivityHeaderView.identifier,
                for: indexPath) as? StudyActivityHeaderView else { return UICollectionReusableView() }
            
            return header
        }
    }
}

// MARK: ConfigureLayout

extension StudyActivityViewController {
    private func createAllLayout(type: StudyActivityItem) -> UICollectionViewCompositionalLayout {
        switch type {
        case .all:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(156))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(156))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(56))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize
                , elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
            section.boundarySupplementaryItems = [sectionHeader]

            section.interGroupSpacing = 24
            let layout = UICollectionViewCompositionalLayout(section: section)
            
            return layout
            
        case .group, .task:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(91))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(91))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(56))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize
                , elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [sectionHeader]
            
            let layout = UICollectionViewCompositionalLayout(section: section)
            
            return layout
        }
    }
}
