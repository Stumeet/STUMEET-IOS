//
//  UIImageView++Extension.swift
//  Stumeet
//
//  Created by UNGHUI CHO on 3/27/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(from urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        
        self.kf.setImage(with: url)
    }
}
