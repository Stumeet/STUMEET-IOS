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
        view.backgroundColor = #colorLiteral(red: 0.8797428012, green: 0.8797428012, blue: 0.8797428012, alpha: 1)
        view.layer.cornerRadius = 7
        return view
        
    }()
    
    private let dragIndicatorContainerView = UIView()
    
    // MARK: - Properties
    
    private let viewModel = BottomSheetCalendarViewModel(useCase: DefualtBottomSheetCalendarUseCase())
    
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
            dragIndicatorView
        ]   .forEach { dragIndicatorContainerView.addSubview($0) }
        
        
        [
            dragIndicatorContainerView
        ]   .forEach { bottomSheetView.addSubview($0) }
        
        [
            backgroundButton,
            bottomSheetView
        ]   .forEach { view.addSubview($0) }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        dragIndicatorContainerView.addGestureRecognizer(panGesture)
        
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
        
        // bottomSheet 높이 조정
        output.adjustHeight
            .receive(on: RunLoop.main)
            .sink { [weak self] newHeight in
                self?.adjustBottomSheetHeight(newHeight)
            }
            .store(in: &cancellables)
        
        // bottomSheet 최대 높이로 되돌리기, 없애기
        output.isRestoreBottomSheetView
            .receive(on: RunLoop.main)
            .sink { [weak self] isRestore in
                if isRestore {
                    self?.hideBottomSheet()
                } else {
                    self?.showBottomSheet()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UI Update

extension BottomSheetCalendarViewController {
    
    // bottomSheetView 드래그에 맞게 높이 조정
    private func adjustBottomSheetHeight(_ height: CGFloat) {
        self.bottomSheetView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        self.view.layoutIfNeeded()
    }
    
    // bottomSheetView 보이기
    private func showBottomSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetView.snp.updateConstraints { make in
                make.height.equalTo(536)
            }
            self.backgroundButton.alpha = 0.1
            self.view.layoutIfNeeded()
        })
    }
    
    // bottomSheetView 숨기기
    private func hideBottomSheet() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.bottomSheetView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
                self.backgroundButton.alpha = 0
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                self.dismiss(animated: false)
            })
    }
}

// MARK: - ObjcFunc

extension BottomSheetCalendarViewController {
    
    // indicatorView 드래그 감지
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let state: BottomSheetCalendarViewModel.DragState
        switch gesture.state {
        case .began: state = .began
        case .changed: state = .changed
        case .ended: state = .ended
        case .cancelled: state = .cancelled
        default: return
        }
        
        let translation = gesture.translation(in: self.view)
        let velocity = gesture.velocity(in: self.view)
        let dragInfo = BottomSheetCalendarViewModel.DragInfo(
            state: state,
            translationY: translation.y,
            velocityY: velocity.y,
            bottomSheetViewHeight: self.bottomSheetView.frame.height)
        
        viewModel.dragEventSubject.send(dragInfo)
        gesture.setTranslation(.zero, in: self.view)
    }
}
