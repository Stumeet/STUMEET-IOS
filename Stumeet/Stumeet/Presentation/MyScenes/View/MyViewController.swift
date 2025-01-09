//
//  MyViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/01.
//

import UIKit
import SnapKit
import Combine

class MyViewController: BaseViewController {
    
    // MARK: - UIComponents
    private let headerView = MyHeaderView()
    
    private var headerTapBarView = CenterHeaderTabView(
        options: MyHeaderTapBarViewType.allCases.map { ($0.title, $0.id) },
        initSelectedIndex: MyHeaderTapBarViewType.evaluation.id
    )
    
    private lazy var evaluationTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset.top = 20
        tableView.contentInset.bottom = 20
        tableView.contentOffset.y = -20
        tableView.registerCell(MyEvaluationTableViewCell.self)
        tableView.registerCell(MyEvaluationSeeMoreTableViewCell.self)
        tableView.registerCell(MyReviewOrderTypeTableViewCell.self)
        tableView.registerCell(MyReviewTableViewCell.self)
        return tableView
    }()
    
    private lazy var activityTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset.top = 12
        tableView.contentInset.bottom = 20
        tableView.contentOffset.y = -12
        tableView.registerCell(MyActivityTableViewCell.self)
        return tableView
    }()

    // MARK: - Properties
    private weak var coordinator: MyNavigation!
    private let viewModel: MyViewModel
    
    private var evaluationDataSource: UITableViewDiffableDataSource<MyEvaluationListSection, MyEvaluationRow>?
    private var activityDataSource: UITableViewDiffableDataSource<MyActivityListSection, MyActivityRow>?
    
    private let loadDataSubject = PassthroughSubject<Void, Never>()
    private let didTapHeadderTapBarButtonSubject = PassthroughSubject<MyHeaderTapBarViewType, Never>()
    
    // MARK: - Init
    init(
        coordinator: MyNavigation,
        viewModel: MyViewModel
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
    }
    
    override func setupAddView() {
        view.addSubview(headerView)
        view.addSubview(headerTapBarView)
        view.addSubview(evaluationTableView)
        view.addSubview(activityTableView)
        
        navigationItem.rightBarButtonItems = [
            makeBarButtonItem(
                image: .My.pencilCog,
                action: UIAction { _ in
                }
            ),
            makeBarButtonItem(
                image: .My.settings,
                action: UIAction { _ in
                }
            )
        ]
    }
    
    override func setupConstaints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        headerTapBarView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        evaluationTableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(headerTapBarView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        activityTableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(headerTapBarView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bind() {
        // MARK: - Input
        let input = MyViewModel.Input(
            loadData: loadDataSubject.eraseToAnyPublisher(),
            didTapHeadderTapBarButton: didTapHeadderTapBarButtonSubject.eraseToAnyPublisher()
        )
        
        // MARK: - Output
        let output = viewModel.transform(input: input)
        
        output.myHeaderItem
            .receive(on: RunLoop.main)
            .sink { [weak self] headerItem in
                guard let self else { return }
                headerView.configure(with: headerItem)
            }
            .store(in: &cancellables)
        
        output.headderTapType
            .receive(on: DispatchQueue.main) //  RunLoop.main 로 할 경우 스크롤중에는 작동이 딜레이 된다 원인이 뭘까
            .sink { [weak self] tapType in
                guard let self else { return }
                switch tapType {
                case .evaluation:
                    activityTableView.isHidden = true
                    evaluationTableView.isHidden = false
                case .activity:
                    activityTableView.isHidden = false
                    evaluationTableView.isHidden = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupDelegate() {
        headerTapBarView.delegate = self
        evaluationTableView.delegate = self
        activityTableView.delegate = self
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatasource()
        setupDelegate()
        loadDataSubject.send()
        didTapHeadderTapBarButtonSubject.send(.evaluation)
        
        evaluationUpdateSnapshot(
            items: [
                .evaluation(MyEvaluationItem()),
                .evaluation(MyEvaluationItem()),
                .evaluation(MyEvaluationItem()),
                .evaluation(MyEvaluationItem()),
                .evaluation(MyEvaluationItem(isLastItem: true)),
                .evaluationSeeMore(true),
                .reviewOrder("최신순"),
                .review(MyReviewItem()),
                .review(MyReviewItem()),
                .review(MyReviewItem()),
                .review(MyReviewItem()),
                .review(MyReviewItem()),
                .review(MyReviewItem()),
                .review(MyReviewItem()),
                .review(MyReviewItem()),
                .review(MyReviewItem()),
                .review(MyReviewItem())
            ]
        )
        
        activityUpdateSnapshot(
            items: [
                .activity(MyActivityItem()),
                .activity(MyActivityItem()),
                .activity(MyActivityItem()),
                .activity(MyActivityItem()),
                .activity(MyActivityItem()),
                .activity(MyActivityItem()),
                .activity(MyActivityItem()),
                .activity(MyActivityItem()),
                .activity(MyActivityItem()),
                .activity(MyActivityItem()),
                .activity(MyActivityItem()),
                .activity(MyActivityItem()),
                .activity(MyActivityItem()),
                .activity(MyActivityItem()),
                .activity(MyActivityItem())
            ]
        )
    }
    
    // MARK: - Function
    private func makeBarButtonItem(image: ImageResource, action: UIAction) -> UIBarButtonItem {
        let button = UIButton()
        let image = UIImage(resource: image)
        button.setImage(image, for: .normal)
        button.addAction(action, for: .touchUpInside)
    
        return UIBarButtonItem(customView: button)
    }
}

extension MyViewController:
    UITableViewDelegate,
    CenterHeaderTabViewDelegate {
    // MARK: - DataSource
    private func configureDatasource() {
        evaluationDataSource = UITableViewDiffableDataSource(
            tableView: evaluationTableView,
            cellProvider: { tableView, indexPath, item in

                switch item {
                case .evaluation(let data):
                    guard let cell = tableView.dequeue(MyEvaluationTableViewCell.self, for: indexPath)
                    else { return UITableViewCell() }
                    cell.configureCell(data)
                    return cell
                case .evaluationSeeMore(let data):
                    guard let cell = tableView.dequeue(MyEvaluationSeeMoreTableViewCell.self, for: indexPath)
                    else { return UITableViewCell() }
                    cell.configureCell(data)
                case .reviewOrder(let data):
                    guard let cell = tableView.dequeue(MyReviewOrderTypeTableViewCell.self, for: indexPath)
                    else { return UITableViewCell() }
                    cell.configureCell(data)
                case .review(let data):
                    guard let cell = tableView.dequeue(MyReviewTableViewCell.self, for: indexPath)
                    else { return UITableViewCell() }
                    cell.configureCell(data)
                    return cell
                }
                
                return UITableViewCell()
            }
        )
        
        activityDataSource = UITableViewDiffableDataSource(
            tableView: activityTableView,
            cellProvider: { tableView, indexPath, item in
                switch item {
                case .activity(let data):
                    guard let cell = tableView.dequeue(MyActivityTableViewCell.self, for: indexPath)
                    else { return UITableViewCell() }
                    cell.configureCell(data)
                    return cell
                }
            }
        )
    }

    private func evaluationUpdateSnapshot(items: [MyEvaluationRow]) {
        var snapshot = NSDiffableDataSourceSnapshot<MyEvaluationListSection, MyEvaluationRow>()
        snapshot.appendSections(MyEvaluationListSection.allCases)
        
        let evaluationRows = items.filter {
            if case .evaluation = $0 { return true }
            if case .evaluationSeeMore = $0 { return true }
            return false
        }
        snapshot.appendItems(evaluationRows, toSection: .evaluations)
        
        let reviewRows = items.filter {
            if case .reviewOrder = $0 { return true }
            if case .review = $0 { return true }
            return false
        }
        snapshot.appendItems(reviewRows, toSection: .reviews)
        
        guard let datasource = self.evaluationDataSource else { return }
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    private func activityUpdateSnapshot(items: [MyActivityRow]) {
        var snapshot = NSDiffableDataSourceSnapshot<MyActivityListSection, MyActivityRow>()
        snapshot.appendSections(MyActivityListSection.allCases)
        
        let activityRows = items.filter {
            if case .activity = $0 { return true }
            return false
        }
        snapshot.appendItems(activityRows, toSection: .activitys)
        
        guard let datasource = self.activityDataSource else { return }
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == evaluationTableView {
            guard let dataSource = tableView.dataSource as? UITableViewDiffableDataSource<MyEvaluationListSection, MyEvaluationRow>,
                  let item = dataSource.itemIdentifier(for: indexPath) else {
                return UITableView.automaticDimension
            }
            
            switch item {
            case .evaluation:
                return UITableView.automaticDimension
            case .evaluationSeeMore:
                return 40
            case .reviewOrder:
                return 45
            case .review:
                return UITableView.automaticDimension
            }
        }
        
        return UITableView.automaticDimension
    }
    
    // MARK: - CenterHeaderTabViewDelegate
    func didTapAction(_ button: CenterHeaderTabView.RadioButton) {
        guard let tapType = MyHeaderTapBarViewType(rawValue: button.id) else { return }
        didTapHeadderTapBarButtonSubject.send(tapType)
    }
}
