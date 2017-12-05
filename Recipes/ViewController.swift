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
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLocations()
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 245/255, green: 105/255, blue: 35/255, alpha: 1.0)
        tableView.delegate = self
        tableView.dataSource = self
        addButton.tintColor = UIColor.white
        setUpActivityIndicator()
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        refreshRecipeData()
        pullToRefresh()
    }
    
    var recipe = Recipe()
    var activityIndicator = UIActivityIndicatorView()
    var refreshControl: UIRefreshControl!
    var favvvRecipe = [FavRecipe]()
    
//Set up activity indicator when TableView is getting JSON recipes
    func setUpActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.color = UIColor.init(red: 245/255, green: 105/255, blue: 35/255, alpha: 1.0)
        view.addSubview(activityIndicator)
    }
    
//Prepare for segues to RecipeDetailVC and FavoriteRecipesVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CellSegue" {
            let destination = segue.destination as! RecipeDetailVC
            let index = tableView.indexPathForSelectedRow!.row
            destination.recipeNamee = recipe.recipeArray[index].recipeName
            destination.recipeIngredient = recipe.recipeArray[index].recipeIngredients
            destination.recipeImageURL = recipe.recipeArray[index].recipeImageURL
            destination.recipeInstructionWebsite = recipe.recipeArray[index].recipeInstructionsURL
        } else if segue.identifier == "PresentFavorites" {
            if let navController = segue.destination as? UINavigationController {
                if let childvc = navController.topViewController as? FavoriteRecipesVC {
                    childvc.favRecipeVC = favvvRecipe
                }
            }
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: false)
            }
        }
    }
    
//Change Statusbar style to light
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
//Refresh RecipeData
    func refreshRecipeData() {
        recipe.getRecipes {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.navigationItem.title = "Top \(self.recipe.recipeArray.count) Recipes"
        }
    }
//Pull to Refresh Functions
    func replaceRecipeData() {
        recipe.replaceRecipes {
            DispatchQueue.main.async(){
                self.tableView.reloadData()
            }
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.navigationItem.title = "Top \(self.recipe.recipeArray.count) Recipes"
        }
    }
    
    func pullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc func refresh(_ sender: Any) {
        replaceRecipeData()
        refreshControl.endRefreshing()
    }
    
//Load locations function
    func loadLocations() {
        guard let locationsEncoded = UserDefaults.standard.value(forKey: "favRecipe") as? Data else {
            print("**** Could not load locationsArray data from UserDefaults")
            return
        }
        let decoder = JSONDecoder()
        if let favvvRecipe = try? decoder.decode(Array.self, from: locationsEncoded) as [FavRecipe] {
            self.favvvRecipe = favvvRecipe
        } else {
            print("ERROR: Couldn't decode data")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.recipeArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if recipe.recipeArray.count != 0 {
            cell.textLabel?.text = recipe.recipeArray[indexPath.row].recipeName
        } else {
            cell.textLabel?.text = recipe.randomRecipeArray[indexPath.row]
        }
        if indexPath.row == recipe.recipeArray.count-1 && recipe.urlsRetrieved.contains(recipe.recipesURLCombined) {
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            recipe.getRecipes {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.navigationItem.title = "Loaded \(self.recipe.recipeArray.count) Recipes"
            }
        }
        return cell
    }
}
