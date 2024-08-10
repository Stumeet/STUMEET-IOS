//
//  SelectStudyRepeatViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 8/10/24.
//

import UIKit

protocol SelectStudyRepeatDelegate: AnyObject {
    func didTapCompleteButton(repeatType: String, repeatDates: [String])
}

final class SelectStudyRepeatViewController: BaseViewController {
    
    // MARK: - UIComponents
    
    private let backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.alpha = 0
        
        return button
    }()
    
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        return view
    }()
    
    private let dragIndicatorContainerView = UIView()
    
    private let dragIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1)
        view.layer.cornerRadius = 7
        return view
        
    }()
    
    private let repeatTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 9
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var dailyButton = makeRepeatTypeButton(text: "매일")
    private lazy var weeklyButton = makeRepeatTypeButton(text: "매주")
    private lazy var monthlyButton = makeRepeatTypeButton(text: "매월")
    
    
    private var weeklyButtons: [UIButton] = []
    
    private lazy var weeklyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.isHidden = true
        
        let titles = ["월", "화", "수", "목", "금", "토", "일"]
        
        for title in titles {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(StumeetColor.gray400.color, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.titleLabel?.font = StumeetFont.bodyMedium14.font
            button.backgroundColor = StumeetColor.gray75.color
            button.layer.cornerRadius = 8
            
            weeklyButtons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        return stackView
    }()
    
    private lazy var monthlyCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.registerCell(UICollectionViewCell.self)
        collectionView.isScrollEnabled = false
        collectionView.isHidden = true
        
        return collectionView
    }()
    
    private let lastDayExplainLabel: UILabel = {
        let label = UILabel().setLabelProperty(text: "!마지막 날을 선택하면 매 달의 마지막 날에 반복돼요.", font: StumeetFont.captionMedium13.font, color: .warning500)
        
        label.isHidden = true
        
        return label
    }()

    
    private let completeButton = UIButton().makeRegisterBottomButton(text: "완료", color: StumeetColor.gray200.color)
    
    // MARK: - Properties
    
    weak var delegate: SelectStudyRepeatDelegate?
    
    // MARK: - Init
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showBottomSheet()
    }
    
    // MARK: - SetUp
    
    override func setupStyles() {
        
    }
    
    override func setupAddView() {
        [
            dragIndicatorView
        ]   .forEach { dragIndicatorContainerView.addSubview($0) }
        
        [
            dailyButton,
            weeklyButton,
            monthlyButton
        ]   .forEach(repeatTypeStackView.addArrangedSubview)
        
        [
            dragIndicatorContainerView,
            repeatTypeStackView,
            weeklyStackView,
            monthlyCollectionView,
            lastDayExplainLabel,
            completeButton
        ]   .forEach { bottomSheetView.addSubview($0) }
        
        [
            backgroundButton,
            bottomSheetView
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        backgroundButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalToSuperview()
        }
        
        dragIndicatorContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(24)
            make.height.equalTo(30)
            make.width.equalTo(72)
        }
        
        dragIndicatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(8)
        }
        
        repeatTypeStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(51)
            make.top.equalTo(dragIndicatorView.snp.bottom).offset(24)
        }
        
        weeklyStackView.snp.makeConstraints { make in
            make.top.equalTo(repeatTypeStackView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(328)
        }
        
        monthlyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(repeatTypeStackView.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
            make.height.equalTo(232)
        }
        
        lastDayExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(monthlyCollectionView.snp.bottom).offset(8)
            make.leading.equalTo(monthlyCollectionView.snp.leading).offset(-4)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(repeatTypeStackView.snp.bottom).offset(32)
            make.height.equalTo(72)
        }
    }
    
    override func bind() {
        
    }
}

// MARK: - ConfigureUI

extension SelectStudyRepeatViewController {
    private func makeRepeatTypeButton(text: String) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(StumeetColor.gray400.color, for: .normal)
        button.setTitleColor(StumeetColor.primary700.color, for: .selected)
        button.layer.borderWidth = 1
        button.layer.borderColor = StumeetColor.gray75.color.cgColor
        button.layer.cornerRadius = 16
        button.titleLabel?.font = StumeetFont.bodyMedium15.font
        
        return button
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(40), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

// MARK: - UpdateUI

extension SelectStudyRepeatViewController {
    private func showBottomSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetView.snp.updateConstraints { make in
                make.height.equalTo(245)
            }
            self.backgroundButton.alpha = 0.1
            self.view.layoutIfNeeded()
        })
    }
}
