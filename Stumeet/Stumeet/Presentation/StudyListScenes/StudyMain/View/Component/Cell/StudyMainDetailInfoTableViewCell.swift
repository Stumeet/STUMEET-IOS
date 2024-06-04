//
//  StudyMainDetailInfoTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/05/23.
//

import UIKit
import SnapKit


class StudyMainDetailInfoTableViewCell: BaseTableViewCell {
    
    // MARK: - UIComponents
    private let rootVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = StumeetColor.gray600.color
        return label
    }()
    
    private lazy var tagListCollectionView: UICollectionView = {
        let flowLayout = LeftAlignedCollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInset = .init(top: tagListVerticalInset, left: .zero, bottom: tagListVerticalInset, right: .zero)
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerCell(StudyMainTagCollectionViewCell.self)
        return collectionView
    }()
    
    private let periodContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let periodContentHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    private let periodTitleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = UIColor(hex: "#9C9C9C")
        label.text = "진행 기간"
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = StumeetColor.gray800.color
        return label
    }()
    
    private let recurringScheduleContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let recurringScheduleContentHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    private let recurringScheduleTitleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = UIColor(hex: "#9C9C9C")
        label.text = "정기 모임"
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let recurringScheduleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = StumeetColor.gray800.color
        return label
    }()
    
    private let ruleContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let ruleContentVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let ruleTitleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = UIColor(hex: "#9C9C9C")
        label.text = "규칙"
        return label
    }()
    
    private let ruleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - Properties
    private var tagListDatasource: UICollectionViewDiffableDataSource<StudyMainTagSection, StudyMainTag>?
    private var tagListVerticalInset: CGFloat = 16
    private var tagListCellHeight: CGFloat = 27
    var onHeightChanged: (() -> Void)?
    
    // MARK: - Init
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .clear
        configureDatasource()
    }

    override func setupAddView() {
        contentView.addSubview(rootVStackView)
        
        [
            descriptionLabel,
            tagListCollectionView,
            periodContainerView,
            recurringScheduleContainerView,
            ruleContainerView
        ].forEach { rootVStackView.addArrangedSubview($0) }
        
        periodContainerView.addSubview(periodContentHStackView)
        recurringScheduleContainerView.addSubview(recurringScheduleContentHStackView)
        ruleContainerView.addSubview(ruleContentVStackView)
        
        [
            periodTitleLabel,
            periodLabel
        ].forEach { periodContentHStackView.addArrangedSubview($0) }
        
        [
            recurringScheduleTitleLabel,
            recurringScheduleLabel
        ].forEach { recurringScheduleContentHStackView.addArrangedSubview($0) }
        
        [
            ruleTitleLabel,
            ruleLabel
        ].forEach { ruleContentVStackView.addArrangedSubview($0) }
    }
    
    override func setupConstaints() {
        rootVStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        periodContainerView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        periodContentHStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        recurringScheduleContainerView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        recurringScheduleContentHStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        ruleContentVStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Function
    // TODO: API 연동 시 수정
    func configureCell() {
        descriptionLabel.text = "테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트테스트트테스트테스트트테스트테스트트테스트테스트트테스트테스트트테스트테스트트테스트테스트트테스트테스트트테스트테스트트테스트테스트트테스트테스트트테스트테스트트테스트테스트트테스트테스트트테스트테스트트테스트테스트트테스트테스트트테스트테스트트테스트테스트트"
        periodLabel.text = "2023.01.01 ~ 2023.01.01"
        recurringScheduleLabel.text = "매주 목요일 오전 9:00"
        ruleLabel.text = """
        - 📢 공지 확인 시 12시간 내에 답장
        
        - 공지 확인 후 ✅ 표시하기
        
        - ✏️ 팀 내 회의, 전체 회의 등 회의 시에는 회의록에 기록하기
        
        - 🗣 작업하다 모르는 내용 생기면 공유하고 서로 같이 고민하기
        """
        
        updateDatasource(datas: [
            StudyMainTag(id: 0, title: "서울"),
            StudyMainTag(id: 1, title: "#프로그래밍"),
            StudyMainTag(id: 2, title: "#프로그"),
            StudyMainTag(id: 3, title: "#프로그래밍"),
            StudyMainTag(id: 4, title: "#프"),
            StudyMainTag(id: 5, title: "#프로그래밍"),
            StudyMainTag(id: 6, title: "#프로그래밍" )
        ])
    }
    
    // MARK: - DataSource
    private func configureDatasource() {
        tagListDatasource = UICollectionViewDiffableDataSource(
            collectionView: tagListCollectionView,
            cellProvider: { collectionView, indexPath, item in
                guard let cell = collectionView.dequeue(StudyMainTagCollectionViewCell.self, for: indexPath)
                else { return UICollectionViewCell() }
                cell.configureCell(text: item.title)
                return cell
            })
    }
    
    private func updateDatasource(datas: [StudyMainTag]) {
        guard let datasource = tagListDatasource else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<StudyMainTagSection, StudyMainTag>()
        snapshot.appendSections([.main])
        snapshot.appendItems(datas)
        
        datasource.apply(snapshot, animatingDifferences: false) { [weak self] in
            DispatchQueue.main.async {
                self?.updateCollectionViewLayout()
            }
        }
    }
    
    private func updateCollectionViewLayout() {
        let contentHeight = tagListCollectionView.contentSize.height + tagListVerticalInset * 2

        tagListCollectionView.snp.remakeConstraints {
            $0.height.equalTo(contentHeight)
        }
        onHeightChanged?()
    }
}

extension StudyMainDetailInfoTableViewCell:
    UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = tagListDatasource?.itemIdentifier(for: indexPath) else {
            return StudyMainTagCollectionViewCell.fittingSize(availableHeight: tagListCellHeight, config: " ")
        }
        
        return StudyMainTagCollectionViewCell.fittingSize(availableHeight: tagListCellHeight, config: item.title)
    }
}
