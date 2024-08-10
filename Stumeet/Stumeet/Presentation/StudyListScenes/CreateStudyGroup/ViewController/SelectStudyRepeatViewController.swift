//
//  SelectStudyRepeatViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 8/10/24.
//

import UIKit

protocol SelectStudyRepeatDelegate: AnyObject {
    func didTapCompleteButton(repeatType: String, repeatDates: [String])
}

final class SelectStudyRepeatViewController: BaseViewController {
    
    // MARK: - UIComponents
    
    // MARK: - Properties
    
    weak var delegate: SelectStudyRepeatDelegate?
    
    // MARK: - Init
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - SetUp
    
    override func setupStyles() {
        view.backgroundColor = .black
    }
    
    override func setupAddView() {
        
    }
    
    override func setupConstaints() {
        
    }
    
    override func bind() {
        
    }
}

