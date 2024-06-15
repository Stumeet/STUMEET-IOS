//
//  ActivityPlaceSettingViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 6/15/24.
//

import UIKit

protocol CreateActivityPlaceDelegate: AnyObject {
    
}

class ActivityPlaceSettingViewController: BaseViewController {

    
    // MARK: - UIComponents
    
    // MARK: - Properties
    
    private let coordinator: CreateActivityNavigation
    weak var delegate: CreateActivityPlaceDelegate?
    
    // MARK: - Init
    
    init(coordinator: CreateActivityNavigation) {
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
        
    }
    
    override func setupAddView() {
        
    }
    
    override func setupConstaints() {
        
    }
    
    // MARK: - Bind
    
    override func bind() {
        
    }

}
