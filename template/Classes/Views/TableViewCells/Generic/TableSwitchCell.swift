//
//  SwitchTableCell.swift
//
//  Created by Alexis Creuzot on 04/07/2017.
//  Copyright © 2017 waverlylabs. All rights reserved.
//

import UIKit

class TableSwitchCellVM: GenericTableCellVM {
    
    public typealias SwitchBlock = ((Bool, TableSwitchCellVM) -> ())
    
    var title = ""
    var isOn = false
    var switchAction : SwitchBlock?
    
    convenience init(title: String, isOn : Bool, switchAction : SwitchBlock?) {
        self.init(TableSwitchCell.self)
        self.title = title
        self.isOn = isOn
        self.switchAction = switchAction
        self.height = UITableView.automaticDimension
    }
}

class TableSwitchCell: GenericTableCell {
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var swithView : UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        swithView.addTarget(self, action: #selector(switchValueDidChange(sender:)), for: .valueChanged)
    }
    
    override func setViewModel(_ viewModel: GenericTableCellVM) {
        super.setViewModel(viewModel)
        if let viewModel = viewModel as? TableSwitchCellVM {
            self.titleLabel?.text = viewModel.title
            self.swithView.setOn(viewModel.isOn, animated: false)
        }
    }
    
    @objc func switchValueDidChange(sender: UISwitch!) {
        if let viewModel = self.viewModel as? TableSwitchCellVM {
            viewModel.isOn = sender.isOn
            viewModel.switchAction?(sender.isOn, viewModel)
        }
    }
    
}
