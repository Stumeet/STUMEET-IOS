//
//  StudyActivityViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 6/8/24.
//

import Combine
import UIKit

class StudyActivityViewController: BaseViewController {

    // MARK: - UIComponents
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    private let allButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체", for: .normal)
        button.setTitleColor(StumeetColor.gray300.color, for: .normal)
        button.setTitleColor(StumeetColor.primaryInfo.color, for: .selected)
        button.isSelected = true
        button.titleLabel?.font = StumeetFont.titleSemibold.font
        
        return button
    }()
    
    private let groupButton: UIButton = {
        let button = UIButton()
        button.setTitle("모임", for: .normal)
        button.setTitleColor(StumeetColor.gray300.color, for: .normal)
        button.setTitleColor(StumeetColor.primaryInfo.color, for: .selected)
        button.titleLabel?.font = StumeetFont.titleMedium.font
        button.sizeToFit()
        return button
    }()
    
    private let taskButton: UIButton = {
        let button = UIButton()
        button.setTitle("과제", for: .normal)
        button.setTitleColor(StumeetColor.gray300.color, for: .normal)
        button.setTitleColor(StumeetColor.primaryInfo.color, for: .selected)
        button.titleLabel?.font = StumeetFont.titleMedium.font
        
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private lazy var xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .xMark).withTintColor(StumeetColor.gray800.color), for: .normal)
        return button
    }()
    
    private lazy var xBarButton: UIBarButtonItem = {
        return UIBarButtonItem(customView: xButton)
    }()
    
    private let floatingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addFloatingButton"), for: .normal)
        
        return button
    }()
    
    // MARK: - Properties
    
    private let viewControllers: [UIViewController]
    private let viewModel: StudyActivityViewModel
    private let coordinator: StudyListNavigation
    
    // MARK: - Subject
    
    private let previousIndexSubject = CurrentValueSubject<Int, Never>(0)
    private let slidedIndexSubject = CurrentValueSubject<Int, Never>(0)
    
    // MARK: - Init
    
    init(viewControllers: [UIViewController], viewModel: StudyActivityViewModel, coordinator: StudyListNavigation) {
        self.viewControllers = viewControllers
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let firstVC = viewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    override func setupStyles() {
        view.backgroundColor = .white
        configureXButtonTitleNavigationBarItems(button: xBarButton, title: "활동")
    }
    
    override func setupAddView() {
        [
            allButton,
            groupButton,
            taskButton
        ]   .forEach(buttonStackView.addArrangedSubview)
        
        [
            buttonStackView,
            pageViewController.view,
            floatingButton
        ]   .forEach(view.addSubview)
    }
    
    override func setupConstaints() {
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(56)
            make.width.equalTo(137)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(48)
            make.width.height.equalTo(72)
        }
    }
    
    override func bind() {
        let input = StudyActivityViewModel.Input(
            didTapAllButton: allButton.tapPublisher,
            didTapGroupButton: groupButton.tapPublisher,
            didTapTaskButton: taskButton.tapPublisher,
            didChangedIndex: previousIndexSubject.eraseToAnyPublisher(),
            didSlideIndex: slidedIndexSubject.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.selectedButtonIndex
            .combineLatest(output.previousIndex)
            .receive(on: RunLoop.main)
            .sink(receiveValue: setSelectedViewController)
            .store(in: &cancellables)
        
        output.slideIndex
            .receive(on: RunLoop.main)
            .sink(receiveValue: updateButtonSelection)
            .store(in: &cancellables)
    }
}

// MARK: - PageViewControllerDatsource, Delegate

extension StudyActivityViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index > 0 else { return nil }
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < viewControllers.count - 1 else { return nil }
        return viewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let targetVC = pendingViewControllers.first,
              let targetIndex = viewControllers.firstIndex(of: targetVC)
        else { return }
        slidedIndexSubject.send(targetIndex)
    }
}

// MARK: - UpdateUI

extension StudyActivityViewController {
    private func setSelectedViewController(index: Int, previousIndex: Int) {
        let selectedVC = viewControllers[index]
        let direction: UIPageViewController.NavigationDirection = index > previousIndex ? .forward : .reverse
        
        updateButtonSelection(index: index)
        pageViewController.setViewControllers([selectedVC], direction: direction, animated: true)
        previousIndexSubject.send(index)
    }
    
    private func updateButtonSelection(index: Int) {
        allButton.isSelected = index == 0
        groupButton.isSelected = index == 1
        taskButton.isSelected = index == 2
    }
}
