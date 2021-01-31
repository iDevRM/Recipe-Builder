//
//  SearchTableViewCell.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/8/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail:   UIImageView!
    @IBOutlet weak var topLabel:    UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var view:        UIView!

    func configureCell(_ recipe: Recipe ) {
        thumbnail.image              = recipe.image as? UIImage ?? UIImage(named: "Instant-Pot-Spaghetti-Recipe-11-of-4-1024x681")
        thumbnail.layer.cornerRadius = 5
        view.layer.cornerRadius      = 10
        view.layer.shadowOpacity     = 0.8
        view.layer.shadowRadius      = 3.0
        view.layer.shadowOffset      = CGSize(width: 0.0, height: 2.0)
        view.layer.shadowColor       = #colorLiteral(red: 0.6156238914, green: 0.6157299876, blue: 0.6156099439, alpha: 1)
        topLabel.text                = recipe.name
        middleLabel.text             = "\(String(format: "%0.f", recipe.prepTime)) min"
        bottomLabel.text             = recipe.descript
    }
 
}
