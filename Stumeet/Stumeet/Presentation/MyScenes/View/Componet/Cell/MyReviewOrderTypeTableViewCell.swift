//
//  MyReviewOrderTypeTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/06.
//

import UIKit
import SnapKit

protocol MyReviewOrderTypeTableViewCellDelegate: AnyObject {
    func didTapOrder()
}

class MyReviewOrderTypeTableViewCell: BaseTableViewCell {
    
    // MARK: - UIComponents
    private lazy var orderButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        
        container.font = StumeetFont.bodyMedium14.font
        container.foregroundColor = StumeetColor.gray300.color
        configuration.image = UIImage(resource: .My.iconAlignLeft)
        configuration.imagePadding = 4
        configuration.imagePlacement = .trailing
        configuration.background.cornerRadius = 16
        configuration.attributedTitle = AttributedString("최신순", attributes: container)
        configuration.baseBackgroundColor = StumeetColor.gray75.color
        configuration.contentInsets = .init(top: 8, leading: 12, bottom: 8, trailing: 12)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Properties
    weak var delegate: MyReviewOrderTypeTableViewCellDelegate?
    
    // MARK: - Init
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .white
    }

    override func setupAddView() {
        contentView.addSubview(orderButton)
    }
    
    override func setupConstaints() {
        orderButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Function
    @objc private func orderButtonTapped(_ sender: UITapGestureRecognizer) {
        delegate?.didTapOrder()
    }
    
    func configureCell(_ orderText: String) {
        
        var container = AttributeContainer()
        container.font = StumeetFont.bodyMedium14.font
        container.foregroundColor = StumeetColor.gray300.color
        
        orderButton.configuration?.attributedTitle = AttributedString(
            orderText,
            attributes: container
        )
    }
}
