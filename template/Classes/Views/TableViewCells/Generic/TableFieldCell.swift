//
//  TableFieldCell.swift
//  template
//
//  Created by Alexis Creuzot on 12/09/2019.
//  Copyright © 2019 waverlylabs. All rights reserved.
//

import Foundation
import UIKit

class TableFieldCellVM: GenericTableCellVM {
    
    typealias FieldChangeBlock = ((UITextField) -> Void)
    typealias FieldCompletionBlock = ((UITextField) -> Void)
    
    var text: String?
    var placeholder: String?
    var onChangeBlock: FieldChangeBlock?
    var completionBlock: FieldCompletionBlock?
    
    init(text : String? = nil,
         placeholder : String? = nil,
         onChangeBlock : FieldChangeBlock? = nil,
         completionBlock : FieldCompletionBlock? = nil) {
        self.text = text
        self.placeholder = placeholder
        self.onChangeBlock = onChangeBlock
        self.completionBlock = completionBlock
        super.init(TableFieldCell.self)
        self.height = 54
    }
}

class TableFieldCell: GenericTableCell {
    
    @IBOutlet var textField: CustomTextField!
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.updateUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clear
        self.textField.delegate = self
        self.textField.backgroundColor = .clear
        self.textField.borderStyle = .none
        
        self.textField.layer.borderWidth = 1
        self.textField.layer.cornerRadius = 10
        
        self.updateUI()
    }
    
    override func setViewModel(_ viewModel: GenericTableCellVM) {
        super.setViewModel(viewModel)
        if let viewModel = viewModel as? TableFieldCellVM {
            self.textField.text = viewModel.text
            let placeholder = viewModel.placeholder ?? ""
            self.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.tertiaryLabel])
        }
    }
    
    func updateUI() {
        self.textField.textColor = UIColor.label
        self.textField.layer.borderColor = self.textField.isEditing
            ? UIColor.systemBlue.cgColor
        : UIColor.tertiaryLabel.cgColor
    }
    
    @IBAction func textFieldEditingDidChange(_ sender: UITextField) {
        (viewModel as? TableFieldCellVM)?.onChangeBlock?(sender)
    }
}

extension TableFieldCell : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textField.animateBorderColor(toColor: UIColor.systemBlue, duration: 0.3)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (viewModel as? TableFieldCellVM)?.completionBlock?(textField)
        self.textField.animateBorderColor(toColor: UIColor.tertiaryLabel, duration: 0.3)
    }
}

extension UIView {
  func animateBorderColor(toColor: UIColor, duration: Double) {
    let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
    animation.fromValue = layer.borderColor
    animation.toValue = toColor.cgColor
    animation.duration = duration
    layer.add(animation, forKey: "borderColor")
    layer.borderColor = toColor.cgColor
  }
}
