//
//  StudyMemberDetailViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/02.
//

import UIKit
import SnapKit
import Combine

class StudyMemberDetailViewController: BaseViewController {
    
    // MARK: - UIComponents
    private var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        let naviBarAppearance = UINavigationBarAppearance()
        naviBarAppearance.configureWithTransparentBackground()
        naviBarAppearance.backgroundColor = .white
        navBar.standardAppearance = naviBarAppearance
        return navBar
    }()
    
    private var navigationBarItems: UINavigationItem = {
        let navItem = UINavigationItem()
        return navItem
    }()
    
    private lazy var xButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(
            image: UIImage(resource: .xMark),
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
        barButton.tintColor = StumeetColor.gray800.color
        
        return barButton
    }()
    
    private var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.titleMedium.font
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 1
        label.text = "상세 정보"
        return label
    }()
    
    private var titleSpaceView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var moreButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(
            image: UIImage(resource: .StudyMember.dotsVertical),
            style: .plain,
            target: self,
            action: #selector(moreButtonTapped)
        )
        barButton.tintColor = StumeetColor.gray800.color
        
        return barButton
    }()
    
    private let headerView = StudyMemberDetailInfoHeaderView()
    private var headerTapBarView = StudyMemberDetailHeaderTapBarView(
        options: StudyMemberDetailHeaderTapBarViewType.allCases.map { $0.title },
        initSelectedIndex: StudyMemberDetailHeaderTapBarViewType.meeting.id
    )
    
    
    // MARK: - Properties
    private weak var coordinator: StudyMemberNavigation!

    // MARK: - Init
    init(
        coordinator: StudyMemberNavigation
    ) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyles() {
        view.backgroundColor = .white
    }
    
    override func setupAddView() {
        view.addSubview(navigationBar)
        view.addSubview(headerView)
        view.addSubview(headerTapBarView)
        
        navigationBarItems.leftBarButtonItem = xButton
        navigationBarItems.titleView = titleStackView
        navigationBarItems.rightBarButtonItem = moreButton
        
        navigationBar.setItems([navigationBarItems], animated: true)
        
        [
            titleLabel,
            titleSpaceView
        ].forEach {
            titleStackView.addArrangedSubview($0)
        }
    }
    
    override func setupConstaints() {
        navigationBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        titleSpaceView.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(CGFloat.greatestFiniteMagnitude).priority(.low)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        headerTapBarView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
    }
    
    override func bind() {

    }
    
    // MARK: - LifeCycle
    
    
    @objc func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @objc func moreButtonTapped(_ sender: UIBarButtonItem) {
        print(#function)
    }
  
}
