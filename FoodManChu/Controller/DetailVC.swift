//
//  DetailVC.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/20/21.
//

import UIKit

class DetailVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var image             : UIImageView!
    @IBOutlet weak var nameLabel         : UILabel!
    @IBOutlet weak var prepTimeLabel     : UILabel!
    @IBOutlet weak var descriptionLabel  : UILabel!
    @IBOutlet weak var ingredientsLabel  : UILabel!
    @IBOutlet weak var backgroundImage   : UIImageView!
    @IBOutlet weak var instructionslLabel: UILabel!
    @IBOutlet weak var categoryLabel     : UILabel!
    
    var selectedRecipe: Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.layer.cornerRadius = 10
        if selectedRecipe != nil {
            setTextForAllLabels(with: selectedRecipe)
        }
    }
    
    func setTextForAllLabels(with recipe: Recipe?) {
        var items = ""
        image.image = recipe!.image as? UIImage ?? UIImage(named: "Instant-Pot-Spaghetti-Recipe-11-of-4-1024x681")
        nameLabel.text = recipe!.name
        prepTimeLabel.text = "\(recipe!.prepTime!) min"
        descriptionLabel.text = recipe!.descript
        instructionslLabel.text = recipe!.instructions!
        let ingredients = recipe!.ingredients as! Set<Ingredients>
        for ingredient in ingredients {
            if ingredient.name != nil {
                items += "\(ingredient.amount!) \(ingredient.name!),"
            }
        }
        ingredientsLabel.text = items
        if let category = recipe?.category?.name {
            categoryLabel.text = "Category : \(category)"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? EditVC {
            destVC.selectedRecipe = selectedRecipe
        }
    }
//MARK: - IBActions
    @IBAction func duplicateTapped(_ sender: Any) {
        if selectedRecipe != nil {
            let duplicate = Recipe(context: Constants.context)
            duplicate.name = selectedRecipe!.name!
            duplicate.prepTime = selectedRecipe!.prepTime
            duplicate.descript = selectedRecipe!.descript!
            duplicate.instructions = selectedRecipe!.instructions!
            duplicate.image = selectedRecipe!.image!
            duplicate.category?.name = selectedRecipe!.category!.name!
            duplicate.ingredients = selectedRecipe!.ingredients
            
            do {
                try Constants.context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            navigationController?.popToRootViewController(animated: true)
        }
    }
}



