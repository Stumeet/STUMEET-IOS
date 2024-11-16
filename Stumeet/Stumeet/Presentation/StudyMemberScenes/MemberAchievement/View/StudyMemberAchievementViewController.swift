//
//  StudyMemberAchievementViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/29.
//

import UIKit
import SnapKit
import Combine

class StudyMemberAchievementViewController: BaseViewController {
    
    // MARK: - UIComponents
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
        label.text = "멤버 성취도"
        return label
    }()
    
    private var titleSpaceView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var headerTapBarView = StudyMemberHeaderTapBarView(
        options: StudyMemberAchievementHeaderTapBarViewType.allCases.map { ($0.title, $0.id) },
        initSelectedIndex: StudyMemberAchievementHeaderTapBarViewType.meeting.id
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
    private var viewModel: StudyMemberAchievementViewModel
    private var activityDataSource: UITableViewDiffableDataSource<StudyMemberActivityListSection, StudyMemberActivityListItem>?
    
    private let loadDataSubject = PassthroughSubject<Void, Never>()
    private let didTapHeadderTapBarButtonSubject = PassthroughSubject<StudyMemberAchievementHeaderTapBarViewType, Never>()
    private let didReachTableBottomSubject = PassthroughSubject<Void, Never>()
    private let didSelectRowSubject = PassthroughSubject<IndexPath, Never>()

    // MARK: - Init
    init(
        coordinator: StudyMemberNavigation,
        viewModel: StudyMemberAchievementViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyles() {
        self.view.backgroundColor = .white
        self.navigationController?.setupBarAppearance()
    }
    
    override func setupAddView() {
        navigationItem.titleView = titleStackView
        
        [
            titleLabel,
            titleSpaceView
        ].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        view.addSubview(headerTapBarView)
        view.addSubview(activityTableView)
    }
    
    override func setupConstaints() {
        titleSpaceView.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(CGFloat.greatestFiniteMagnitude).priority(.low)
        }
        
        headerTapBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }
        
        activityTableView.snp.makeConstraints {
            $0.top.equalTo(headerTapBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func bind() {
        // MARK: - Input
        let input = StudyMemberAchievementViewModel.Input(
            loadDataTrigger: loadDataSubject.eraseToAnyPublisher(),
            didTapHeadderTapBarButton: didTapHeadderTapBarButtonSubject.eraseToAnyPublisher(),
            didReachTableBottom: didReachTableBottomSubject.eraseToAnyPublisher(),
            didSelectRow: didSelectRowSubject.eraseToAnyPublisher()
        )

        // MARK: - Output
        let output = viewModel.transform(input: input)
        
        output.activityDataSource
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                guard let self else { return }
                updateSnapshot(items: items)
            }
            .store(in: &cancellables)
 
        output.moveToMemberActivityDetailVC
            .receive(on: RunLoop.main)
            .sink { [weak self] studyID, activityID, category in
                guard let self else { return }
                coordinator.goToMemberActivityDetailVC(studyID: studyID, activityID: activityID, category: category)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        configureDatasource()
        loadDataSubject.send()
    }
    
    // MARK: - Function
    private func setupDelegate() {
        headerTapBarView.delegate = self
        activityTableView.delegate = self
    }
}

extension StudyMemberAchievementViewController:
    UITableViewDelegate,
    StudyMemberHeaderTapBarViewDelegate {
    
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
    
    // MARK: - UITableViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yDelta = scrollView.contentOffset.y
        let threshold = max(0, (scrollView.contentSize.height) * 0.3)

        if yDelta > threshold { didReachTableBottomSubject.send() }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowSubject.send(indexPath)
    }
    
    // MARK: - StudyMemberHeaderTapBarViewDelegate
    func didTapAction(_ button: StudyMemberHeaderTapBarView.RadioButton) {
        guard let tapType = StudyMemberAchievementHeaderTapBarViewType(rawValue: button.id) else { return }
        didTapHeadderTapBarButtonSubject.send(tapType)
    }
}
