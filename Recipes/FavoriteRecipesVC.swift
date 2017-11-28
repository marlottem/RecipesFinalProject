//
//  FavoriteRecipesVC.swift
//  Recipes
//
//  Created by Marc Marlotte on 11/26/17.
//  Copyright © 2017 Marc Marlotte. All rights reserved.
//

import UIKit

class FavoriteRecipesVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func allRecipesPressed(_ sender: UIBarButtonItem) {
        let presentedFromAllRecipes = presentingViewController is UINavigationController
        if presentedFromAllRecipes {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
