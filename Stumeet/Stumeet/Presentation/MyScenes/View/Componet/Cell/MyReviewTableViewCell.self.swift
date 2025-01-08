//
//  MyReviewTableViewCell.self.swift
//  Stumeet
//
//  Created by 조웅희 on 2025/01/06.
//

import UIKit
import SnapKit

class MyReviewTableViewCell: BaseTableViewCell {
    
    // MARK: - UIComponents
    private let rootView: UIView = {
        let view = UIView()
        view.backgroundColor = StumeetColor.gray50.color
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = StumeetColor.primary50.color.cgColor
        return view
    }()
    
    private let contentsVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let topHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    private let starHStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = StumeetFont.captionMedium13.font
        label.textColor = StumeetColor.gray300.color
        return label
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = StumeetFont.bodyMedium14.font
        label.textColor = StumeetColor.gray700.color
        return label
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = StumeetFont.bodyMedium14.font
        label.textColor = StumeetColor.primary700.color
        return label
    }()
    
    private let tagVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
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
            reviewLabel,
            tagVStackView
        ].forEach { contentsVStackView.addArrangedSubview($0) }
        
        [
            starHStackView,
            dateLabel
        ].forEach { topHStackView.addArrangedSubview($0) }
    }
    
    override func setupConstaints() {
        rootView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(contenntViewPadding)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        contentsVStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(contentsStackViewPadding)
            $0.verticalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Function
    private func setupStarView(rating: Int) {
        clearStackView(starHStackView)

        for i in 0..<maxStars {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.image = UIImage(resource: i < rating ? .My.greenStarFilled : .My.grayStarFilled)
            starHStackView.addArrangedSubview(starImageView)
        }
    }
    
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
    
    func configureCell(_ item: MyReviewItem) {
        setupStarView(rating: item.starCount)
        setupTagView(textArray: item.tags)
        
        dateLabel.text = item.displayDate
        reviewLabel.text = item.reviewText
    }
}
