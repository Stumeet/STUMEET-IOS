//
//  HomeViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/21/24.
//

import UIKit

class HomeViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

}
