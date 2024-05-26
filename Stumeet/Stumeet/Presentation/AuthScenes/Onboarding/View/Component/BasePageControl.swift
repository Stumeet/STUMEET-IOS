//
//  BasePageControl.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/25.
//

import UIKit

// TODO: - 공통으로 옮겨도 될듯 네이밍도 변경
public class BasePageControl: UIPageControl {
    // MARK: - Private Properties
    private var selectedIndex: Int = 0
    private var remainingDecimal: CGFloat = 0
    private var selectedColor: UIColor = .clear {
        didSet {
            reset()
        }
    }
    
    private var unselectedColor: UIColor = .clear {
        didSet {
            reset()
        }
    }
    
    // MARK: - Public Properties
    public var dotRadius: CGFloat = 4 {
        didSet {
            reset()
        }
    }
    
    public var dotSpacings: CGFloat = 8 {
        didSet {
            reset()
        }
    }
    
    public override var numberOfPages: Int {
        didSet {
            reset()
        }
    }
    /// Currently selected page.
    /// The first page is 1 and not 0.
    public override var currentPage: Int {
        didSet {
            reset()
        }
    }
    
    public override var pageIndicatorTintColor: UIColor? {
        get {
            unselectedColor
        }
        set {
            unselectedColor = newValue ?? .clear
        }
    }
    
    public override var currentPageIndicatorTintColor: UIColor? {
        get {
            selectedColor
        }
        set {
            selectedColor = newValue ?? .clear
        }
    }
    
    // MARK: - Public Functions
    public override func draw(_ rect: CGRect) {
        guard numberOfPages > 0 else { return }
        for index in 0 ... numberOfPages {
            guard index != selectedIndex + 1 else { continue }
            let previousCirclesX = CGFloat(index) * (dotSpacings + (dotRadius * 2))
            var percentageWidth: CGFloat = 0
            var originX: CGFloat = previousCirclesX
            var barColor: UIColor = selectedColor
            switch index {
            case selectedIndex:
                percentageWidth = dotRadius * 2 + ((dotRadius * 2 + dotSpacings) * (1 - self.remainingDecimal))
                barColor = selectedColor.between(unselectedColor, percentage: remainingDecimal)
            case selectedIndex + 2:
                percentageWidth = dotRadius * 2 + ((dotRadius * 2 + dotSpacings) * (self.remainingDecimal))
                originX = previousCirclesX - percentageWidth + dotRadius * 2
                barColor = unselectedColor.between(selectedColor, percentage: remainingDecimal)
            default:
                percentageWidth = dotRadius * 2
                barColor = unselectedColor
            }
            barColor.setFill()
            let bezierPath = UIBezierPath(roundedRect: .init(x: originX,
                                                             y: 0,
                                                             width: percentageWidth,
                                                             height: dotRadius * 2),
                                          cornerRadius: dotRadius)
            bezierPath.fill()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        let spacesWidth = CGFloat(numberOfPages) * dotSpacings
        let dotsWidth = CGFloat(numberOfPages + 1) * (dotRadius * 2)
        return .init(width: spacesWidth + dotsWidth, height: dotRadius * 2)
    }
    
    public func setOffset(_ offset: CGFloat, width: CGFloat) {
        guard width > 0 else { return }
        
        selectedIndex = Int(offset / width)
        remainingDecimal = offset / width - CGFloat(selectedIndex)
        setNeedsDisplay()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.setOffset(scrollView.contentOffset.x, width: scrollView.bounds.width)
    }
    
    // MARK: - Private Functions
    private func reset() {
        self.invalidateIntrinsicContentSize()
        self.setNeedsDisplay()
    }
    
}
