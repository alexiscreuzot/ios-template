//
//  CardView.swift
//  template
//
//  Created by Alexis Creuzot on 02/08/2019.
//  Copyright © 2019 waverlylabs. All rights reserved.
//

import UIKit

struct CardCornerRadii {
    var topLeft : CGFloat
    var topRight : CGFloat
    var bottomRight : CGFloat
    var bottomLeft : CGFloat
    
    init(topLeft: CGFloat
        , topRight : CGFloat
        , bottomRight : CGFloat
        , bottomLeft : CGFloat) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomRight = bottomRight
        self.bottomLeft = bottomLeft
    }
    
    init(radius : CGFloat) {
        self.topLeft = radius
        self.topRight = radius
        self.bottomRight = radius
        self.bottomLeft = radius
    }
}

struct CardArrows {
    var width : CGFloat
    var top : CGFloat
    var right : CGFloat
    var bottom : CGFloat
    var left : CGFloat
    
    init(width : CGFloat
        , top: CGFloat
        , right : CGFloat
        , bottom : CGFloat
        , left : CGFloat) {
        self.width = width
        self.top = top
        self.right = right
        self.bottom = bottom
        self.left = left
    }
    
    init(width: CGFloat, heights: CGFloat) {
        self.width = width
        self.top = heights
        self.right = heights
        self.bottom = heights
        self.left = heights
    }
    
    init() {
        self.width = 0
        self.top = 0
        self.right = 0
        self.bottom = 0
        self.left = 0
    }
}

class CardView : UIView {
    
    typealias CardSelectBlock = (() -> Void)
    
    static let badgeDiameter: CGFloat = 15
    static let outAnimationDuration: CGFloat = 0.3
    static let inAnimationDuration: CGFloat = 0.16
    
    override var backgroundColor: UIColor? {
        set {
            self.fillColor = newValue ?? .clear
            self.setNeedsLayout()
        }
        get {
            return  self.fillColor
        }
    }
    
    var cardArrows : CardArrows =  CardArrows() {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var cardCornerRadii : CardCornerRadii = CardCornerRadii(radius: 14) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var button = UIButton.init(type: .custom)
    
    private var badgeView: UIView!
    private var shadowLayer: CAShapeLayer!
    private var strokeLayer: CAShapeLayer!
    private var fillColor: UIColor = .clear
    private var onClick: CardSelectBlock? = nil {
        didSet {
            button.isUserInteractionEnabled = isInteractive
        }
    }
    private var needAnimateOut: Bool = false
    private var animEnded: Bool = false
    
    public var showBadge : Bool = false {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    public var badgeColor : UIColor = .white
    public var badgeSize : CGFloat = 15
    
    var isInteractive : Bool {
        return onClick != nil
    }

    var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
        didSet {
            self.setNeedsLayout()
        }
    }
    var shadowOpacity: Float = 0.22 {
        didSet {
            self.setNeedsLayout()
        }
    }
    var shadowRadius: CGFloat = 6 {
        didSet {
            self.setNeedsLayout()
        }
    }
    var borderWidth: CGFloat = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    var borderColor: UIColor? = .clear {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public func setOnClick(_ onClick: @escaping CardSelectBlock) {
        self.onClick = onClick
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.isUserInteractionEnabled = isInteractive
        button.backgroundColor = .clear
        self.addSubview(button)
        
        button.addTarget(self, action: #selector(self.animateIn), for: .touchDown)
        button.addTarget(self, action: #selector(self.animateIn), for: .touchDragEnter)
        button.addTarget(self, action: #selector(self.animateOut), for: .touchDragExit)
        button.addTarget(self, action: #selector(self.animateOut), for: .touchCancel)
        button.addTarget(self, action: #selector(self.animateOutAndComplete), for: .touchUpInside)
        
        badgeView = UIView()
        badgeView.backgroundColor = .white
        self.addSubview(badgeView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.frame = self.bounds
        
        badgeView.isHidden = !showBadge
        if showBadge {
            var rect = self.bounds
            rect.origin.x = self.bounds.width - self.badgeSize
            rect.size.height = self.badgeSize
            rect.size.width = self.badgeSize
            badgeView.frame = rect
            badgeView.layer.cornerRadius = self.badgeSize / 2
            badgeView.backgroundColor = self.badgeColor
        }
                
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            layer.insertSublayer(shadowLayer, at: 0)
        }
        
        if let shadowLayer = shadowLayer {
            shadowLayer.frame = self.bounds
            shadowLayer.path = self.constructPath(with: cardCornerRadii,
                                                  arrows: cardArrows,
                in: self.bounds).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = shadowOffset
            shadowLayer.shadowOpacity = shadowOpacity
            shadowLayer.shadowRadius = shadowRadius
        }
        
        if strokeLayer == nil {
            strokeLayer = CAShapeLayer()
            layer.insertSublayer(strokeLayer, above: shadowLayer)
        }
        
        if let strokeLayer = strokeLayer {
            var rect = self.bounds
            rect.origin.x = borderWidth / 2
            rect.origin.y = borderWidth / 2
            rect.size.width = self.bounds.width - borderWidth
            rect.size.height = self.bounds.height - borderWidth
            strokeLayer.frame = self.bounds
            
            let raddi = CardCornerRadii.init(radius: cardCornerRadii.topLeft * 0.6)
            
            strokeLayer.path = self.constructPath(with: raddi,
                                                  arrows: cardArrows,
                in: rect).cgPath
            strokeLayer.fillColor = UIColor.clear.cgColor
            strokeLayer.lineWidth = borderWidth
            strokeLayer.strokeColor = (borderColor ?? .clear).cgColor
        }
    }
    
    func constructPath(with corderRadiii: CardCornerRadii, arrows: CardArrows, in rect:CGRect) -> UIBezierPath {
        
        let minx = rect.minX + arrows.left
        let miny = rect.minY + arrows.top
        let maxx = rect.maxX - arrows.right
        let maxy = rect.maxY - arrows.bottom
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x:minx + corderRadiii.topLeft,y: miny))
        
        // Top Triangle
        path.addLine(to: CGPoint(x: rect.midX - arrows.width/2 ,y: miny))
        path.addLine(to: CGPoint(x: rect.midX ,y: miny - arrows.top))
        path.addLine(to: CGPoint(x: rect.midX + arrows.width/2 ,y: miny))
        
        // TopRight corner
        path.addLine(to: CGPoint(x:maxx - corderRadiii.topRight,y: miny))
        path.addArc(withCenter: CGPoint(x:maxx - corderRadiii.topRight,y: miny + corderRadiii.topRight), radius: corderRadiii.topRight, startAngle:CGFloat(3 * CGFloat.pi/2), endAngle: 0, clockwise: true)
        
        // Right Triangle
        path.addLine(to: CGPoint(x: maxx,y: rect.midY - arrows.width/2))
        path.addLine(to: CGPoint(x: maxx + arrows.right,y: rect.midY))
        path.addLine(to: CGPoint(x: maxx,y: rect.midY + arrows.width/2))
        
        // BottomRight corner
        path.addLine(to: CGPoint(x:maxx,y: maxy - corderRadiii.bottomRight))
        path.addArc(withCenter: CGPoint(x:maxx - corderRadiii.bottomRight,y: maxy - corderRadiii.bottomRight), radius: corderRadiii.bottomRight, startAngle: 0, endAngle: CGFloat(CGFloat.pi/2), clockwise: true)
        
        // Bottom Triangle
        path.addLine(to: CGPoint(x: rect.midX + arrows.width/2 ,y: maxy))
        path.addLine(to: CGPoint(x: rect.midX ,y: maxy + arrows.top))
        path.addLine(to: CGPoint(x: rect.midX - arrows.width/2 ,y: maxy))
        
        // BottomLeft corner
        path.addLine(to: CGPoint(x:minx + corderRadiii.bottomLeft,y: maxy))
        path.addArc(withCenter: CGPoint(x:minx + corderRadiii.bottomLeft,y: maxy - corderRadiii.bottomLeft), radius: corderRadiii.bottomLeft, startAngle: CGFloat(CGFloat.pi/2), endAngle: CGFloat.pi, clockwise: true)
        
        // Left Triangle
        path.addLine(to: CGPoint(x: minx,y: rect.midY + arrows.width/2))
        path.addLine(to: CGPoint(x: minx - arrows.left,y: rect.midY))
        path.addLine(to: CGPoint(x: minx,y: rect.midY - arrows.width/2))
        
        path.addLine(to: CGPoint(x:minx,y: miny + corderRadiii.topLeft))
        path.addArc(withCenter: CGPoint(x:minx + corderRadiii.topLeft,y: miny + corderRadiii.topLeft), radius: corderRadiii.topLeft, startAngle: CGFloat.pi, endAngle: CGFloat(3 * CGFloat.pi/2), clockwise: true)
        path.close()
        return path
    }
    
    // MARK - Button behavior
    
    @objc func animateIn(_ event: UIControl.Event) {
        UIView.animate(withDuration: WobbleButton.inAnimationDuration, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: {[weak self] (_ finished: Bool) -> Void in
            self?.animEnded = true
            if self?.needAnimateOut ?? false {
                self?.animateOut()
            }
        })
    }
    
    @objc func animateOut() {
        
        if !animEnded {
            needAnimateOut = true
            return
        }
        UIView.animate(withDuration: WobbleButton.outAnimationDuration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .allowAnimatedContent, animations: {() -> Void in
            self.transform = CGAffineTransform.identity
        }, completion: {[weak self] (_ finished: Bool) -> Void in
            self?.animEnded = false
            self?.needAnimateOut = false
        })
    }
    
    @objc func animateOutAndComplete() {
        UIView.animate(withDuration: WobbleButton.outAnimationDuration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .allowAnimatedContent, animations: {() -> Void in
            self.transform = CGAffineTransform.identity
        }, completion: { [weak self] (_ finished: Bool) -> Void in
            self?.animEnded = false
            self?.needAnimateOut = false
            self?.onClick?()
        })
    }
}
