//
//  SimpleTableCell.swift
//  template
//
//  Created by Alexis Creuzot on 18/07/2017.
//  Copyright © 2017 waverlylabs. All rights reserved.
//

import UIKit


class TableSimpleCellVM: GenericTableCellVM {
    
    var title : String!
    var attributedTitle : NSAttributedString?
    var value : String?
    var accessoryType: UITableViewCell.AccessoryType
    
    init(title: String, value : String? = nil, accessoryType : UITableViewCell.AccessoryType = .disclosureIndicator, identifier : GenericTableCellIdentifier? = nil) {
        self.title = title
        self.value = value
        self.accessoryType = accessoryType
        super.init(TableSimpleCell.self)
        self.identifier = identifier
        self.height = UITableView.automaticDimension
    }
}

class TableSimpleCell: GenericTableCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setViewModel(_ viewModel: GenericTableCellVM) {
        super.setViewModel(viewModel)
        if let viewModel = viewModel as? TableSimpleCellVM {
            
            if let attributedTitle = viewModel.attributedTitle {
                self.titleLabel.attributedText = attributedTitle
            } else {
                self.titleLabel.text = viewModel.title
            }
            
            self.valueLabel.text = viewModel.value
            
            self.accessoryType = viewModel.accessoryType
            switch self.accessoryType {
            case .detailDisclosureButton,
                 .checkmark,
                 .disclosureIndicator :
                self.selectionStyle = .default
                break
            default:
                self.selectionStyle = .none
            }
            
        }
    }
}
