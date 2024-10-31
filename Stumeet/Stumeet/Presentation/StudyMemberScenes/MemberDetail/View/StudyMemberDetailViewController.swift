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
    private var headerTapBarView = StudyMemberHeaderTapBarView(
        options: StudyMemberDetailHeaderTapBarViewType.allCases.map { ($0.title, $0.id) },
        initSelectedIndex: StudyMemberDetailHeaderTapBarViewType.meeting.id
    )
    
    private lazy var activityTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.rowHeight = 91
        tableView.registerCell(StudyMemberActivityListTableViewCell.self)
        return tableView
    }()
    
    private var contextMenu = StudyMemberDetailContextMenuView()
    
    // MARK: - Properties
    private weak var coordinator: StudyMemberNavigation!
    private var viewModel: StudyMemberDetailViewModel
    private var activityDataSource: UITableViewDiffableDataSource<StudyMemberActivityListSection, StudyMemberActivityListItem>?
    private lazy var contextMenuSize = contextMenu.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let didTapHeadderTapBarButtonSubject = PassthroughSubject<StudyMemberDetailHeaderTapBarViewType, Never>()
    private let didReachTableBottomSubject = PassthroughSubject<Void, Never>()

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
        view.addSubview(contextMenu)
        
        navigationBarItems.leftBarButtonItem = xButton
        navigationBarItems.titleView = titleStackView
        
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
        let input = StudyMemberDetailViewModel.Input(
            viewDidLoadTrigger: viewDidLoadSubject.eraseToAnyPublisher(),
            didTapHeadderTapBarButton: didTapHeadderTapBarButtonSubject.eraseToAnyPublisher(),
            didReachTableBottom: didReachTableBottomSubject.eraseToAnyPublisher()
        )

        // MARK: - Output
        let output = viewModel.transform(input: input)
        
        output.studyMemberHeaderItem
            .receive(on: RunLoop.main)
            .sink { [weak self] headerItem in
                guard let self else { return }
                headerView.configure(with: headerItem)
            }
            .store(in: &cancellables)
        
        output.showMoreButtonState
            .receive(on: RunLoop.main)
            .sink { [weak self] isShowMorebutton in
                guard let self else { return }
                if isShowMorebutton {
                    navigationBarItems.rightBarButtonItem =  moreButton
                } else {
                    navigationBarItems.rightBarButtonItem =  nil
                }
            }
            .store(in: &cancellables)
        
        output.activityDataSource
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                guard let self else { return }
                updateSnapshot(items: items)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupGesture()
        configureDatasource()
        viewDidLoadSubject.send()
    }

    // MARK: - Function
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupDelegate() {
        headerView.delegate = self
        headerTapBarView.delegate = self
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
    UITableViewDelegate,
    StudyMemberDetailInfoHeaderViewDelegate,
    StumeetConfirmationPopupViewControllerDelegate,
    StudyMemberHeaderTapBarViewDelegate {
    
    // MARK: - UITableViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yDelta = scrollView.contentOffset.y
        let threshold = max(0, (scrollView.contentSize.height) * 0.3)

        if yDelta > threshold { didReachTableBottomSubject.send() }
    }
    
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
    
    private func updateSnapshot(items: [StudyMemberActivityListItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<StudyMemberActivityListSection, StudyMemberActivityListItem>()
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
    
    // MARK: - StudyMemberHeaderTapBarViewDelegate
    func didTapAction(_ button: StudyMemberHeaderTapBarView.RadioButton) {
        guard let tapType = StudyMemberDetailHeaderTapBarViewType(rawValue: button.id) else { return }
        didTapHeadderTapBarButtonSubject.send(tapType)
    }
}
