//
//  TitleSeparatorCell.swift
//
//  Created by Alexis Creuzot on 14/06/2017.
//  Copyright © 2017 waverlylabs. All rights reserved.
//

import Foundation
import UIKit

class TableSeparatorCellVM: GenericTableCellVM {
    
    var title: String = ""
    var attributedTitle: NSAttributedString?
    var alignment: NSTextAlignment
    var color: UIColor?
    var font: UIFont?
    
    init(title : String = "", alignment:NSTextAlignment = .left, color: UIColor? = nil, backgroundColor: UIColor? = nil ) {
        self.title = title
        self.alignment = alignment
        self.color = color
        
        super.init(TableSeparatorCell.self)
        self.backgroundColor = backgroundColor
        height = 48
    }
}

class TableSeparatorCell: GenericTableCell {
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setViewModel(_ viewModel: GenericTableCellVM) {
        super.setViewModel(viewModel)
        if let viewModel = viewModel as? TableSeparatorCellVM {
            self.backgroundColor = viewModel.backgroundColor
            
            titleLabel?.text = viewModel.title
            titleLabel?.textAlignment = viewModel.alignment
            if let color = viewModel.color {
                titleLabel?.textColor = color
            }
            self.titleLabel.font = viewModel.font ?? CustomFont.heading.font
  
            if let attributedTitle = viewModel.attributedTitle {
                titleLabel?.attributedText = attributedTitle
            }
        }
    }
}
