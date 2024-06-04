//
//  UITableView++Extension.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/04/15.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(_: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeue<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T
    }
}

extension UITableViewCell {
    class var identifier: String { return String(describing: self) }
}
