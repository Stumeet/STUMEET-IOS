//
//  StudyMemberDetailContextMenuView.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/19.
//

import UIKit
import SnapKit

class StudyMemberDetailContextMenuView: UIView {
    // MARK: - UIComponents
    private let rootVStackView = UIStackView()
    
    // MARK: - Properties
    var isVisiblyHidden: Bool {
        get { return isHidden }
        
        set {
            if newValue {
                self.transform = .identity
                animate(transform: CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1), isShow: !newValue) {
                    self.isHidden = true
                }
            } else {
                self.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                isHidden = false
                animate(transform: .identity, isShow: !newValue)
            }
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyles()
        setupAddView()
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyles() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = StumeetColor.gray100.color.cgColor
        layer.cornerRadius = 12
        
        setShadow()
        
        rootVStackView.axis = .vertical
    }
    
    private func setupAddView() {
        addSubview(rootVStackView)
    }

    private func setupConstaints() {
        rootVStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Function
    private func animate(transform: CGAffineTransform, isShow: Bool, completion: (() -> Void)? = nil) {
        layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.curveEaseInOut, .beginFromCurrentState],
                       animations: {
            
            self.transform = transform
            self.alpha = isShow ? 1 : 0
            
        }, completion: { _ in
            completion?()
        })
    }
    
    func addItem(title: String, textColor: UIColor = StumeetColor.gray400.color, action: UIAction) {
        var configuration = UIButton.Configuration.plain()
        var container = AttributeContainer()
        container.font = StumeetFont.bodyMedium14.font
        container.foregroundColor = textColor
        configuration.attributedTitle = AttributedString(title, attributes: container)
        configuration.contentInsets = .init(top: 10, leading: 16, bottom: 10, trailing: 16)
        
        let button = UIButton(configuration: configuration)
        button.addAction(action, for: .touchUpInside)

        rootVStackView.addArrangedSubview(button)
    }
}
