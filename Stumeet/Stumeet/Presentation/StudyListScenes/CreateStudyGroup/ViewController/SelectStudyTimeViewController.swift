//
//  SelectStudyTimeViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 8/5/24.
//

import UIKit

import UIKit

final class SelectStudyTimeViewController: BaseViewController {
    
    // MARK: - UIComponents
    
    private let timeView = TimeView()
    
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
    
    // MARK: - SetUp
    
    override func setupStyles() {
        view.backgroundColor = .white
    }
    
    override func setupAddView() {
        
    }
    
    override func setupConstaints() {
        
    }
    
    override func bind() {
        
    }
}

