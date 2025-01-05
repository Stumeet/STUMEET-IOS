//
//  CenterHeaderTabView.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/06.
//

import UIKit
import SnapKit

protocol CenterHeaderTabViewDelegate: AnyObject {
    func didTapAction(_ button: CenterHeaderTabView.RadioButton)
}

class CenterHeaderTabView: UIView {
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
    weak var delegate: CenterHeaderTabViewDelegate?

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
            $0.edges.equalToSuperview()
            $0.height.equalTo(49)
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

extension CenterHeaderTabView {
    // MARK: - Nested Class
    class RadioButton: UIButton {
        private(set) var id: Int
        private let underlineView: UIView = {
            let view = UIView()
            view.backgroundColor = StumeetColor.primary700.color
            view.isHidden = true
            return view
        }()
        
        init(title: String, id: Int) {
            self.id = id
            super.init(frame: .zero)
                        
            var configuration = UIButton.Configuration.plain()
            var container = AttributeContainer()
            container.font = StumeetFont.bodyMedium14.font
            container.foregroundColor = StumeetColor.primary700.color
            configuration.attributedTitle = AttributedString(title, attributes: container)
            configuration.baseBackgroundColor = .clear
            self.configuration = configuration
            
            addSubview(underlineView)
            
            underlineView.snp.makeConstraints {
                $0.bottom.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(0.6)
                $0.height.equalTo(2)
            }
            
            underlineView.setRoundCorner()
            
            let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { [weak self] button in
                guard let self else { return }
                switch button.state {
                case .selected:
                    button.configuration?.attributedTitle?.foregroundColor = StumeetColor.primary700.color
                    underlineView.isHidden = false
                default:
                    button.configuration?.attributedTitle?.foregroundColor = StumeetColor.gray300.color
                    underlineView.isHidden = true
                }
            }
            self.configurationUpdateHandler = buttonStateHandler
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
