//
//  UITextView++Extensions.swift
//  Stumeet
//
//  Created by 정지훈 on 3/24/24.
//

import Combine
import UIKit

extension UITextView {
    var didBeginEditingPublisher: AnyPublisher<Void, Never> {
        NotificationCenter.default.publisher(
            for: UITextView.textDidBeginEditingNotification, object: self
        )
        .map { _ in }
        .eraseToAnyPublisher()
     }
}
