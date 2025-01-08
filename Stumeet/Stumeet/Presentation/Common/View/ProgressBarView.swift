//
//  ProgressBarView.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/09.
//

import UIKit
import SnapKit

class ProgressBarView: UIView {
    // MARK: - UIComponents
    private var backgroundBar: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.primary50.color
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private var progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.primary100.color
        view.layer.cornerRadius = 16
        return view
    }()
    
    // MARK: - Properties

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupAddView()
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAddView() {
        addSubview(backgroundBar)
        backgroundBar.addSubview(progressBar)
    }
    
    private func setupConstaints() {
        backgroundBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        progressBar.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Function
    func setProgress(_ progress: Float) {
        let boundedProgress = max(0, min(progress, 1))
        
        progressBar.snp.remakeConstraints {
            $0.leading.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
            $0.trailing.equalToSuperview().multipliedBy(boundedProgress)
        }
    }
}

