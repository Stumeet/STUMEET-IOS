//
//  HeaderTapBarView.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/09/03.
//

import UIKit
import SnapKit

protocol HeaderTapBarViewDelegate: AnyObject {
    func didTapAction(_ button: HeaderTapBarView.RadioButton)
}

class HeaderTapBarView: UIView {
    // MARK: - UIComponents
    private var buttonHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    private var buttons: [RadioButton] = []
    
    private let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.primary50.color
        view.alpha = 0
        return view
    }()
    
    // MARK: - Properties
    private(set) var selectedButton: RadioButton? {
        didSet {
            buttons.forEach { $0.isSelected = ($0 == selectedButton) }
        }
    }
    weak var delegate: HeaderTapBarViewDelegate?

    // MARK: - Init
    init(options: [(String, Int)], initSelectedIndex: Int? = nil) {
        super.init(frame: .zero)
        setupAddView()
        setupViews(options: options, selectedIndex: initSelectedIndex)
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAddView() {
        addSubview(buttonHStackView)
        addSubview(bottomSeparatorView)
    }
    
    private func setupViews(options: [(String, Int)], selectedIndex: Int? = nil) {
        for (title, id) in options {
            let button = RadioButton(title: title, id: id)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            buttons.append(button)
            buttonHStackView.addArrangedSubview(button)
        }
        
        if let index = selectedIndex, index >= 0 && index < buttons.count {
            selectedButton = buttons[index]
        }
    }
    
    private func setupConstaints() {
        buttonHStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview()
        }
        
        bottomSeparatorView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(2)
        }
    }

    // MARK: - Function
    @objc private func buttonTapped(_ sender: RadioButton) {
        if sender != selectedButton {
            selectedButton = sender
            delegate?.didTapAction(sender)
        }
    }
    
    func adjustSeparatorAlpha(alpha: CGFloat) {
        bottomSeparatorView.alpha = alpha
    }
}

extension HeaderTapBarView {
    // MARK: - Nested Class
    class RadioButton: UIButton {
        private(set) var id: Int
        
        init(title: String, id: Int) {
            self.id = id
            super.init(frame: .zero)
                        
            var configuration = UIButton.Configuration.plain()
            var container = AttributeContainer()
            container.font = StumeetFont.titleMedium.font
            container.foregroundColor = StumeetColor.primary700.color
            configuration.attributedTitle = AttributedString(title, attributes: container)
            configuration.baseBackgroundColor = .clear
            configuration.contentInsets = .init(top: 16, leading: 8, bottom: 16, trailing: 8)
            self.configuration = configuration
            
            let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
                switch button.state {
                case .selected:
                    button.configuration?.attributedTitle?.foregroundColor = StumeetColor.primary700.color
                default:
                    button.configuration?.attributedTitle?.foregroundColor = StumeetColor.gray300.color
                }
            }
            self.configurationUpdateHandler = buttonStateHandler
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
