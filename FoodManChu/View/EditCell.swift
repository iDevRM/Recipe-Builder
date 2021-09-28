//
//  EditCell.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 2/1/21.
//

import UIKit

class EditCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    func configCell(_ ingredient: Ingredients,_ indexPath: IndexPath) {
        guard let name = ingredient.name,
              let amount = ingredient.amount else { return }
        
        nameLabel.text = name
        amountTextField.text = amount
        amountTextField.placeholder = String(indexPath.row)
    }
}
