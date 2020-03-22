//
//  templateViewController.swift
//  template
//
//  Created by Alexis Creuzot on 22/07/2019.
//  Copyright © 2019 waverlylabs. All rights reserved.
//

import UIKit

enum NavigationBarType {
    case clear
    case solid(UIColor)
}

class CoreVC : UIViewController {
    
    private let scrollGradientMaskLayer = CAGradientLayer()
    
    public enum ExitButtonSide {
        case left
        case right
    }
    
    public var isDismissable = true {
        didSet {
            if self.isViewLoaded {
                self._refreshUI()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self._refreshUI()
    }
    
    func setNavigationBar(type: NavigationBarType) {
        switch type {
        case .clear:
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        case .solid(let color):
            self.navigationController?.navigationBar.setBackgroundImage(color.image(), for: .default)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent repeats
        if let _ = self.parent as? CoreVC {
            return
        }
        
        var trail = "";
        if let nav = self.navigationController {
            for (index, vc) in nav.viewControllers.enumerated() {
                if index > 0 {
                    trail += "> "
                }
                trail += "\(logController(vc)) "
            }
        } else {
            trail += logController(self)
        }
        
        log.debug("\(trail)")
    }
    
    // MARK: - Public
    
    func logController(_ controller : UIViewController) -> String {
        let string = "[\(String(describing:type(of:controller)))]"
        return string
    }
    
    private func _refreshUI() {
        
        let hasPreviousControllers = self.navigationController?.viewControllers.count ?? 0 > 1
        let isPresented = isBeingPresented || (self.navigationController?.isBeingPresented ?? false)
        
        if isDismissable && isPresented && !hasPreviousControllers {
            self.addExitButton(side: .left)
        } else {
            if #available(iOS 13.0, *) {
                self.isModalInPresentation = true
            }
        }
    }
    
    func addExitButton(side: ExitButtonSide) {
                
        let exitButton = UIBarButtonItem.init(barButtonSystemItem: .stop,
                                              target: self,
                                              action: #selector(dismissController))
        switch side {
        case .left:
            self.navigationItem.setLeftBarButton(exitButton, animated: false)
            break
        case .right:
            self.navigationItem.setRightBarButton(exitButton, animated: false)
            break
        }
    }
    
    @IBAction func dismissController() {
        if let _ = self.presentingViewController {
            self.presentingViewController?.viewWillAppear(true)
            self.dismiss(animated: true)
        } else {
            self.navigationController?.viewControllers.first?.viewWillAppear(true)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}
