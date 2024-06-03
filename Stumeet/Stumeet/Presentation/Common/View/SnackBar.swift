import UIKit
import SnapKit

final class SnackBar: UIView {

    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        setupView(text: text)
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(text: String) {
        self.backgroundColor = StumeetColor.gray800.color
        self.layer.cornerRadius = 16
        let label = setupLabel(text: text)
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
        }
    }

    private func setupLabel(text: String) -> UILabel {
        let label = UILabel().setLabelProperty(text: nil, font: StumeetFont.bodyMedium15.font, color: .gray50)
        
        let attributedText = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: 1)
        attributedText.addAttribute(.foregroundColor, value: StumeetColor.warning500.color, range: range)
        label.attributedText = attributedText
        
        return label
    }
}
