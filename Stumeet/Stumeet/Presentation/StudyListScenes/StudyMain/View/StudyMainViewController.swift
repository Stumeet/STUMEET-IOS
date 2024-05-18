//
//  StudyMainViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/13.
//

import UIKit
import SnapKit

class StudyMainViewController: BaseViewController {
    
    // MARK: - UIComponents
    // TODO: - 임시 코드: 메인 UI 구현시 삭제
    private lazy var sideMenuShowButton: UIButton = {
        let button = UIButton()
        button.setTitle("사이드 메뉴", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(menuOpenButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    private weak var coordinator: StudyListNavigation!
    
    // MARK: - Init
    init(coordinator: StudyListNavigation) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyles() {
        view.backgroundColor = .white
    }
    
    override func setupAddView() {
        view.addSubview(sideMenuShowButton)
    }
    
    override func setupConstaints() {
        sideMenuShowButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Function
    @objc func menuOpenButtonTapped(_ sender: UIButton) {
        coordinator.presentToSideMenu(from: self)
    }
}
