//
//  AlarmViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/12/22.
//

import UIKit
import SnapKit
import Combine

class AlarmViewController: BaseViewController {
    // MARK: - UIComponents
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
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = StumeetFont.titleMedium.font
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 1
        label.text = "알림"
        return label
    }()
    
    private lazy var alarmTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private var titleSpaceView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Properties
    private weak var coordinator: AlarmNavigation!
    private let viewModel: AlarmViewModel
    private let loadDataSubject = PassthroughSubject<Void, Never>()

    // MARK: - Init
    init(
        coordinator: AlarmNavigation,
        viewModel: AlarmViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setupStyles() {
        self.view.backgroundColor = .white
        self.navigationController?.setupBarAppearance()
    }
    
    override func setupAddView() {
        view.addSubview(alarmTableView)
        
        navigationItem.leftBarButtonItem = xButton
        navigationItem.titleView = titleLabel
    }
    
    override func setupConstaints() {        
        alarmTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
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
        loadDataSubject.send()
    }
    
    // MARK: - Function
    @objc func closeButtonTapped(_ sender: UIBarButtonItem) {
        coordinator.dimiss()
    }
}
