//
//  Constants.swift
//  FoodManChu
//
//  Created by Ricardo Martinez on 1/11/21.
//

import Foundation
import UIKit

enum Constants {
    static let ad = UIApplication.shared.delegate as! AppDelegate
    static let context = ad.persistentContainer.viewContext
    static let cellReuseId = "RecipeCell"
}
