//
//  templateIcon
//  template
//
//  Created by Alexis Creuzot on 04/07/2019.
//  Copyright © 2019 alexiscreuzot. All rights reserved.
//

import Foundation
import UIKit

let IconFont = UIFont.systemFont(ofSize: 20) //UIFont(name: "icons", size: 20)!

enum CustomIcon : String {
    
    case empty = ""
    case checkmark = "✓"

    func attributesFor(size: CGFloat, color: UIColor) -> [NSAttributedString.Key : Any] {
        return [.foregroundColor: color,
                .backgroundColor: UIColor.clear,
                .font: IconFont.withSize(size)]
    }
    
    func imageFor(size: CGFloat, color: UIColor) -> UIImage? {
        
        let imageSize = CGSize.init(width: size, height: size)
        let attributes = self.attributesFor(size: size, color: color)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let rect = CGRect(origin: .zero, size: imageSize)
        self.rawValue.draw(in: rect, withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
