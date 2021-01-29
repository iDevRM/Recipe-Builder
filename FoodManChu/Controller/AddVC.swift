//
//  AddVC.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/20/21.
//

import UIKit
import CoreData

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
    @IBOutlet weak var tableView: UITableView!
    
    
    var imagePicker: UIImagePickerController!
    let ingredientPicker = UIPickerView()
    let categoryPicker = UIPickerView()
    var newRecipe = [Recipe]()
    var arrayIngredients: [String] = []
    var arrayOfAmounts: [String] = []
    let ingredientList = Ingredients(context: Constants.context)
  
    
    var allFieldsHaveInputs: Bool {
        if nameTextField.hasText,
           timeTextField.hasText,
           descriptionTextField.hasText,
           instructionsTextField.hasText,
           categoryTextField.hasText,
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
        setPickerAndToolBar()
        addNewRecipeButton.layer.cornerRadius     = 8
        addIngredientButton.layer.cornerRadius    = 4
        ingredientList.name = Constants.ingredients
        saveItems()
    }
    
    @objc func closePicker() {
        ingredientNameTextField.resignFirstResponder()
        categoryTextField.resignFirstResponder()
    }
    
    @IBAction func imageButtonTapped(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setPickerAndToolBar() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closePicker))
        toolBar.setItems([doneButton1], animated: false)
        
        ingredientNameTextField.inputView = ingredientPicker
        ingredientNameTextField.inputAccessoryView = toolBar
        
        
        let doneButton2 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closePicker))
        toolBar.setItems([doneButton2], animated: false)
        
        categoryTextField.inputView = categoryPicker
        categoryTextField.inputAccessoryView = toolBar
    }
    
    @IBAction func addNewRecipeTapped(_ sender: UIButton) {
        if allFieldsHaveInputs {
            createRecipe()
            saveRecipe()
            clearAllTextFields()
            tableView.reloadData()
        }
    }
    
    @IBAction func addIngredientTapped(_ sender: UIButton) {
        if ingredientAmountTextField.hasText && ingredientNameTextField.hasText {
            arrayIngredients.append("\(ingredientNameTextField.text!)")
            arrayOfAmounts.append("\(ingredientAmountTextField.text!)")
            
            if !ingredientList.name!.contains(ingredientNameTextField.text!) {
                ingredientList.name!.append(ingredientNameTextField.text!)
                saveItems()
            }
            
            ingredientNameTextField.text = ""
            ingredientAmountTextField.text = ""
        }
        
            // create new Ingredient object. add new object to array. set array to new object. save. load picker with new Object
            
        
        tableView.reloadData()
    }
    
    func saveItems() {
        do {
            try Constants.context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
//    func loadRecipes() {
//        
//        let request: NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
//        do {
//            ingredientList.name = try Constants.context.fetch(request) as! [String]
//        } catch {
//            print("Error fetching data from context: \(error)")
//        }
//        tableView.reloadData()
//    }
    
    func clearAllTextFields() {
        nameTextField.text = ""
        timeTextField.text = ""
        descriptionTextField.text = ""
        instructionsTextField.text = ""
        ingredientAmountTextField.text = ""
        ingredientNameTextField.text = ""
        categoryTextField.text = ""
        ingredientList.name?.removeAll()
        ingredientList.amount?.removeAll()
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
        newIngredients.name    = arrayIngredients
        newIngredients.amount  = arrayOfAmounts
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
            return ingredientList.name?.count ?? 0
        case categoryPicker:
            return Constants.categories.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case ingredientPicker:
            return ingredientList.name?.sorted { $0 < $1 }[row] ?? "Error"
        case categoryPicker:
            return Constants.categories[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case ingredientPicker:
            ingredientNameTextField.text = ingredientList.name?.sorted { $0 < $1 }[row] ?? "Error"
        case categoryPicker:
            categoryTextField.text = Constants.categories[row]
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
        ingredientPicker.delegate          = self
        ingredientPicker.dataSource        = self
        tableView.delegate                 = self
        tableView.dataSource               = self
        navigationController?.delegate     = self
    }
}

extension AddVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayIngredients.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientListCell", for: indexPath) as? IngredientListCell {
            cell.configCell(arrayIngredients, arrayOfAmounts, indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            ingredientList.name?.remove(at: indexPath.row)
            ingredientList.amount?.remove(at: indexPath.row)
            arrayIngredients.remove(at: indexPath.row)
            arrayOfAmounts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
}
