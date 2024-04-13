//
//  CalendarView.swift
//  Stumeet
//
//  Created by 정지훈 on 4/12/24.
//

import UIKit

import SnapKit

final class CalendarView: UIView {

    // MARK: UIComponent
    
    private let yearMonthButton: UIButton = {
        let button = UIButton()
        button.setTitle("2024년4월", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = StumeetFont.bodyMedium15.font
        
        return button
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "calendarLeft"), for: .normal)
        
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "calendarRight"), for: .normal)
        
        return button
    }()
    
    lazy var calendarCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.identifier)
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupAddView()
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUp
    
    func setupAddView() {
        [
            yearMonthButton,
            leftButton,
            rightButton,
            calendarCollectionView
        ]   .forEach { addSubview($0) }
    }
    
    func setupConstaints() {
        
        yearMonthButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(19)
        }
        
        rightButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        
        leftButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalTo(rightButton.snp.leading).offset(-16)
        }
        
        calendarCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(yearMonthButton.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - Layout

extension CalendarView {
    func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = CalendarSection(rawValue: sectionIndex)
            switch section {
            case .week:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.14), heightDimension: .absolute(18))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(18))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
                
            case .day:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.14), heightDimension: .absolute(32))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(32))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 16, leading: 0, bottom: 0, trailing: 0)
                section.interGroupSpacing = 8
                return section
                
            case .none:
                return nil
            }
        }
    }
}
