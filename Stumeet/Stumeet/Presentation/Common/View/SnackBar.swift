import UIKit
import SnapKit

final class SnackBar: UIView {
    
    private var titleLabel: UILabel = {
        let label = UILabel().setLabelProperty(text: nil, font: StumeetFont.bodyMedium15.font, color: .gray50)
        return label
    }()
    
    init(frame: CGRect, text: String, highlight: Bool = true) {
        super.init(frame: frame)
        setupStyles()
        setupView()
        setupConstaints()
        setupLabel(text: text, highlight: highlight)
        isHidden = true
    }
    
    init() {
        super.init(frame: .zero)
        setupStyles()
        setupView()
        setupConstaints()
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyles() {
        backgroundColor = StumeetColor.gray800.color
        layer.cornerRadius = 16
    }
    
    private func setupConstaints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
        
    private func setupView() {
        addSubview(titleLabel)
    }

    func setupLabel(text: String, highlight: Bool) {
        if highlight {
            let attributedText = NSMutableAttributedString(string: text)
            let range = NSRange(location: 0, length: 1)
            attributedText.addAttribute(.foregroundColor, value: StumeetColor.warning500.color, range: range)
            titleLabel.attributedText = attributedText
        } else {
            titleLabel.text = text
        }
    }
}
