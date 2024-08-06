//
//  SelectStudyTimeViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 8/5/24.
//

import Combine
import UIKit

protocol SelectStudyTimeDelegate: AnyObject {
    func didTapCompleteButton(time: String)
}

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
    weak var delegate: SelectStudyTimeDelegate?
    
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
        
        let didTapHourButtonPublisher = Publishers.MergeMany(timeView.hourButtons.enumerated()
            .map { index, button in button.tapPublisher.map { index } })
        
        let didTapMinuteButtonPublisher = Publishers.MergeMany(timeView.minuteButtons.enumerated()
            .map { index, button in button.tapPublisher.map { index } })
        
        let input = SelectStudyTimeViewModel.Input(
            didTapHourButton: didTapHourButtonPublisher.eraseToAnyPublisher(),
            didTapMinuteButton: didTapMinuteButtonPublisher.eraseToAnyPublisher(),
            didTapAmButtonTapPublisher: timeView.amButton.tapPublisher,
            didTapPmButtonTapPublisher: timeView.pmButton.tapPublisher,
            didTapCompleteButton: completeButton.tapPublisher
        )
        
        let output = viewModel.transform(input: input)
        
        output.isSelectedHours
            .receive(on: RunLoop.main)
            .sink(receiveValue: timeView.updateHourButton)
            .store(in: &cancellables)
        
        // 분 버튼 UI 업데이트
        output.isSelectedMinute
            .receive(on: RunLoop.main)
            .sink(receiveValue: timeView.updateMinuteButton)
            .store(in: &cancellables)
        
        output.isSelectedAmButton
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isSelected in
                self?.updateAmTimeView(isSelected: isSelected)
                self?.updatePmTimeView(isSelected: isSelected)
            })
            .store(in: &cancellables)
        
        output.isEnableCompleteButton
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateCompleteButton)
            .store(in: &cancellables)
        
        output.completedTime
            .receive(on: RunLoop.main)
            .sink { [weak self] time in
                self?.delegate?.didTapCompleteButton(time: time)
                self?.coordinator.dismiss()
            }
            .store(in: &cancellables)
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
    
    private func updateAmTimeView(isSelected: Bool) {
        if isSelected {
            timeView.amButton.setTitleColor(StumeetColor.primary700.color, for: .normal)
            timeView.amButton.layer.borderColor = StumeetColor.primary700.color.cgColor
            timeView.amButton.layer.borderWidth = 1
            timeView.amButton.backgroundColor = .white
        } else {
            timeView.amButton.setTitleColor(StumeetColor.gray400.color, for: .normal)
            timeView.amButton.backgroundColor = StumeetColor.gray75.color
            timeView.amButton.layer.borderWidth = 0
        }
    }

    private func updatePmTimeView(isSelected: Bool) {
        if isSelected {
            timeView.pmButton.setTitleColor(StumeetColor.gray400.color, for: .normal)
            timeView.pmButton.backgroundColor = StumeetColor.gray75.color
            timeView.pmButton.layer.borderWidth = 0
        } else {
            timeView.pmButton.setTitleColor(StumeetColor.primary700.color, for: .normal)
            timeView.pmButton.layer.borderColor = StumeetColor.primary700.color.cgColor
            timeView.pmButton.layer.borderWidth = 1
            timeView.pmButton.backgroundColor = .white
        }
    }
    
    private func updateCompleteButton(isEnable: Bool) {
        completeButton.backgroundColor = isEnable ? StumeetColor.primary700.color : StumeetColor.gray200.color
        completeButton.isEnabled = isEnable
    }
}
