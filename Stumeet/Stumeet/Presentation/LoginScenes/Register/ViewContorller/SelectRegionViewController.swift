//
//  SelectRegionViewController.swift
//  Stumeet
//
//  Created by 정지훈 on 2/10/24.
//

import UIKit

class SelectRegionViewController: BaseViewController {

    let tagList: [String] = [
        "서울",
        "인천/경기",
        "전북",
        "전남",
        "강원",
        "경북",
        "경남",
        "충북",
        "충남",
        "제주"
      ]
    
    // MARK: - UIComponents
    
    let titleLabel: UILabel = {
        let label = UILabel().setLabelProperty(
            text: "지역을 선택해주세요",
            font: .boldSystemFont(ofSize: 20),
            color: nil)
        
        return label
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
            tagCollectionView,
            nextButton
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(34)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.height.equalTo(96)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.bottom.equalToSuperview().inset(34)
            make.trailing.leading.equalToSuperview().inset(16)
        }
    }
}

// MARK: - DataSource
extension SelectRegionViewController: UICollectionViewDataSource {
  
    
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tagList.count
  }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCell.identifier,
            for: indexPath) as? TagCell
        else { return UICollectionViewCell() }
        
        cell.tagLabel.text = tagList[indexPath.item]
        
        return cell
    }
}

// MARK: - Delegate
extension SelectRegionViewController: UICollectionViewDelegateFlowLayout {
    
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

extension SelectRegionViewController {
    
    @objc func didTapNextButton(_ sender: UIButton) {
        navigationController?.pushViewController(SelectFieldViewController(), animated: true)
    }
}
