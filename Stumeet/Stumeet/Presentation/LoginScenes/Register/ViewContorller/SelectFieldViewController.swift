//
//  SelectFieldViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/10/24.
//

import UIKit

class SelectFieldViewController: BaseViewController {

    let tagList: [String] = [
        "IT",
        "출판",
        "디자인",
        "마케팅/기록",
        "어학",
        "취업준비",
        "자연계",
        "방송",
        "자율스터디",
        "경제",
        "자격증",
        "인문계",
        "봉사활동"
      ]
    
    // MARK: - UIComponents
    
    let titleLabel: UILabel = {
        let label = UILabel().setLabelProperty(
            text: "분야를 선택해주세요",
            font: .boldSystemFont(ofSize: 20),
            color: nil)
        
        return label
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.backgroundColor = StumeetColor.primary50.color
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        
        let rightImageView = UIImageView(
            image: UIImage(systemName: "magnifyingglass")?.withTintColor(StumeetColor.primary700.color)
        )
        rightImageView.tintColor = .gray
        rightImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        // TODO: - Image 변경 후 수정
        
        textField.rightView = rightImageView
        textField.rightViewMode = .always
        textField.addLeftPadding(24)
        
        return textField
    }()

    lazy var tagCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let layout = CenterAlignCollectionViewLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        
        collectionView.collectionViewLayout = layout
        collectionView.isScrollEnabled = false
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    
    lazy var nextButton: UIButton = {
        let button = UIButton().makeRegisterBottomButton(text: "다음", color: StumeetColor.gray200.color)
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Setup
    
    override func setupStyles() {
        view.backgroundColor = .white
    }
    
    override func setupAddView() {
        [
            titleLabel,
            searchTextField,
            tagCollectionView,
            nextButton
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(34)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(14)
            make.top.equalTo(searchTextField.snp.bottom).offset(32)
            make.height.equalTo(208)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.bottom.equalToSuperview().inset(34)
            make.trailing.leading.equalToSuperview().inset(16)
        }
    }
}

// MARK: - DataSource
extension SelectFieldViewController: UICollectionViewDataSource {
  
    
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tagList.count
  }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: TagCell.identifier,
                for: indexPath
            ) as? TagCell
        else { return UICollectionViewCell() }
        
        cell.tagLabel.text = tagList[indexPath.item]
        
        return cell
    }
}

// MARK: - Delegate
extension SelectFieldViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = tagList[indexPath.item]
        let font = UIFont.systemFont(ofSize: 16)
        let textSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
        
        let cellWidth = textSize.width + 32
        let cellHeight: CGFloat = 40
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

// MARK: Objc Function

extension SelectFieldViewController {
    
    @objc func didTapNextButton(_ sender: UIButton) {
        let startVC = StartViewController()
        startVC.modalPresentationStyle = .fullScreen
        
        present(startVC, animated: true)
    }
}
