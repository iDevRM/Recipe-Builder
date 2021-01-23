//
//  AddVC.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/20/21.
//

import UIKit

class AddVC: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        timeTextField.delegate = self
        descriptionTextField.delegate = self
        ingredientsTextField.delegate = self
        
    }
    
    @IBAction func imageButtonTapped(_ sender: UIButton) {
        
    }
    

}

//MARK: - TextField delegate methods
extension AddVC: UITextFieldDelegate {
    
}
