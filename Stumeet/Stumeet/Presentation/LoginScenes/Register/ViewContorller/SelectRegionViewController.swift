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
    
    lazy var tagCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let layout = CenterAlignCollectionViewLayout()
        
        collectionView.collectionViewLayout = layout
        collectionView.isScrollEnabled = false
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Setup
    
    override func setupStyles() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
    }
    
    override func setupAddView() {
        [
            tagCollectionView
        ]   .forEach { view.addSubview($0) }
    }
    
    override func setupConstaints() {
        tagCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - DataSource
extension SelectRegionViewController: UICollectionViewDataSource {
  
    
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tagList.count
  }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.identifier, for: indexPath) as? TagCell else { return UICollectionViewCell() }
        
        cell.tagLabel.text = tagList[indexPath.item]
        
        return cell
    }
}

// MARK: - Delegate
extension SelectRegionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = tagList[indexPath.item]
        let font = UIFont.systemFont(ofSize: 16)
        let textSize = text.size(withAttributes: [NSAttributedString.Key.font: font])
        
        let cellWidth = textSize.width + 32
        let cellHeight: CGFloat = 40
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}
