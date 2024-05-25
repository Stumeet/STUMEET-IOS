//
//  DetailActivityPhotoListViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import Foundation
import UIKit

final class DetailActivityPhotoListViewController: BaseViewController {
    
    typealias Section = DetailActivityPhotoSection
    typealias SectionItem = DetailActivityPhotoSectionItem
    
    // MARK: - UIComponents
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.8)
        
        return view
    }()
    
    private let xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .xMark).withTintColor(.white), for: .normal)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        UILabel().setLabelProperty(text: "5장 중 1번", font: StumeetFont.captionMedium13.font, color: .gray400)
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .downloadButton), for: .normal)
        
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(DetailActivityPhotoCell.self, forCellWithReuseIdentifier: DetailActivityPhotoCell.identifier)
        collectionView.backgroundColor = .black
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: - Properties
    
    private let coordinator: StudyListNavigation
    private let viewModel: DetailActivityPhotoListViewModel
    private var datasource: UICollectionViewDiffableDataSource<Section, SectionItem>?
    
    // MARK: - Init
    
    init(coordinator: StudyListNavigation, viewModel: DetailActivityPhotoListViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - SetUp
    
    override func setupStyles() {
    }
    
    override func setupAddView() {
        
        [
            xButton,
            titleLabel,
            downloadButton
        ]   .forEach(topView.addSubview)
        
        [
            collectionView,
            topView
        ]   .forEach(view.addSubview)
        
    }
    
    override func setupConstaints() {
        
        topView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(107)
        }
        
        xButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(71)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(xButton)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(xButton)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func bind() {
        configureDatasource()
        let items: [SectionItem] = [
            .photoCell("1"),
            .photoCell("2"),
            .photoCell("3"),
            .photoCell("4")
        ]
        
        updateSnapshot(items: items)
    }
}

// MARK: - CollectionViewLayout

extension DetailActivityPhotoListViewController {
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
    
        return layout
    }
}


// MARK: - Datasource

extension DetailActivityPhotoListViewController {
    
    private func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .photoCell(let imageURL):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DetailActivityPhotoCell.identifier,
                    for: indexPath) as? DetailActivityPhotoCell
                else { return UICollectionViewCell() }
                
                return cell
            }
        })
    }
    
    private func updateSnapshot(items: [SectionItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        guard let datasource = self.datasource else { return }
        datasource.apply(snapshot, animatingDifferences: true)
    }
}
