//
//  GenericTableCell.swift
//

import UIKit

typealias GenericTableCellIdentifier = Int

protocol GenericTableCellProtocol {
    func setViewModel(_ viewModel: GenericTableCellVM)
}

class GenericTableCellVM: NSObject {
    
    var viewType: AnyClass
    var identifier: GenericTableCellIdentifier?
    var payload: Any?
    var height: CGFloat = 50
    var estimatedHeight: CGFloat = 50
    var backgroundColor: UIColor?

    var reuseIdentifier : String {
        get {
            return String(describing: viewType)
        }
    }

    init(_ type: AnyClass) {
        self.viewType = type
    }
}

class GenericTableCell : WobbleTableCell, GenericTableCellProtocol {
    
    var viewModel = GenericTableCellVM(UITableViewCell.self)

    func setViewModel(_ viewModel: GenericTableCellVM) {
        self.viewModel = viewModel
        if let backgroundColor = self.viewModel.backgroundColor {
            self.backgroundColor = backgroundColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.isWobbly = false
        
        let selView = UIView()
        selView.backgroundColor = UIColor.quaternaryLabel
        self.selectedBackgroundView = selView
    }
}
