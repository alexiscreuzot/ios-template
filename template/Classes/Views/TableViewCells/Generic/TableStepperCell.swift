//
//  TableStepperCell.swift
//  rotoscopy
//
//  Created by Alexis Creuzot on 03/03/2020.
//  Copyright © 2020 monoqle. All rights reserved.
//

import Foundation
import UIKit

class TableStepperCellVM: GenericTableCellVM {
    
    public typealias StepBlock = ((Int, TableStepperCellVM) -> ())
    
    var title:String?
    var value:Int
    var range: ClosedRange<Int>
    var stepAction: StepBlock?
    
    required init(title:String? = nil,
                    value : Int? = nil,
                  range: ClosedRange<Int>? = nil,
                  stepAction : StepBlock? = nil) {
        self.title = title ?? nil
        self.value = value ?? 0
        self.range = range ?? 0...100
        self.stepAction = stepAction
        super.init(TableStepperCell.self)
        self.height = UITableView.automaticDimension
    }
}

class TableStepperCell: GenericTableCell {
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var stepper : UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.addTarget(self, action: #selector(stepperValueDidChange(sender:)), for: .valueChanged)
    }
    
    override func setViewModel(_ viewModel: GenericTableCellVM) {
        super.setViewModel(viewModel)
        if let viewModel = viewModel as? TableStepperCellVM {
            if let title = viewModel.title {
                self.titleLabel.text = title + " : " + String(viewModel.value)
            } else {
                self.titleLabel.text = String(viewModel.value)
            }
            self.stepper.minimumValue = Double(viewModel.range.lowerBound)
            self.stepper.maximumValue = Double(viewModel.range.upperBound)
            self.stepper.value = Double(viewModel.value)
        }
    }
    
    @objc func stepperValueDidChange(sender: UIStepper!) {
        if let viewModel = self.viewModel as? TableStepperCellVM {
            viewModel.value = Int(sender.value)
            viewModel.stepAction?(viewModel.value, viewModel)
            self.setViewModel(viewModel)
        }
    }
}
