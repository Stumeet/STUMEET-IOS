//
//  MyEvaluationSeeMoreTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/06.
//

import UIKit
import SnapKit
import Kingfisher

protocol MyEvaluationSeeMoreTableViewCellDelegate: AnyObject {
    func didTapSeeMore(_ toggleState: Bool)
}

class MyEvaluationSeeMoreTableViewCell: BaseTableViewCell {
    
    // MARK: - UIComponents
    private lazy var seeMoreButtonView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(seeMoreButtonViewTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private var seeMoreButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .My.iconArrowDown)
        return imageView
    }()

    // MARK: - Properties
    weak var delegate: MyEvaluationSeeMoreTableViewCellDelegate?
    private var isUp: Bool = true
    
    // MARK: - Init
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .white
    }

    override func setupAddView() {
        contentView.addSubview(seeMoreButtonView)
        seeMoreButtonView.addSubview(seeMoreButtonImageView)
    }
    
    override func setupConstaints() {
        seeMoreButtonView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.verticalEdges.equalToSuperview()
        }
        
        seeMoreButtonImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Function
    @objc private func seeMoreButtonViewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.didTapSeeMore(isUp)
    }
    
    func configureCell(_ isUp: Bool) {
        self.isUp = isUp
        seeMoreButtonImageView.image = UIImage(resource: self.isUp ? .My.iconArrowUp : .My.iconArrowDown)
    }
}
