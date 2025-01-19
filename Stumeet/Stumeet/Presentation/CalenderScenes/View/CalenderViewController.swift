//
//  CalenderViewController.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/19.
//

import UIKit
import SnapKit
import Combine
import SwiftUI

class CalenderViewController: BaseViewController {
    // MARK: - UIComponents
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "캘린더"
        label.font = StumeetFont.titleMedium.font
        label.textColor = StumeetColor.gray800.color
        label.numberOfLines = 0
        return label
    }()
    
    private var rootView: UIHostingController<CalenderScheduleSwiftUIView<CalenderViewModelImpl>>
    
    // MARK: - Properties
    private weak var coordinator: CalenderNavigation!
    private let viewModel: CalenderViewModelImpl

    // MARK: - Init
    init(
        coordinator: CalenderNavigation,
        viewModel: CalenderViewModelImpl
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.rootView = UIHostingController(rootView: CalenderScheduleSwiftUIView(viewModel: viewModel))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupStyles() {
        self.view.backgroundColor = .white
    }
    
    override func setupAddView() {
        addChild(rootView)
        view.addSubview(rootView.view)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationTitleLabel)
    }
    
    override func setupConstaints() {
        rootView.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func bind() {
        // MARK: - Input

        // MARK: - Output
    }
    
    // MARK: - LifeCycle
    
    
    // MARK: - Function
    
}
