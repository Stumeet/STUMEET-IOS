//
//  StudyActivityEmptyView.swift
//  Stumeet
//
//  Created by 정지훈 on 7/4/24.
//

import UIKit

import SnapKit

final class StudyActivityEmptyView: UIView {

    // MARK: - UIComponents
    
    private let bookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .studyActivityEmptyBook)
        
        return imageView
    }()
    
    private let contentLabel: UILabel = {
        let text =
"""
아직 활동이 없어요
스터디 활동을 생성해보세요!
"""
        let label = UILabel().setLabelProperty(text: text, font: StumeetFont.bodyMedium15.font, color: .primary300)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyles()
        setupAddViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        isHidden = true
        backgroundColor = StumeetColor.primary50.color
    }
    
    private func setupAddViews() {
        [
            bookImageView,
            contentLabel
        ]   .forEach(addSubview)
    }
    
    private func setupConstraints() {
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-43)
        }
        
        bookImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentLabel.snp.top).offset(-16)
        }
    }
    
}
