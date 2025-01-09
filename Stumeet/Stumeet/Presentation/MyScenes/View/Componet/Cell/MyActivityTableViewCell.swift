//
//  MyActivityTableViewCell.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/09.
//

import UIKit
import SnapKit

class MyActivityTableViewCell: BaseTableViewCell {
    
    // MARK: - UIComponents
    private let rootView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.gray50.color
        view.layer.cornerRadius = 16
        view.setShadow(radius: 5, offset: CGSize(width: 0, height: 4))
        return view
    }()
    
    private let contentsVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let topHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = StumeetFont.bodyMedium16.font
        label.textColor = StumeetColor.gray800.color
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(resource: .My.iconDotsVertical)
        configuration.baseBackgroundColor = .clear
        configuration.contentInsets = .init(top: 1, leading: .zero, bottom: 1, trailing: .zero)
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let timeContainerVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let timeHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private let timeClockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(resource: .My.iconClock)
        return imageView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = StumeetFont.captionMedium13.font
        label.textColor = StumeetColor.gray300.color
        return label
    }()
    
    private let tagContainerVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 17
        return stackView
    }()
    
    private let tagVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()
    
    private let writeReviewButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        
        container.font = StumeetFont.bodysemibold.font
        container.foregroundColor = StumeetColor.gray50.color
        configuration.background.cornerRadius = 8
        configuration.attributedTitle = AttributedString("리뷰 작성하러 가기", attributes: container)
        configuration.baseBackgroundColor = StumeetColor.primary700.color
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        return button
    }()

    // MARK: - Properties
    private let maxStars = 5
    private let contenntViewPadding: CGFloat = 24
    private let contentsStackViewPadding: CGFloat = 24

    // MARK: - Init
    override func setupStyles() {
        selectionStyle = .none
        backgroundColor = .white
    }

    override func setupAddView() {
        contentView.addSubview(rootView)
        
        rootView.addSubview(contentsVStackView)
        
        [
            topHStackView,
            timeContainerVStackView
        ].forEach { contentsVStackView.addArrangedSubview($0) }
        
        [
            titleLabel,
            moreButton
        ].forEach { topHStackView.addArrangedSubview($0) }
        
        [
            timeHStackView,
            tagContainerVStackView
        ].forEach { timeContainerVStackView.addArrangedSubview($0) }
        
        [
            timeClockImageView,
            timeLabel
        ].forEach { timeHStackView.addArrangedSubview($0) }
        
        [
            tagVStackView,
            writeReviewButton
        ].forEach { tagContainerVStackView.addArrangedSubview($0) }

    }
    
    override func setupConstaints() {
        rootView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(contenntViewPadding)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        contentsVStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(contentsStackViewPadding)
            $0.verticalEdges.equalToSuperview().inset(18)
        }
        
        writeReviewButton.snp.makeConstraints {
            $0.height.equalTo(43)
        }
    }
    
    // MARK: - Function
    private func setupTagView(textArray: [String]) {
        clearStackView(tagVStackView)

        var currentHStack = createHStack()
        tagVStackView.addArrangedSubview(currentHStack)
        
        var currentLineWidth: CGFloat = 0
        let spacing: CGFloat = 4
        let maxWidth = UIScreen.main.bounds.width  - (contenntViewPadding * 2) - (contentsStackViewPadding * 2)
        

        textArray.forEach { text in
            // 태그 뷰 생성
            let tagView = createTagView(with: text)
            let tagViewWidth = tagView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width // 태그 너비
            
            // 태그가 현재 라인에 들어갈 수 있는지 확인
            if currentLineWidth + tagViewWidth + spacing > maxWidth {
                currentHStack = createHStack()
                tagVStackView.addArrangedSubview(currentHStack)
                currentLineWidth = 0
            }

            currentHStack.addArrangedSubview(tagView)
            currentLineWidth += tagViewWidth + spacing
        }
    }

    private func createHStack() -> UIStackView {
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.spacing = 4
        hStackView.alignment = .center
        return hStackView
    }

    private func createTagView(with text: String) -> UIView {
        let view = UIView(frame: .init(x: .zero, y: .zero, width: .zero, height: 22))
        view.setRoundCorner()
        view.backgroundColor = StumeetColor.primary50.color

        let label = UILabel()
        label.numberOfLines = 1
        label.font = StumeetFont.captionMedium12.font
        label.textColor = StumeetColor.primary700.color
        label.text = text

        view.addSubview(label)

        view.snp.makeConstraints {
            $0.height.equalTo(22)
        }

        label.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }

        return view
    }
    
    private func clearStackView(_ stackView: UIStackView) {
        stackView.arrangedSubviews.forEach { subview in
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
    
    @objc private func moreButtonTapped(_ sender: UITapGestureRecognizer) {
        print("더보기 바튼")
    }
    
    func configureCell(_ item: MyActivityItem) {
        titleLabel.text = item.displayTitle
        timeLabel.text = item.displayTime
        writeReviewButton.isHidden = !item.isReviewRequired
        
        setupTagView(textArray: item.tags)
    }
}
