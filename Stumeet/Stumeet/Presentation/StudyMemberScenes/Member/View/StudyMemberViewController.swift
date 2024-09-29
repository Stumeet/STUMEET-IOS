//
//  StudyMemberViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/08/22.
//

import UIKit
import SnapKit
import Combine

class StudyMemberViewController: BaseViewController {
    
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
    private weak var coordinator: StudyMemberNavigation!
    private let viewModel: StudyMemberViewModel
    private var studyMemberDataSource: UITableViewDiffableDataSource<StudyMemberListSection, StudyMember>?
    private let loadStudyMemberDataSubject = PassthroughSubject<Void, Never>()

    // MARK: - Init
    init(
        coordinator: StudyMemberNavigation,
        viewModel: StudyMemberViewModel
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
        view.addSubview(memberTableView)
        
        [
            titleLabel,
            titleCountLabel,
            titleSpaceView
        ].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        navigationItem.leftBarButtonItem = xButton
        navigationItem.titleView = titleStackView
        navigationItem.rightBarButtonItem = memberSettingsButton
    }
    
    override func setupConstaints() {
        titleSpaceView.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(CGFloat.greatestFiniteMagnitude).priority(.low)
        }
        
        memberTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    override func bind() {
        // MARK: - Input
        let input = StudyMemberViewModel.Input(
            loadStudyMemberData: loadStudyMemberDataSubject.eraseToAnyPublisher()
        )

        // MARK: - Output
        let output = viewModel.transform(input: input)
        
        // TODO: - 임시 viewModel 생성 시 수정
        memberTableView.didSelectRowPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] selectRow in
                guard let self = self else { return }
                
                coordinator.presentToMemberDetailVC()
            }
            .store(in: &cancellables)
        
        output.studyMemberDataSource
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                self?.updateSnapshot(items: items)
            }
            .store(in: &cancellables)
        
        output.studyMemberCount
            .receive(on: RunLoop.main)
            .sink { [weak self] total in
                self?.updateTitleCount(memberTotal: total)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatasource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStudyMemberDataSubject.send()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator.dimiss()
    }
    
    // MARK: - Function
    private func updateTitleCount(memberTotal: Int) {
        titleCountLabel.text = String(memberTotal)
    }
    
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
                cell.configureCell(item)
                return cell
            }
        )
    }
    // TODO: - API 연동 시 수정
    private func updateSnapshot(items: [StudyMember]) {
        var snapshot = NSDiffableDataSourceSnapshot<StudyMemberListSection, StudyMember>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        guard let datasource = self.studyMemberDataSource else { return }
        datasource.apply(snapshot, animatingDifferences: false)
    }
}
