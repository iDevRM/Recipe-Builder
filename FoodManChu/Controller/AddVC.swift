//
//  AddVC.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/20/21.
//

import UIKit

class AddVC: UIViewController {
    @IBOutlet weak var nameTextField            : UITextField!
    @IBOutlet weak var timeTextField            : UITextField!
    @IBOutlet weak var descriptionTextField     : UITextField!
    @IBOutlet weak var ingredientAmountTextField: UITextField!
    @IBOutlet weak var imageButton              : UIButton!
    @IBOutlet weak var ingredientNameTextField           : UITextField!
    @IBOutlet weak var instructionsTextField    : UITextField!
    @IBOutlet weak var imageView                : UIImageView!
    @IBOutlet weak var addNewRecipeButton       : UIButton!
    @IBOutlet weak var categoryPicker           : UIPickerView!
    
    var imagePicker: UIImagePickerController!
    var newRecipe = [Recipe]()
    
    var allFieldsHaveInputs: Bool {
        if nameTextField.hasText,
           timeTextField.hasText,
           descriptionTextField.hasText,
           ingredientAmountTextField.hasText,
           ingredientNameTextField.hasText,
           instructionsTextField.hasText,
           imageView.image != UIImage(systemName: "camera.viewfinder") {
            return true
        } else {
            return false
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let destVC = viewController as? SearchVC {
            destVC.loadRecipes()
            destVC.tableView.reloadData()
        }
    }
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate             = self
        timeTextField.delegate             = self
        descriptionTextField.delegate      = self
        ingredientAmountTextField.delegate = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate               = self
        addNewRecipeButton.layer.cornerRadius = 8
        categoryPicker.delegate            = self
        categoryPicker.dataSource          = self
        ingredientNameTextField.delegate   = self
        navigationController?.delegate     = self
    }
    
    @IBAction func imageButtonTapped(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addNewRecipeTapped(_ sender: UIButton) {
        if allFieldsHaveInputs {
            createRecipe()
            saveRecipe()
            clearAllTextFields()
        }
    }
    
    func clearAllTextFields() {
        nameTextField.text = ""
        timeTextField.text = ""
        descriptionTextField.text = ""
        instructionsTextField.text = ""
        ingredientAmountTextField.text = ""
        ingredientNameTextField.text = ""
        imageView.image = UIImage(systemName: "camera.viewfinder")
    }
    
    func createRecipe() {
        let newRecipe          = Recipe(context: Constants.context)
        newRecipe.name         = nameTextField.text
        newRecipe.descript     = descriptionTextField.text
        newRecipe.instructions = instructionsTextField.text
        newRecipe.prepTime     = Double(timeTextField.text!)!
        newRecipe.image        = imageView.image
        let newIngredients     = Ingredients(context: Constants.context)
        newIngredients.name    = ingredientNameTextField.text
        newIngredients.amount  = ingredientAmountTextField.text
        newRecipe.ingredients  = [newIngredients]
        let category           = Categories(context: Constants.context)
        category.name          = Constants.categories[categoryPicker.selectedRow(inComponent: 0)]
        newRecipe.category     = [category]
    }
    
    func saveRecipe() {
        do {
            try Constants.context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

//MARK: - TextField delegate methods
extension AddVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.hasText {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.systemRed.cgColor
            textField.placeholder = "Please enter text"
            return false
        } else {
            textField.layer.borderWidth = 0
            textField.resignFirstResponder()
            return true
        }
    }
}

//MARK: - Image Picker Delegate and DataSource
extension AddVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Constants.categories[row]
    }
    
}


extension AddVC:  UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
}



