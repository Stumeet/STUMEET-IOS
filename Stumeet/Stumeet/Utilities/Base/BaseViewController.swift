//
//  BaseViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/8/24.
//

import UIKit

import Combine
import SnapKit

class BaseViewController: UIViewController {

    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyles()
        setupAddView()
        setupConstaints()
        bind()
    }

    /// View와 관련된 Style을 설정합니다.
    func setupStyles() {
        
    }
    
    /// UI 컴포넌트 프로퍼티를 View에 할당합니다.
    func setupAddView() {
        
    }
    /// UI 컴포넌트 제약조건을 설정합니다.
    func setupConstaints() {
        
    }
    
    /// Combine bind 로직을 구현합니다.
    func bind() {
        
    }
}
