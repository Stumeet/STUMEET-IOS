//
//  TextBubbleView.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/11/05.
//

import UIKit
import SnapKit

class TextBubbleView: UIView {
    
    // MARK: - UIComponents
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = StumeetColor.success.color
        return view
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = StumeetFont.captionMedium13.font
        label.textColor = StumeetColor.gray50.color
        return label
    }()
    
    private let tailIconImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: .Common.bubbleTailIconUp)
        return image
    }()
    
    // MARK: - Init
    init(text: String) {
        super.init(frame: .zero)
        setupAddView()
        setupConstaints()
        setupStyles()
        configure(with: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        backgroundColor = .clear
    }
    
    private func setupAddView() {
        addSubview(tailIconImageView)
        addSubview(bubbleView)
        
        bubbleView.addSubview(textLabel)
    }
    
    private func setupConstaints() {
        tailIconImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalTo(bubbleView.snp.trailing).inset(4.3)
            $0.bottom.equalTo(bubbleView.snp.top).offset(4)
        }
        
        bubbleView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.verticalEdges.equalToSuperview().inset(12)
        }
    }
    
    private func configure(with title: String) {
        textLabel.text = title
    }
    
    func show() {
        guard isHidden else { return }
        isHidden = false
        alpha = 0.0
        transform = CGAffineTransform(translationX: 0, y: 30)

        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
            self.transform = .identity
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
            self.transform = CGAffineTransform(translationX: 0, y: 30)
        },
        completion: { _ in
            self.isHidden = true
        })
    }
}
