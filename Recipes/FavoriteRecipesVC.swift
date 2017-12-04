//
//  FavoriteRecipesVC.swift
//  Recipes
//
//  Created by Marc Marlotte on 11/26/17.
//  Copyright © 2017 Marc Marlotte. All rights reserved.
//

import UIKit

class FavoriteRecipesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var defaultsData = UserDefaults.standard
    var favoriteAddedRecipeList = AddRecipeVC()
    var favRecipeVC = [FavRecipe]()
    var favRecipesConstant = [FavRecipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 245/255, green: 105/255, blue: 35/255, alpha: 1.0)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func loadLocations(completed: @escaping () -> ()) {
        guard let locationsEncoded = UserDefaults.standard.value(forKey: "favRecipesConstant") as? Data else {
            print("Could not load locationsArray data from UserDefaults")
            return
        }
        let decoder = JSONDecoder()
        if let favRecipesConstant = try? decoder.decode(Array.self, from: locationsEncoded) as [FavRecipe] {
            self.favRecipesConstant = favRecipesConstant
        } else {
            print("ERROR: Couldn't decode data")
        }
        completed()
    }
    
    @IBAction func unwindFromDetailViewController(segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! RecipeDetailVC
        if let indexPath = tableView.indexPathForSelectedRow {
            favRecipeVC[indexPath.row] = sourceViewController.favRecipe[0]
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: favRecipeVC.count, section: 0)
            favRecipeVC.append(sourceViewController.favRecipe[0])
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
//        saveDefaultsData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CellSegueTwo" {
            let destination = segue.destination as! FavoriteDetailVC
            let index = tableView.indexPathForSelectedRow!.row
            destination.recipeNamee = favRecipeVC[index].recipeName
            destination.recipeIngredient = [favRecipeVC[index].recipeIngredients]
            destination.recipeImageURL = favRecipeVC[index].recipeImageURL
            destination.recipeInstructionWebsite = favRecipeVC[index].recipeInstructionsURL
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: false)
            }
        }
    }
    
}

extension FavoriteRecipesVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favRecipeVC.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCells", for: indexPath)
        cell.textLabel?.text = favRecipeVC[indexPath.row].recipeName
        return cell
    }
    
}

