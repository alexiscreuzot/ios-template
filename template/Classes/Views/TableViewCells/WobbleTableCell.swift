//
//  WobbleTableCell.swift
//  template
//
//  Created by Alexis Creuzot on 05/08/2019.
//  Copyright © 2019 waverlylabs. All rights reserved.
//

import UIKit

class WobbleTableCell: UITableViewCell {
    public var isWobbly = true
    private var touchdown: Bool = false
    private var animEnded: Bool = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard isWobbly else { return }
        touchdown = true
        animateIn()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // Triggered when touch is released
        if touchdown {
            animateOut()
            touchdown = false
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        // Triggered if touch leaves view
        if touchdown {
            animateOut()
            touchdown = false
        }
    }
    
    func animateIn() {
        UIView.animate(withDuration: 0.16, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: {(_ finished: Bool) -> Void in
            self.animEnded = true
            if !self.touchdown {
                self.animateOut()
            }
        })
    }
    
    func animateOut() {
        if !animEnded {
            return
        }
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .allowAnimatedContent, animations: {() -> Void in
            self.transform = CGAffineTransform.identity
        }, completion: {(_ finished: Bool) -> Void in
            self.animEnded = false
        })
    }
}
