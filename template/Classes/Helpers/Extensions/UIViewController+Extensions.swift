//
//  UIKit+Extensions.swift
//  coreml-FNS
//
//  Created by Alexis Creuzot on 28/03/2018.
//  Copyright © 2018 alexiscreuzot. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func add(_ child: UIViewController, to view: UIView) {
        addChild(child)
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(child.view)
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        child.didMove(toParent: self)
    }

    func remove() {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}


