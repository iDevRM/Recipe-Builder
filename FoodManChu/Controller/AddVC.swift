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
    @IBOutlet weak var categoryTextField        : UITextField!
    @IBOutlet weak var addIngredientButton      : UIButton!
    @IBOutlet weak var listOfIngredientsLabel   : UILabel!
    
    var imagePicker: UIImagePickerController!
    let ingredientPicker = UIPickerView()
    let categoryPicker = UIPickerView()
    var newRecipe = [Recipe]()
    var listOfIngredients = ""
    
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
        
        imagePicker = UIImagePickerController()
        setAllDelegates()
        addNewRecipeButton.layer.cornerRadius     = 8
        listOfIngredientsLabel.layer.cornerRadius = 8
        addIngredientButton.layer.cornerRadius    = 4
        
        setPickerAndToolBar()
        
        
    }
    @objc func closePicker() {
        ingredientNameTextField.resignFirstResponder()
        categoryTextField.resignFirstResponder()
    }
    
    @IBAction func imageButtonTapped(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setPickerAndToolBar() {
        ingredientNameTextField.inputView = ingredientPicker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closePicker))
        toolBar.setItems([doneButton], animated: false)
        ingredientNameTextField.inputAccessoryView = toolBar
        
        categoryTextField.inputView = categoryPicker
        let toolBar2 = UIToolbar()
        toolBar2.barStyle = UIBarStyle.default
        toolBar2.isTranslucent = true
        toolBar2.sizeToFit()
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closePicker))
        toolBar2.setItems([doneButton2], animated: false)
        categoryTextField.inputAccessoryView = toolBar2
    }
    
    @IBAction func addNewRecipeTapped(_ sender: UIButton) {
        if allFieldsHaveInputs {
            createRecipe()
            saveRecipe()
            clearAllTextFields()
        }
    }
    @IBAction func addIngredientTapped(_ sender: UIButton) {
        if ingredientAmountTextField.hasText && ingredientNameTextField.hasText {
            listOfIngredients += "\(ingredientAmountTextField.text!) \(ingredientNameTextField.text!),"
            
            listOfIngredientsLabel.text = listOfIngredients
            ingredientNameTextField.text = ""
            ingredientAmountTextField.text = ""
            
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
//        newIngredients.name    = ingredientNameTextField.text
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
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

//MARK: - Image Picker Delegate and DataSource
extension AddVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case ingredientPicker:
            return Constants.ingredients.count
        case categoryPicker:
            return Constants.categories.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case ingredientPicker:
            return Constants.ingredients[row]
        case categoryPicker:
            return Constants.categories[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case ingredientPicker:
            ingredientNameTextField.text = Constants.ingredients[row]
        case categoryPicker:
            categoryTextField.text = Constants.ingredients[row]
        default:
            break
        }
        
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

extension AddVC {
    func setAllDelegates() {
        nameTextField.delegate             = self
        imagePicker.delegate               = self
        timeTextField.delegate             = self
        descriptionTextField.delegate      = self
        ingredientAmountTextField.delegate = self
        instructionsTextField.delegate     = self
        categoryPicker.delegate            = self
        categoryPicker.dataSource          = self
        ingredientNameTextField.delegate   = self
        ingredientPicker.delegate                    = self
        ingredientPicker.dataSource                  = self
        navigationController?.delegate     = self
    }
}

