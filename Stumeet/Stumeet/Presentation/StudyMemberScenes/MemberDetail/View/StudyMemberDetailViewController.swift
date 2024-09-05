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
    
    private lazy var activityTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.rowHeight = 91
        tableView.registerCell(StudyMemberActivityListTableViewCell.self)
        return tableView
    }()
    
    
    // MARK: - Properties
    private weak var coordinator: StudyMemberNavigation!
    private var activityDataSource: UITableViewDiffableDataSource<StudyMemberDetailActivityListSection, StudyMemberDetailActivityListItem>?

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
        view.addSubview(activityTableView)
        
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
        
        activityTableView.snp.makeConstraints {
            $0.top.equalTo(headerTapBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
    
    override func bind() {

    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: - API 연동 시 수정
        configureDatasource()
        updateSnapshot(
            items: [
                StudyMemberDetailActivityListItem(
                    activity: Activity(
                        id: 0,
                        tag: .meeting,
                        title: "test1120399210390-2193-02910-39102-930-21930-9213387238732899823820394893028490328904",
                        content: "test12",
                        startTiem: "2024-04-22T00:00:00",
                        endTime: "2024-04-22T00:00:00",
                        place: "성심",
                        image: nil,
                        name: nil,
                        day: "2024-08-19T11:20:21.961423",
                        status: .absent
                    ),
                    cellType: .firstCell
                ),
                StudyMemberDetailActivityListItem(
                    activity: Activity(
                        id: 2,
                        tag: .meeting,
                        title: "test2",
                        content: "test12",
                        startTiem: "2024-04-22T00:00:00",
                        endTime: "2024-04-22T00:00:00",
                        place: "성심",
                        image: nil,
                        name: nil,
                        day: "2024-08-19T11:20:21.961423",
                        status: .beforeStart
                    ),
                    cellType: .normal
                ),
                StudyMemberDetailActivityListItem(
                    activity: Activity(
                        id: 3,
                        tag: .homework,
                        title: "test323094329048324321948fdsaklndfkjmnaikfniwejfeiuajhiufhawiluhfliuawhefliuhawiluefhilauwehfiluawhilufehliaufwehuliwfh",
                        content: "test12",
                        startTiem: "2024-04-22T00:00:00",
                        endTime: "2024-04-22T00:00:00",
                        place: "성심",
                        image: nil,
                        name: nil,
                        day: "2024-08-19T11:20:21.961423",
                        status: nil
                    ),
                    cellType: .normal
                ),
                StudyMemberDetailActivityListItem(
                    activity: Activity(
                        id: 4,
                        tag: .homework,
                        title: "test4",
                        content: "test12",
                        startTiem: "2024-04-22T00:00:00",
                        endTime: "2024-04-22T00:00:00",
                        place: "성심",
                        image: nil,
                        name: nil,
                        day: "2024-08-19T11:20:21.961423",
                        status: .noParticipation
                    ),
                    cellType: .normal
                )]
        )
    }
    
    @objc func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @objc func moreButtonTapped(_ sender: UIBarButtonItem) {
        print(#function)
    }
  
}

extension StudyMemberDetailViewController {
    // MARK: - DataSource
    private func configureDatasource() {
        activityDataSource = UITableViewDiffableDataSource(
            tableView: activityTableView,
            cellProvider: { tableView, indexPath, item in
                guard let cell = tableView.dequeue(StudyMemberActivityListTableViewCell.self, for: indexPath)
                else { return UITableViewCell() }
                cell.configureCell(item)
                return cell
            }
        )
    }
    
    private func updateSnapshot(items: [StudyMemberDetailActivityListItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<StudyMemberDetailActivityListSection, StudyMemberDetailActivityListItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        guard let datasource = self.activityDataSource else { return }
        datasource.apply(snapshot, animatingDifferences: false)
    }
}
