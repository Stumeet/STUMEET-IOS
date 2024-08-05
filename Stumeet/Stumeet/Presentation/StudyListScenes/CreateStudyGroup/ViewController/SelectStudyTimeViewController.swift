//
//  SelectStudyTimeViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 8/5/24.
//

import UIKit

final class SelectStudyTimeViewController: BaseViewController {
    
    // MARK: - UIComponents
    
    private let backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.alpha = 0
        
        return button
    }()
    
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        return view
    }()
    
    private let dragIndicatorContainerView = UIView()
    
    private let dragIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1)
        view.layer.cornerRadius = 7
        return view
        
    }()
    
    private let timeView = TimeView()
    
    private let completeButton = UIButton().makeRegisterBottomButton(text: "완료", color: StumeetColor.gray200.color)
    
    // MARK: - Properties
    
    private let coordinator: CreateStudyGroupNavigation
    private let viewModel: SelectStudyTimeViewModel
    
    // MARK: - Init
    
    init(coordinator: CreateStudyGroupNavigation, viewModel: SelectStudyTimeViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }
    
    // MARK: - SetUp
    
    override func setupStyles() {
        view.backgroundColor = .white
    }
    
    override func setupAddView() {
        
        [
            dragIndicatorView
        ]   .forEach(dragIndicatorContainerView.addSubview)
        
        [
            dragIndicatorContainerView,
            timeView,
            completeButton
        ]   .forEach(bottomSheetView.addSubview)
        
        [
            backgroundButton,
            bottomSheetView
        ]   .forEach(view.addSubview)
    }
    
    override func setupConstaints() {
        
        backgroundButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalToSuperview()
        }
        
        dragIndicatorContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(24)
            make.height.equalTo(30)
            make.width.equalTo(72)
        }
        
        dragIndicatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(8)
        }
        
        timeView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(dragIndicatorView.snp.bottom).offset(24)
            make.height.equalTo(267)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(dragIndicatorView.snp.bottom).offset(318)
            make.height.equalTo(72)
        }
    }
    
    override func bind() {
        
    }
}


// MARK: - UIUpdate

extension SelectStudyTimeViewController {
    private func showBottomSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetView.snp.updateConstraints { make in
                make.height.equalTo(456)
            }
            self.backgroundButton.alpha = 0.1
            self.view.layoutIfNeeded()
        })
    }
}
