//
//  DetailActivityPhotoCell.swift
//  Stumeet
//
//  Created by 정지훈 on 5/25/24.
//

import UIKit

final class DetailActivityPhotoCell: BaseCollectionViewCell {
    
    static let identifier = "DetailActivityPhotoCell"
    
    // MARK: - UIComponents
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.zoomScale = 1.0
        return scrollView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .changeProfileCharacter)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    
    override func setupAddView() {
        scrollView.addSubview(imageView)
        addSubview(scrollView)
    }
    
    override func setupConstaints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.height.equalTo(scrollView.snp.height)
            make.edges.equalToSuperview()
        }
    }
    
}

extension DetailActivityPhotoCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
