//
//  BasePageControl.swift
//  Stumeet
//
//  Created by 조웅희 on 2024/02/25.
//

import UIKit

struct RGBAColor {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat
}

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
                barColor = between(selectedColor, and: unselectedColor, percentage: remainingDecimal)
            case selectedIndex + 2:
                percentageWidth = dotRadius * 2 + ((dotRadius * 2 + dotSpacings) * (self.remainingDecimal))
                originX = previousCirclesX - percentageWidth + dotRadius * 2
                barColor = between(unselectedColor, and: selectedColor, percentage: remainingDecimal)
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
    
    private func between(_ color1: UIColor, and color2: UIColor, percentage: CGFloat) -> UIColor {
        let clampedPercentage = max(min(percentage, 1), 0)

        let initialColor = RGBAColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        var rgba1 = initialColor
        var rgba2 = initialColor
        
        color1.getRed(&rgba1.red, green: &rgba1.green, blue: &rgba1.blue, alpha: &rgba1.alpha)
        color2.getRed(&rgba2.red, green: &rgba2.green, blue: &rgba2.blue, alpha: &rgba2.alpha)
        
        let mixedRed = rgba1.red + (rgba2.red - rgba1.red) * clampedPercentage
        let mixedGreen = rgba1.green + (rgba2.green - rgba1.green) * clampedPercentage
        let mixedBlue = rgba1.blue + (rgba2.blue - rgba1.blue) * clampedPercentage
        let mixedAlpha = rgba1.alpha + (rgba2.alpha - rgba1.alpha) * clampedPercentage
        
        return UIColor(red: mixedRed, green: mixedGreen, blue: mixedBlue, alpha: mixedAlpha)
    }
}
