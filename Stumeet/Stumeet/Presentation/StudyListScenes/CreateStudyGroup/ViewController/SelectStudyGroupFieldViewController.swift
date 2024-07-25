//
//  SelectStudyGroupFieldViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 7/25/24.
//

import Combine
import UIKit

final class SelectStudyGroupFieldViewController: BaseViewController {
    
    typealias Section = StudyFieldSection
    typealias SectionItem = StudyFieldSectionItem
    
    // MARK: - UIComponents
    
    private let titleLabel = UILabel().setLabelProperty(text: "분야를 선택해주세요", font: StumeetFont.titleMedium.font, color: .gray800)
    
    private lazy var fieldCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.registerCell(TagCell.self)
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton().makeRegisterBottomButton(text: "완료", color: StumeetColor.gray200.color)
        button.isEnabled = false
        
        return button
    }()
    
    // MARK: - Properties
    private var datasource: UICollectionViewDiffableDataSource<Section, SectionItem>?
    private let coordinator: CreateStudyGroupNavigation
    private let viewModel: SelectStudyGroupFieldViewModel
    
    // MARK: - Init
    
    init(coordinator: CreateStudyGroupNavigation, viewModel: SelectStudyGroupFieldViewModel) {
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
        view.backgroundColor = .white
        configureBackButtonTitleNavigationBarItems(title: "분야 선택")
        configureDatasource()
    }
    
    override func setupAddView() {
        [
            titleLabel,
            fieldCollectionView,
            completeButton
        ]   .forEach(view.addSubview)
    }
    
    override func setupConstaints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.equalToSuperview().inset(24)
        }
        
        fieldCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
            make.height.equalTo(72)
        }
    }
    
    override func bind() {
        
        let input = SelectStudyGroupFieldViewModel.Input(
            didSelectedField: fieldCollectionView.didSelectItemPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.items
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateSnapshot)
            .store(in: &cancellables)
        
        output.isEnableCompleteButton
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateCompleteButton)
            .store(in: &cancellables)
    }
}

// MARK: - Datasource

extension SelectStudyGroupFieldViewController {
    
    private func configureDatasource() {
        datasource = UICollectionViewDiffableDataSource(collectionView: fieldCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .fieldCell(let item):
                guard let cell = collectionView.dequeue(TagCell.self, for: indexPath) else { return UICollectionViewCell() }
                cell.configureTagCell(item: item)
                
                return cell
            }
        })
    }
    
    private func updateSnapshot(items: [SectionItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        guard let datasource = self.datasource else { return }
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(60), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - UIUpdate

extension SelectStudyGroupFieldViewController {
    func updateCompleteButton(isEnable: Bool) {
        completeButton.isEnabled = isEnable
        completeButton.backgroundColor = isEnable ? StumeetColor.primary700.color : StumeetColor.gray200.color
    }
}
