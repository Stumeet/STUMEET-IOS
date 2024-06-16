//
//  HomeViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/21/24.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    private weak var coordinator: HomeNavigation!
    
    // MARK: - Init
    init( coordinator: HomeNavigation ) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyles() {
        view.backgroundColor = .white
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogoutNotification()
    }
    
    // MARK: - Function
    // TODO: - 토큰 만료 플로우 및 로그아웃 처리 기획이 나오는대로 수정
    private func setupLogoutNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogout), name: .userDidLogout, object: nil)
    }
    
    @objc func handleLogout() {
        DispatchQueue.main.async {
            self.coordinator.presentLogoutAlert()
        }
    }
}
