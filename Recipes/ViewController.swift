//
//  ViewController.swift
//  Recipes
//
//  Created by Marc Marlotte on 11/26/17.
//  Copyright © 2017 Marc Marlotte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setUpActivityIndicator()
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        recipe.getRecipes {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.navigationItem.title = "Yummly's Top \(self.recipe.recipeArray.count) Recipes"
        }
    }
    
    var recipe = Recipe()
    var activityIndicator = UIActivityIndicatorView()
//    var recipeArray = ["Fried Rice", "Pizza", "French Omlette", "Steak Tips", "Tacos", "Quesadillas", "Cheese Curds", "All American Burger", "Pesto Chicken", "Cajun Beef"]
    
    func setUpActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.blue
        view.addSubview(activityIndicator)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CellSegue" {
            let destination = segue.destination as! RecipeDetailVC
            let index = tableView.indexPathForSelectedRow!.row
            destination.recipeNamee = recipe.recipeArray[index].recipeName
            destination.recipeIngredient = recipe.recipeArray[index].recipeName
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: false)
            }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.recipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row+1). " + recipe.recipeArray[indexPath.row].recipeName
        if indexPath.row == recipe.recipeArray.count-1 && !recipe.urlsRetrieved.contains(recipe.recipesURL) {
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            recipe.getRecipes {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.navigationItem.title = "Loaded \(self.recipe.recipeArray.count) of Recipes: \(self.recipe.totalRecipes)"
            }
        }
        return cell
    }
}
