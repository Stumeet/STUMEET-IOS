//
//  CreateActivityLinkPopUpViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 6/7/24.
//

import UIKit

final class CreateActivityLinkPopUpViewController: BaseViewController {

    // MARK: - UIComponents
    
    // MARK: - Properties
    
    private let viewModel: CreateActivityLinkPopUpViewModel
    private let coordinator: CreateActivityNavigation
    
    // MARK: - Init
    
    init(viewModel: CreateActivityLinkPopUpViewModel, coordinator: CreateActivityNavigation) {
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
    }
    
    // MARK: - SetUp
    
    override func setupStyles() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
    }
    
    override func setupAddView() {
        
    }
    
    override func setupConstaints() {
        
    }
    
    override func bind() {
        
    }
    
}
