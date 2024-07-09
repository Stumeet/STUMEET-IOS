//
//  DetailActivityPhotoListViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import Combine
import UIKit
import Photos

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
        return UILabel().setLabelProperty(text: nil, font: StumeetFont.captionMedium13.font, color: .gray400)
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
    
    private let coordinator: MyStudyGroupListNavigation
    private let viewModel: DetailActivityPhotoListViewModel
    private var datasource: UICollectionViewDiffableDataSource<Section, SectionItem>?
    
    // MARK: - Subject
    
    private let currentPageSubject = CurrentValueSubject<Int?, Never>(nil)
    private let snapshotUpdateSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Init
    
    init(coordinator: MyStudyGroupListNavigation, viewModel: DetailActivityPhotoListViewModel) {
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
    
    // MARK: - Bind
    
    override func bind() {
        configureDatasource()
        
        let input = DetailActivityPhotoListViewModel.Input(
            didTapXButton: xButton.tapPublisher.eraseToAnyPublisher(),
            currentPage: currentPageSubject.eraseToAnyPublisher(),
            didTapDownLoadButton: downloadButton.tapPublisher.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        // collectionview binding
        output.items
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateSnapshot)
            .store(in: &cancellables)
        
        // title binding
        output.title
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateTitleLabel)
            .store(in: &cancellables)
        
        // 선택한 이미지로 scroll
        snapshotUpdateSubject
            .combineLatest(output.firstItem)
            .map { ($1, UICollectionView.ScrollPosition.centeredHorizontally, false) }
            .receive(on: RunLoop.main)
            .sink(receiveValue: collectionView.scrollToItem)
            .store(in: &cancellables)
        
        output
            .checkPermission
            .receive(on: RunLoop.main)
            .sink(receiveValue: saveImage)
            .store(in: &cancellables)
        
        // dismiss
        output.dismiss
            .receive(on: RunLoop.main)
            .sink(receiveValue: coordinator.dismiss)
            .store(in: &cancellables)
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
        section.visibleItemsInvalidationHandler = { [weak self] (_, offset, env) in
            let currentPage = Int(max(0, round(offset.x / env.container.contentSize.width)))
            self?.currentPageSubject.send(currentPage)
        }
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
        datasource.apply(snapshot, animatingDifferences: true) {
            self.snapshotUpdateSubject.send()
        }
    }
}

// MARK: - UIUpdate

extension DetailActivityPhotoListViewController {
    private func updateTitleLabel(text: String) {
        let attributeText = NSMutableAttributedString(string: text)
        
        let firstCharacterRange = NSRange(location: 0, length: 1)
        attributeText.addAttribute(.foregroundColor, value: UIColor.white, range: firstCharacterRange)
        
        let sixthCharacterRange = NSRange(location: 5, length: 1)
        attributeText.addAttribute(.foregroundColor, value: UIColor.white, range: sixthCharacterRange)
        
        titleLabel.attributedText = attributeText
    }
}


// MARK: - Function

extension DetailActivityPhotoListViewController {
    private func saveImage(page: Int) {
        let indexPath = IndexPath(row: page, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) as? DetailActivityPhotoCell,
              let image = cell.imageView.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    }
}
