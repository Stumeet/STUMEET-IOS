//
//  DetailActivityPhotoListViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import Foundation

final class DetailActivityPhotoListViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let coordinator: StudyListNavigation
    private let viewModel: DetailActivityPhotoListViewModel
    
    init(coordinator: StudyListNavigation, viewModel: DetailActivityPhotoListViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyles() {
        view.backgroundColor = .white
    }
}
