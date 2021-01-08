//
//  ViewController.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/7/21.
//

import UIKit

class InitialVC: UIViewController {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func button1WasTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "searchVCSegue", sender: nil)
    }
    
    @IBAction func button2WasTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func button3WasTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func button4WasTapped(_ sender: UIButton) {
    
    }
    
    @IBAction func button5WasTapped(_ sender: UIButton) {
        
    }

}
