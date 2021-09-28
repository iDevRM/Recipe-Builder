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
    @IBOutlet weak var ingredientNameTextField  : UITextField!
    @IBOutlet weak var instructionsTextField    : UITextField!
    @IBOutlet weak var imageView                : UIImageView!
    @IBOutlet weak var addNewRecipeButton       : UIButton!
    @IBOutlet weak var categoryTextField        : UITextField!
    @IBOutlet weak var addIngredientButton      : UIButton!
    @IBOutlet weak var tableView                : UITableView!
    @IBOutlet weak var createNewIngredientButton: UIButton!
    
    
    var imagePicker:              UIImagePickerController!
    let ingredientPicker =        UIPickerView()
    let categoryPicker =          UIPickerView()
    var newRecipe:                Recipe?
    var storedIngredientNames =   [String]()
    var storedIngredientAmounts = [String]()
    var ingredientArray =         [Ingredients]()
    var preloadedIngredients =    [Ingredients]()
    var arrayOfNames:             [String] = []
    var ingredientSet =           Set<Ingredients>()
    var textFieldArray =          [UITextField]()
    var pickerArray =             [UIPickerView]()
    
    var allFieldsHaveInputs: Bool {
        if textFieldArray.filter({ !$0.hasText}).isEmpty &&
           imageView.image != UIImage(systemName: "photo") {
            return true
        } else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerArray = [ingredientPicker,categoryPicker,]
        textFieldArray = [nameTextField,
                          timeTextField,
                          descriptionTextField,
                          instructionsTextField,
                          categoryTextField]
        addNewRecipeButton.layer.cornerRadius        = 5
        createNewIngredientButton.layer.cornerRadius = 5
        addIngredientButton.layer.cornerRadius       = 4
        imagePicker                                  = UIImagePickerController()
        setAllDelegates()
        setPickerAndToolBar()
        loadIngredients()
        createArrayOfNames()
    }
    
    func createArrayOfNames() {
        for ingredient in preloadedIngredients {
            if let name = ingredient.name {
                arrayOfNames.append(name)
            }
        }
    }
    
    func createRecipe() {
        let newRecipe          = Recipe(context: Constants.context)
        newRecipe.name         = nameTextField.text!
        newRecipe.descript     = descriptionTextField.text!
        newRecipe.instructions = instructionsTextField.text!
        newRecipe.prepTime     = timeTextField.text!
        newRecipe.image        = imageView.image
        
        let category           = Categories(context: Constants.context)
        category.name          = categoryTextField.text!
        newRecipe.category     = category
        
        for name in storedIngredientNames {
            if let ingredient = preloadedIngredients.first(where: { $0.name == name }) {
                let index = storedIngredientNames.firstIndex(where: { $0 == name })
                ingredient.amount = storedIngredientAmounts[index!]
                ingredientSet.insert(ingredient)
            }
        }
        newRecipe.ingredients  = ingredientSet as NSSet
    }
    
    func clearAllTextFields() {
        textFieldArray.forEach({ $0.text = ""})
        ingredientAmountTextField.text = ""
        ingredientNameTextField.text   = ""
        ingredientArray.removeAll()
        imageView.image = UIImage(systemName: "photo")
    }
    
    //MARK: - IBActions
    @IBAction func imageButtonTapped(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addNewRecipeTapped(_ sender: UIButton) {
        if allFieldsHaveInputs {
            createRecipe()
            Constants.save()
            clearAllTextFields()
            storedIngredientNames.removeAll()
            storedIngredientAmounts.removeAll()
            tableView.reloadData()
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func addIngredientTapped(_ sender: UIButton) {
        if ingredientAmountTextField.hasText && ingredientNameTextField.hasText && preloadedIngredients.contains(where: { $0.name == "\(ingredientNameTextField.text!)" }) {
            storedIngredientNames.append(ingredientNameTextField.text!)
            storedIngredientAmounts.append(ingredientAmountTextField.text!)
            ingredientNameTextField.layer.borderWidth = 0
            ingredientNameTextField.text = ""
            ingredientAmountTextField.text = ""
        } else {
            ingredientNameTextField.text = ""
            ingredientNameTextField.layer.borderWidth = 2
            ingredientNameTextField.layer.borderColor = UIColor.systemRed.cgColor
            ingredientNameTextField.placeholder = "Invalid Ingredient"
        }
        tableView.reloadData()
    }
}

//MARK: - Objective C methods
extension AddVC {
    @objc func closePicker() {
        ingredientNameTextField.resignFirstResponder()
        categoryTextField.resignFirstResponder()
    }
}

//MARK: - Data manipulation methods
extension AddVC {
    func loadIngredients() {
        let request: NSFetchRequest<Ingredients> = Ingredients.fetchRequest()
        do {
            preloadedIngredients = try Constants.context.fetch(request)
        } catch {
            debugPrint("Error fetching data from context: \(error)")
        }
    }
    
    func removeIngredient(at index: Int) {
        Constants.context.delete(preloadedIngredients[index])
        preloadedIngredients.remove(at: index)
        Constants.save()
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case ingredientPicker:
            return arrayOfNames.count
        case categoryPicker:
            return Constants.categories.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case ingredientPicker:
            return arrayOfNames.sorted { $0 < $1 }[row]
        case categoryPicker:
            guard Constants.categories.indices.contains(row) else { return nil }
            return Constants.categories[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case ingredientPicker:
            ingredientNameTextField.text = arrayOfNames.sorted { $0 < $1 }[row]
        case categoryPicker:
            categoryTextField.text = Constants.categories[row]
        default:
            break
        }
    }
}

//MARK: - Image picker delegate methods and navigation controller methods
extension AddVC:  UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let destVC = viewController as? SearchVC {
            destVC.loadRecipes()
            destVC.tableView.reloadData()
        }
    }
}

extension AddVC {
    func setAllDelegates() {
        textFieldArray.forEach {$0.delegate = self}
        pickerArray.forEach {$0.delegate = self}
        pickerArray.forEach {$0.dataSource = self}
        imagePicker.delegate               = self
        ingredientAmountTextField.delegate = self
        ingredientNameTextField.delegate   = self
        tableView.delegate                 = self
        tableView.dataSource               = self
        navigationController?.delegate     = self
    }
}

//MARK: - Table view delegates and data source
extension AddVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedIngredientNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientListCell", for: indexPath) as? IngredientListCell {
            cell.configCell(storedIngredientNames[indexPath.row], storedIngredientAmounts[indexPath.row])
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
            storedIngredientNames.remove(at: indexPath.row)
            storedIngredientAmounts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}


