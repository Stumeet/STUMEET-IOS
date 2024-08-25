//
//  StudyMemberViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/08/22.
//

import UIKit
import SnapKit

class StudyMemberViewController: BaseViewController {
    
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
    
    private lazy var memberSettingsButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(
            image: UIImage(resource: .StudyMember.userCog),
            style: .plain,
            target: self,
            action: #selector(memberSettingsButtonTapped)
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
        label.text = "멤버"
        return label
    }()
    
    private var titleCountLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.titleMedium.font
        label.textColor = StumeetColor.primary700.color
        label.numberOfLines = 1
        // TODO: - API 연동 시 수정요
        label.text = "9"
        return label
    }()
    
    private lazy var memberTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.registerCell(StudyMemberListTableViewCell.self)
        return tableView
    }()
    
    private var titleSpaceView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Properties
    private weak var coordinator: MyStudyGroupListNavigation!
    private var studyMemberDataSource: UITableViewDiffableDataSource<StudyMemberListSection, Int>?

    // MARK: - Init
    init(
        coordinator: MyStudyGroupListNavigation
    ) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyles() {
        self.view.backgroundColor = .white
    }
    
    override func setupAddView() {
        view.addSubview(navigationBar)
        view.addSubview(memberTableView)
        
        navigationBarItems.leftBarButtonItem = xButton
        navigationBarItems.titleView = titleStackView
        navigationBarItems.rightBarButtonItem = memberSettingsButton
        
        navigationBar.setItems([navigationBarItems], animated: true)
        
        [
            titleLabel,
            titleCountLabel,
            titleSpaceView
        ].forEach {
            titleStackView.addArrangedSubview($0)
        }
    }
    
    override func setupConstaints() {
        navigationBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleSpaceView.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(CGFloat.greatestFiniteMagnitude).priority(.low)
        }
        
        memberTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    override func bind() {
        // MARK: - Input
                
        // MARK: - Output
        
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatasource()
        // TODO: - API 연동 시 수정
        updateSnapshot()
    }
    
    // MARK: - Function
    @objc func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @objc func memberSettingsButtonTapped(_ sender: UIBarButtonItem) {
        print(#function)
    }
}

extension StudyMemberViewController {
    // MARK: - DataSource
    // TODO: - API 연동 시 수정
    private func configureDatasource() {
        studyMemberDataSource = UITableViewDiffableDataSource(
            tableView: memberTableView,
            cellProvider: { tableView, indexPath, item in
                guard let cell = tableView.dequeue(StudyMemberListTableViewCell.self, for: indexPath)
                else { return UITableViewCell() }
                cell.configureCell()
                return cell
            }
        )
    }
    // TODO: - API 연동 시 수정
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<StudyMemberListSection, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems([1, 2, 3, 4])
        
        guard let datasource = self.studyMemberDataSource else { return }
        datasource.apply(snapshot, animatingDifferences: false)
    }
}
