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
    
    // FIXME: - repository로 옮기기
    let fields = [
        StudyField(name: "어학", isSelected: false),
        StudyField(name: "취업", isSelected: false),
        StudyField(name: "자격증", isSelected: false),
        StudyField(name: "고시/공무원", isSelected: false),
        StudyField(name: "취미/교양", isSelected: false),
        StudyField(name: "프로그래밍", isSelected: false),
        StudyField(name: "재테크/경제", isSelected: false),
        StudyField(name: "수능", isSelected: false),
        StudyField(name: "독서", isSelected: false),
        StudyField(name: "자율", isSelected: false)
    ]
    
    // MARK: - Init
    
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
        Just(fields)
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateSnapshot)
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
                cell.tagLabel.text = item.name
                
                return cell
            }
        })
    }
    
    private func updateSnapshot(item: [StudyField]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshot.appendSections([.main])
        item.forEach { snapshot.appendItems([.fieldCell($0)]) }
        
        guard let datasource = self.datasource else { return }
        datasource.apply(snapshot, animatingDifferences: true)
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
