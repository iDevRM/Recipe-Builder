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
    @IBOutlet weak var image: UIImageView!
    
    var selectedRecipe: Recipe!
    var ingredientList = [Ingredients]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneEditingButton.layer.cornerRadius = 5
        nameTextField.text = selectedRecipe.name
        timeTextField.text = "\(String(format: "%0.f", selectedRecipe.prepTime)) min"
        descriptionTextField.text = selectedRecipe.descript
        instructionsTextField.text = selectedRecipe.instructions
        categoryTextField.text = selectedRecipe.category?.name
        image.image = (selectedRecipe.image as! UIImage)
        image.layer.cornerRadius = 10
        tableView.delegate = self
        tableView.dataSource = self
        nameTextField.delegate = self
        timeTextField.delegate = self
        descriptionTextField.delegate = self
        instructionsTextField.delegate = self
        categoryTextField.delegate = self
        
        
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        selectedRecipe.name = nameTextField.text
        selectedRecipe.prepTime = timeTextField.text
    }
   

}

extension EditVC: UITextFieldDelegate {
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (selectedRecipe.ingredients?.allObjects.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? EditCell {
           
            if let set = selectedRecipe.ingredients as? Set<Ingredients> {
                for i in set {
                    ingredientList.append(i)
                }
                cell.configCell(ingredientList[indexPath.row])
            }
            return cell
        }
        return UITableViewCell()
    }
    
    
}
