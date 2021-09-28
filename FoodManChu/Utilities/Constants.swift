//
//  Constants.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/11/21.
//

import Foundation
import UIKit

struct Constants {
    static let context     = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let categories: [String] = ["Meat","Vegetarian","Vegan","Paleo","Keto"]
    
    static func save() {
        do {
            try Constants.context.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

struct SegueConstants {
    static let detailSegue = "DetailSegue"
    static let addSegue    = "AddSegue"
}

