//
//  ScheduleViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/09.
//

import UIKit
import SnapKit
import Combine
import SwiftUI

class ScheduleViewController: BaseViewController {
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
        label.text = "일정"
        return label
    }()
    
    private var rootView: UIHostingController<ScheduleSwiftUIView>
    
    private var titleSpaceView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Properties
    private weak var coordinator: ScheduleNavigation!
    private let viewModel: ScheduleViewModel
    private let loadTitleSubject = PassthroughSubject<Void, Never>()

    // MARK: - Init
    init(
        coordinator: ScheduleNavigation,
        viewModel: ScheduleViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.rootView = UIHostingController(rootView: ScheduleSwiftUIView(viewModel: viewModel))
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
        addChild(rootView)
        view.addSubview(rootView.view)
        
        [
            titleLabel,
            titleSpaceView
        ].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        navigationItem.leftBarButtonItem = xButton
        navigationItem.titleView = titleStackView
    }
    
    override func setupConstaints() {
        titleSpaceView.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(CGFloat.greatestFiniteMagnitude).priority(.low)
        }
        
        rootView.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func bind() {
        // MARK: - Input
        let input = ScheduleViewModel.Input(
            loadTitle: loadTitleSubject.eraseToAnyPublisher()
        )
                
        // MARK: - Output
        let output = viewModel.transform(input: input)
        
        output.title
            .receive(on: RunLoop.main)
            .sink { [weak self] title in
                self?.titleLabel.text = title
            }
            .store(in: &cancellables)
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTitleSubject.send()
    }
    
    // MARK: - Function
    @objc private func closeButtonTapped(_ sender: UIBarButtonItem) {
        coordinator.dimiss()
    }
}

extension ScheduleViewController:
    UIAdaptivePresentationControllerDelegate {
    
    // MARK: - UIAdaptivePresentationControllerDelegate
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        guard let coordinator else { return }
        coordinator.dimiss()
    }
}
