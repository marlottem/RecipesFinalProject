//
//  RecipeDetailVC.swift
//  Recipes
//
//  Created by Marc Marlotte on 11/26/17.
//  Copyright © 2017 Marc Marlotte. All rights reserved.
//

import UIKit

class RecipeDetailVC: UIViewController {
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeIngredients: UITextView!
    @IBOutlet weak var recipeImage: UIImageView!
    
    var recipeNamee: String?
    var recipeIngredient: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeName.text = recipeNamee
        recipeIngredients.text = recipeIngredient
    }
}
