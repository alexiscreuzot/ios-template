//
//  ActionCell.swift
//
//  Created by Alexis Creuzot on 13/06/2017.
//  Copyright © 2017 waverlylabs. All rights reserved.
//

import UIKit

typealias TableActionEnableBlock = (() -> (Bool))

class TableActionCellVM: GenericTableCellVM {
    
    var title = ""
    var titleColor : UIColor?
    var iconImage : UIImage?
    var isEnabledBlock : TableActionEnableBlock = {return true}
    
    init(title: String,
         identifier : GenericTableCellIdentifier,
         titleColor: UIColor? = nil,
         iconImage: UIImage? = nil,
         isEnabledBlock : @escaping TableActionEnableBlock = {return true}) {
        super.init(TableActionCell.self)
        self.titleColor = titleColor
        self.title = title
        self.iconImage = iconImage
        self.identifier = identifier
        self.isEnabledBlock = isEnabledBlock
        self.height = UITableView.automaticDimension
    }
}

class TableActionCell: GenericTableCell {
    
    @IBOutlet var iconImageView : UIImageView?
    @IBOutlet var titleLabel : UILabel!
    
    var isEnabled: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .default
    }
    
    override func setViewModel(_ viewModel: GenericTableCellVM) {
        super.setViewModel(viewModel)
        if let viewModel = viewModel as? TableActionCellVM {
            
            if let color = viewModel.titleColor {
                self.titleLabel.textColor = color
                self.iconImageView?.tintColor = color
            }
            
            self.isEnabled = viewModel.isEnabledBlock()
            self.titleLabel.text = viewModel.title
            self.titleLabel.alpha = self.isEnabled ? 1.0 : 0.5
            self.iconImageView?.image = viewModel.iconImage
           
            self.selectedBackgroundView?.backgroundColor = self.titleLabel.textColor.withAlphaComponent(0.2)
        }
    }
    
}
