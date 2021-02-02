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
    var editedIngredient: Ingredients?
    var set = Set<Ingredients>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneEditingButton.layer.cornerRadius = 5
        nameTextField.text = selectedRecipe.name
        timeTextField.text = selectedRecipe.prepTime
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
        navigationController?.delegate = self
        
        if let set = selectedRecipe.ingredients as? Set<Ingredients> {
            for i in set {
                ingredientList.append(i)
            }
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        selectedRecipe.name = nameTextField.text!
        selectedRecipe.prepTime = timeTextField.text!
        selectedRecipe.descript = descriptionTextField.text!
        selectedRecipe.instructions = instructionsTextField.text!
        selectedRecipe.category?.name = categoryTextField.text!
        for i in ingredientList {
            set.insert(i)
        }
        selectedRecipe.ingredients = set as NSSet
        save()
    }
    
    func save() {
        do {
            try Constants.context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

}

extension EditVC: UITextFieldDelegate {
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
     
        if let ingredient = ingredientList.first(where: { $0.amount == textField.text! }) {
            editedIngredient = ingredient
                 }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        editedIngredient?.amount = textField.text!
        
        save()
        
        tableView.reloadData()
    }
}

extension EditVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? EditCell {
            cell.configCell(ingredientList[indexPath.row])
            cell.amountTextField.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
   

    
}

extension EditVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let destVC = viewController as? DetailVC {
            destVC.selectedRecipe = selectedRecipe
            destVC.setTextForAllLabels(with: destVC.selectedRecipe)
        }
    }
}
