//
//  EditCell.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 2/1/21.
//

import UIKit

class EditCell: UITableViewCell {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    
    func configCell(_ ingredient: Ingredients) {
        if ingredient.name != nil && ingredient.amount != nil {
            nameTextField.text = ingredient.name!
            amountTextField.text = ingredient.amount!
        }
    }
    

}
