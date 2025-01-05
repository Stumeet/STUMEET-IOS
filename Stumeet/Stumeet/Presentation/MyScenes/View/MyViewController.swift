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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderTopPadding = 0
        return tableView
    }()

    // MARK: - Properties
    private weak var coordinator: MyNavigation!
    private let viewModel: MyViewModel
    
    private let loadDataSubject = PassthroughSubject<Void, Never>()
    
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
    }
    
    override func bind() {
        // MARK: - Input
        let input = MyViewModel.Input(
            loadData: loadDataSubject.eraseToAnyPublisher()
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
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataSubject.send()
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
