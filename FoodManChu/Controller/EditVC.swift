//
//  EditVC.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 2/1/21.
//

import UIKit

class EditVC: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var instructionsTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var doneEditingButton: UIButton!
    
    var selectedRecipe: Recipe!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneEditingButton.layer.cornerRadius = 5
        nameTextField.text = selectedRecipe.name
        timeTextField.text = "\(String(format: "%0.f", selectedRecipe.prepTime)) min"
        descriptionTextField.text = selectedRecipe.descript
        instructionsTextField.text = selectedRecipe.instructions
        categoryTextField.text = selectedRecipe.category?.name
        
    }
    

   

}

extension EditVC: UITextFieldDelegate {
    
}

extension EditVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (selectedRecipe.ingredients?.allObjects.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? IngredientListCell {
            var array = [Ingredients]()
            if let set = selectedRecipe.ingredients as? Set<Ingredients> {
                for i in set {
                    array.append(i)
                }
                
                cell.configCell(array[indexPath.row
                ].name!, array[indexPath.row].amount!)
            }
            
        }
        return UITableViewCell()
    }
    
    
}
