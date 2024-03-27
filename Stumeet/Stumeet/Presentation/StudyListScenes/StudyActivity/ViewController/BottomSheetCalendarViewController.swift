//
//  BottomSheetCalendarViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 3/27/24.
//

import UIKit

class BottomSheetCalendarViewController: BaseViewController {
    
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
    
    private let dragIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        view.layer.cornerRadius = 1.5
        view.alpha = 0
        return view
        
    }()
    
    // MARK: - Properties
    private let viewModel = BottomSheetCalendarViewModel()
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycles
    
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
            backgroundButton,
            bottomSheetView
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        
        backgroundButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        bottomSheetView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(536)
            make.bottom.equalToSuperview().offset(536)
        }
    }
    
    // MARK: - Bind
    
    override func bind() {
        let input = BottomSheetCalendarViewModel.Input(
            didTapBackgroundButton: backgroundButton.tapPublisher)
        
        let output = viewModel.transform(input: input)
        
        // 배경 화면 터치시 dismiss
        output.dismiss
            .receive(on: RunLoop.main)
            .sink(receiveValue: hideBottomSheet)
            .store(in: &cancellables)
    }
}

// MARK: - UI Update

extension BottomSheetCalendarViewController {
    
    private func showBottomSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetView.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
            self.backgroundButton.alpha = 0.1
            self.view.layoutIfNeeded()
        })
    }
    
    private func hideBottomSheet() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.bottomSheetView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(536)
                }
                self.backgroundButton.alpha = 0
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                self.dismiss(animated: false)
            })
    }
}
