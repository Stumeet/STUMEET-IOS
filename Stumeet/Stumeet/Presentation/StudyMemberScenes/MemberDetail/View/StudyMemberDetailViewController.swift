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
    
    private var contextMenu = StudyMemberDetailContextMenuView()
    
    // MARK: - Properties
    private weak var coordinator: StudyMemberNavigation!
    private var viewModel: StudyMemberDetailViewModel
    private var activityDataSource: UITableViewDiffableDataSource<StudyMemberDetailActivityListSection, StudyMemberDetailActivityListItem>?
    private lazy var contextMenuSize = contextMenu.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

    // MARK: - Init
    init(
        coordinator: StudyMemberNavigation,
        viewModel: StudyMemberDetailViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyles() {
        view.backgroundColor = .white
        contextMenu.layer.anchorPoint = CGPoint(x: 1, y: 0)
        
        contextMenu.addItem(
            title: "추방하기",
            textColor: StumeetColor.danger500.color,
            action: UIAction { [weak self] _ in
                guard let self else { return }
                coordinator.presentToExpulsionPopup(
                    from: self,
                    delegate: self,
                    popupContextView: setExpulsionView()
                )
            }
        )
        contextMenu.addItem(
            title: "위임하기",
            action: UIAction { [weak self] _ in
                guard let self else { return }
                coordinator.presentToExpulsionPopup(
                    from: self,
                    delegate: self,
                    popupContextView: setDelegateHostView()
                )
            }
        )
        contextMenu.isVisiblyHidden = true
    }
    
    override func setupAddView() {
        view.addSubview(navigationBar)
        view.addSubview(headerView)
        view.addSubview(headerTapBarView)
        view.addSubview(activityTableView)
        view.addSubview(activityTableView)
        view.addSubview(contextMenu)
        
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
        
        contextMenu.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(-(contextMenuSize.height / 2))
            $0.trailing.equalToSuperview().offset((contextMenuSize.width / 2) - 16)
        }
    }
    
    override func bind() {
        // MARK: - Input
        
        // MARK: - Output
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupGesture()
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

    // MARK: - Function
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupDelegate() {
        headerView.delegate = self
    }
    
    private func toggleContextMenu() {
        contextMenu.isVisiblyHidden.toggle()
    }
    
    private func setExpulsionView() -> UIView {
        let view = UIView()
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = StumeetFont.titleMedium.font
            label.textColor = StumeetColor.gray800.color
            label.numberOfLines = 0
            label.textAlignment = .center
            return label
        }()
        
        titleLabel.text = "홍길동님을 추방하시겠어요?"
        titleLabel.setColorAndFont(
            to: "홍길동",
            withColor: StumeetColor.gray900.color,
            withFont: StumeetFont.titleBold.font
        )
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        return view
    }
    
    private func setDelegateHostView() -> UIView {
        let view = UIView()
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = StumeetFont.titleMedium.font
            label.textColor = StumeetColor.gray600.color
            label.numberOfLines = 0
            label.textAlignment = .center
            return label
        }()
        
        titleLabel.text = "스터디장 위임은 취소할 수 없어요.\n스터디장을 위임하시겠습니까?"
        titleLabel.setColorAndFont(
            to: "스터디장 위임은 취소할 수 없어요.",
            withColor: StumeetColor.gray900.color,
            withFont: StumeetFont.titleBold.font
        )
        titleLabel.setLineSpacing(lineSpacing: 13)
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        return view
    }
    
    @objc private func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @objc private func moreButtonTapped(_ sender: UIBarButtonItem) {
        toggleContextMenu()
    }
       
    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        contextMenu.isVisiblyHidden = true
    }
}

extension StudyMemberDetailViewController:
    StudyMemberDetailInfoHeaderViewDelegate,
    StumeetConfirmationPopupViewControllerDelegate {
    
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
    
    // MARK: - StudyMemberDetailInfoHeaderViewDelegate
    func didTapComplimentButton() {
        coordinator.presentToComplimentPopup(from: self)
    }
    
    // TODO: API 연동 시 수정
    // MARK: - StumeetConfirmationPopupViewControllerDelegate
    func confirmAction() {
        print(#function)
    }
    
    func cancelAction() {
        print(#function)
    }
}
