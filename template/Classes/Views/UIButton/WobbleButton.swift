//
//  WobbleButton.swift
//  pilotv2
//
//  Created by Alexis Creuzot on 22/08/2017.
//  Copyright © 2017 waverlylabs. All rights reserved.
//

import UIKit

class WobbleButton: UIButton {
    
    private var needAnimateOut: Bool = false
    private var animEnded: Bool = false
    static let outAnimationDuration = 0.3
    static let inAnimationDuration = 0.16

    override var isEnabled : Bool {
        didSet {
            self.alpha = isEnabled ? 1.0 : 0.3
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
        
        addTarget(self, action: #selector(self.animateIn), for: .touchDown)
        addTarget(self, action: #selector(self.animateIn), for: .touchDragEnter)
        addTarget(self, action: #selector(self.animateOut), for: .touchDragExit)
        addTarget(self, action: #selector(self.animateOut), for: .touchCancel)
        addTarget(self, action: #selector(self.animateOut), for: .touchUpInside)
    }
    
    @objc func animateIn() {
        UIView.animate(withDuration: WobbleButton.inAnimationDuration, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: {(_ finished: Bool) -> Void in
            self.animEnded = true
            if self.needAnimateOut {
                self.animateOut()
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
        }, completion: {(_ finished: Bool) -> Void in
            self.animEnded = false
            self.needAnimateOut = false
        })
    }
}
