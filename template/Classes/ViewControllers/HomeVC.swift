//
//  ViewController.swift
//  template
//
//  Created by Alexis Creuzot on 19/03/2020.
//  Copyright © 2020 alexiscreuzot. All rights reserved.
//

import UIKit

class HomeVC: GenericTableVC {
    
    enum HomeCellIdentifier : GenericTableCellIdentifier {
        case simpleCell
        case actionRedCell
        case actionCell
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Template"
        
        self.reloadData()
    }
    
    // MARK: - Logic

    func reloadData() {
        self.datasource = []
        
        let titleVM = TableSeparatorCellVM.init(title: "Lorem ipsum dolor")
        self.datasource.append(titleVM)
        
        let stepperVM = TableStepperCellVM.init(title: "Sollicitudin ac orci", value: 15, range: 10...20) { (value, _) in
            log.debug("Step to \(value)")
        }
        self.datasource.append(stepperVM)
        
        let title2VM = TableSeparatorCellVM.init(title: "Aliquam faucibus")
        self.datasource.append(title2VM)
        
        let switchVM = TableSwitchCellVM.init(title: "Egestas erat imperdiet sed euismod nisi. Pulvinar etiam non quam lacus suspendisse", isOn: true) { (value, _) in
            log.debug("Switch is \(value)")
        }
        self.datasource.append(switchVM)
        
        let longTextTitleVM = TableSeparatorCellVM.init(title: "Voluptate velit")
        self.datasource.append(longTextTitleVM)
        
        let longTextVM = TableSimpleCellVM.init(title: "Ac ut consequat semper viverra nam libero justo laoreet quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\nExcepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", accessoryType: .none)
        self.datasource.append(longTextVM)
        
        let actionRedVM = TableActionCellVM.init(title: "Cupidatat non", identifier: HomeCellIdentifier.actionRedCell.rawValue)
        actionRedVM.titleColor = UIColor.systemRed
        self.datasource.append(actionRedVM)
        
        let title3VM = TableSeparatorCellVM.init(title: "Sed euismod")
        self.datasource.append(title3VM)
        
        let fieldVM = TableFieldCellVM.init(text: "", placeholder: "Lectus quam id leo in vitae", onChangeBlock: { (textfield) in
            log.debug(textfield.text ?? "")
        }) { textfield in
            log.debug("Finished editing")
        }
        self.datasource.append(fieldVM)
        
        let title4VM = TableSeparatorCellVM.init(title: "Sed euismod")
        self.datasource.append(title4VM)
        
        let simpleVM = TableSimpleCellVM.init(title: "Ac ut consequat semper viverra nam libero justo laoreet", value: "Tortor id aliquet", accessoryType: .disclosureIndicator, identifier: HomeCellIdentifier.simpleCell.rawValue)
        self.datasource.append(simpleVM)        
        
        let actionVM = TableActionCellVM.init(title: "Nascetur ridiculus", identifier: HomeCellIdentifier.actionCell.rawValue)
        self.datasource.append(actionVM)
        
        let title5VM = TableSeparatorCellVM.init(title: "\n")
        self.datasource.append(title5VM)
        
        self.tableView.reloadData()
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = self.datasource[indexPath.row]
        
        guard   let rawIdentifier = content.identifier,
            let identifier = HomeCellIdentifier(rawValue: rawIdentifier) else {
                return
        }
        switch identifier {
            
        case .simpleCell:
            log.debug("simpleCell")
            break
           
        case .actionRedCell:
            log.debug("actionRedCell")
        break
            
        case .actionCell:
            log.debug("actionCell")
            break
        }

        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

