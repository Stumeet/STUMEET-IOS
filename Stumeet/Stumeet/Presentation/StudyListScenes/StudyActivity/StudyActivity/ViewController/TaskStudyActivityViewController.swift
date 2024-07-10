//
//  TaskStudyActivityViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 6/8/24.
//

import UIKit

final class TaskStudyActivityViewController: BaseViewController {
    
    typealias Section = StudyActivitySection
    typealias SectionItem = StudyActivitySectionItem
    
    // MARK: - UIComponents
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(StudyActivityCell.self, forCellWithReuseIdentifier: StudyActivityCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isHidden = true
        
        return collectionView
    }()
    
    private let emptyView = StudyActivityEmptyView()
    
    // MARK: - Properties
    
    private var datasource: UICollectionViewDiffableDataSource<Section, SectionItem>?
    private let viewModel: TaskStudyActivityViewModel
    private let coordinator: StudyListNavigation
    
    // MARK: - Init
    
    init(viewModel: TaskStudyActivityViewModel, coordinator: StudyListNavigation) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDatasource()
    }
    
    override func setupStyles() {
        
    }
    
    override func setupAddView() {
        [
            collectionView,
            emptyView
        ]   .forEach(view.addSubview)
    }
    
    override func setupConstaints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    override func bind() {
        let input = TaskStudyActivityViewModel.Input(
            reachedCollectionViewBottom: collectionView.reachedBottomPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.items
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateSnapshot)
            .store(in: &cancellables)
        
        output.isEmptyItems
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink(receiveValue: switchHiddenEmptyView)
            .store(in: &cancellables)
    }
}

// MARK: - Datasource

extension TaskStudyActivityViewController {
    private func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StudyActivityCell.identifier,
                for: indexPath) as? StudyActivityCell else { return UICollectionViewCell() }
            
            switch item {
            case .task(let item):
                cell.configureTaskUI(item: item)
                
            default: break
            }
            
            return cell
        })
    }
    
    private func updateSnapshot(items: [StudyActivitySectionItem]) {
        guard let datasource = self.datasource else { return }
        var snapshot = NSDiffableDataSourceSnapshot<StudyActivitySection, StudyActivitySectionItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        datasource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Layout

extension TaskStudyActivityViewController {
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(91))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(91))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}


extension TaskStudyActivityViewController {
    private func switchHiddenEmptyView(isEmpty: Bool) {
        collectionView.isHidden = isEmpty
        emptyView.isHidden = !isEmpty
    }
}
