//
//  RotoscopyFont.swift
//  looq
//
//  Created by Alexis Creuzot on 14/11/2019.
//  Copyright © 2019 alexiscreuzot. All rights reserved.
//

import UIKit

enum CustomFont {
        
    private var multiplier : CGFloat {
        switch UIScreen.main.bounds.height {
        case 0..<667:
            return 0.9
        default:
            return 1.0
        }
    }
    
    case heading
    case title
    case callout
    case subtitle
    case body
    case footnote
    
    var font : UIFont {
        switch self {
        case .heading:
            return UIFont.boldSystemFont(ofSize: 20 * multiplier)
        case .title:
            return UIFont.systemFont(ofSize: 20 * multiplier)
        case .callout:
            return UIFont.boldSystemFont(ofSize: 14 * multiplier)
        case .subtitle:
            return UIFont.systemFont(ofSize: 16 * multiplier)
        case .body:
           return UIFont.systemFont(ofSize: 15 * multiplier)
        case .footnote:
            return UIFont.systemFont(ofSize: 11 * multiplier)
        }
    }
    
    func attributes(color: UIColor? = nil) -> [NSAttributedString.Key : Any] {
        let color = color ?? .black
        return [.foregroundColor: color,
        .backgroundColor: UIColor.clear,
        .font: self.font]
    }
    
    func attributedStringFor(_ string: String, color: UIColor? = nil) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: string,
                                         attributes: self.attributes(color: color))
    }
}
