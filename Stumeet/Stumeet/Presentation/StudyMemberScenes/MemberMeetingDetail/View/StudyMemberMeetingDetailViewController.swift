//
//  StudyMemberMeetingDetailViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/29.
//

import UIKit
import SnapKit
import Combine

class StudyMemberMeetingDetailViewController: BaseViewController {
    
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
        label.text = "모임 상세"
        return label
    }()
    
    private var titleSpaceView: UIView = {
        let view = UIView()
        return view
    }()
    
    // TODO: - API 연동 시 수정
    private var headerView = StudyMemberActivityView(
        StudyMemberActivityViewItem(
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
            )
        )
    )
    
    private lazy var meetingStateTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.registerCell(StudyMemberMeetingStateListTableViewCell.self)
        return tableView
    }()
    
    // MARK: - Properties
    private weak var coordinator: StudyMemberNavigation!
    private var meetingStateDataSource: [StudyMemberMeetingStateListItem] = []

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
        
        view.addSubview(headerView)
        view.addSubview(meetingStateTableView)
    }
    
    override func setupConstaints() {
        titleSpaceView.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(CGFloat.greatestFiniteMagnitude).priority(.low)
        }
        
        headerView.snp.makeConstraints {
            $0.height.equalTo(91)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
        }
        
        meetingStateTableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
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
        
        updateMeetingStateDataSource(items: [
            StudyMemberMeetingStateListItem(id: 0, isStateHidden: true, attendanceState: .absence),
            StudyMemberMeetingStateListItem(id: 1, isStateHidden: true, attendanceState: .excusedAbsence),
            StudyMemberMeetingStateListItem(id: 2, isStateHidden: true, attendanceState: .late),
            StudyMemberMeetingStateListItem(id: 3, isStateHidden: true, attendanceState: .present)
        ])
    }
    
    // MARK: - Function
    
    private func updateMeetingStateDataSource(items: [StudyMemberMeetingStateListItem]) {
        meetingStateDataSource = items
        meetingStateTableView.reloadData()
    }
}

extension StudyMemberMeetingDetailViewController:
    UITableViewDataSource,
    StudyMemberMeetingStateListTableViewCellDelegate {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingStateDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeue(StudyMemberMeetingStateListTableViewCell.self, for: indexPath),
              let taskStateData = meetingStateDataSource[safe: indexPath.row]
        else { return UITableViewCell() }
        cell.configureCell(taskStateData)
        cell.delegate = self
        return cell
    }
   
    // MARK: - StudyMemberMeetingStateListTableViewCellDelegate
    func didTapTaskState(_ item: StudyMemberMeetingStateListItem, cell: StudyMemberMeetingStateListTableViewCell) {
        guard let indexPath = meetingStateTableView.indexPath(for: cell),
              meetingStateDataSource[safe: indexPath.row] != nil
        else { return}
        meetingStateDataSource[indexPath.row] = item
        UIView.performWithoutAnimation {
            meetingStateTableView.reconfigureRows(at: [indexPath])
        }
        
    }
}
