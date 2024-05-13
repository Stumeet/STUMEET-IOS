//
//  ActivityMemberSettingViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 5/13/24.
//

import Foundation

class ActivityMemberSettingViewController: BaseViewController {
    // MARK: - UIComponents
    
    // MARK: - Properties
    
    private let coordinator: CreateActivityNavigation
    
    // MARK: - Init
    
    init(coordinator: CreateActivityNavigation) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
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
    
    // MARK: - Bind
    
    override func bind() {
        
    }
}
