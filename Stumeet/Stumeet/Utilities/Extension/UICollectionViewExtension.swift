//
//  UICollectionView++Extension.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/05/26.
//

import UIKit
// TODO: - 브렌치 머지 시 수정 필요
extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.defaultIdentifier)
    }
    
    func dequeue<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: T.defaultIdentifier, for: indexPath) as? T
    }
}

extension UICollectionViewCell {
    class var defaultIdentifier: String { return String(describing: self) }
}
