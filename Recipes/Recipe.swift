//
//  Recipe.swift
//  Recipes
//
//  Created by Marc Marlotte on 11/28/17.
//  Copyright © 2017 Marc Marlotte. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Recipe {
    struct RecipeData: Codable {
        var recipeName: String
        var recipeIngredients: [String] = []
        var recipeURL: String
        var recipeImageURL: String
        var recipeInstructionsURL: String
        var randomRecipeChosenName: String
    }
    
    var recipeArray = [RecipeData]()
    var totalRecipes = 0
    var urlsRetrieved = [String]()
    var recipesURLOne = "https://api.edamam.com/search?q="
    var recipesURLTwo = "&app_id=8b9755a9&app_key=88158a47708c2a82f63ab47d87d3f848&from=0&to=15"
    var recipesURLCombined = ""
    var randomRecipeChosen = ""
    var randomRecipeArray = ["beef",
                             "curry+leaves",
                             "sauerkraut",
                             "vermouth",
                             "okra",
                             "coconut+milk",
                             "cappuccino",
                             "cod",
                             "date+sugar",
                             "swiss+cheese",
                             "baklava",
                             "gyro",
                             "sandwich",
                             "hamburger",
                             "pasta",
                             "berries",
                             "cake",
                             "panini",
                             "grilled+chicken",
                             "lasagna",
                             "chicken+fingers",
                             "french+fries",
                             "brownie",
                             "fish+and+chips",
                             "clam",
                             "lobster",
                             "souffle",
                             "eggs",
                             "quesadilla",
                             "burrito",
                             "rice",
                             "greek+salad",
                             "calamari",
                             "pizza",
                             "sirloin",
                             "steak",
                             "lamb",
                             "broccoli",
                             "strawberry",
                             "tart",
                             "flan",
                             "yogurt",
                             "beer",
                             "bread",
                             "falafel",
                             "fried+rice",
                             "sushi",
                             "schawarma",
                             "guacamole",
                             "taco",
                             "tortelini",
                             "ravioli",
                             "linguini",
                             "cookies",
                             "cinnamon",
                             "vanilla",
                             "chocolate",
                             "lemon",
                             "cheese",
                             "savory",
                             "sweet",
                             "nut",
                             "sugar",
                             "vegetarian",
                             "meat",
                             "breakfast",
                             "lunch",
                             "dinner",
                             "dessert",
                             "macaroon",
                             "custard",
                             "latte",
                             "coffee",
                             "mint"]
    
    func randomFoodGenerator() {
        let randomNumber = Int(arc4random_uniform(UInt32(randomRecipeArray.count)))
        let randomRecipe = randomRecipeArray[randomNumber]
        recipesURLCombined = "\(recipesURLOne)\(randomRecipe)\(recipesURLTwo)"
        randomRecipeChosen = randomRecipe.capitalized
        //I need to modify my getRecipes function to get any number of random recipes from the randomRecipeArray above. What randomFoodGenerator serves to do is select the random food which I then need to append to the end of the api website key and then take a random recipe from the list of results.
    }
    
    func getRecipes(completed: @escaping () -> ()) {
        randomFoodGenerator()
        urlsRetrieved.append(recipesURLCombined)
        Alamofire.request(recipesURLCombined).responseJSON {response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.totalRecipes = json["to"].intValue - json["from"].intValue
//                self.recipesURL = json["next"].stringValue
                let numberOfRecipes = json["hits"].count-1
                for index in 0...numberOfRecipes {
                    let name = json["hits"][index]["recipe"]["label"].stringValue
                    let recipeImage = json["hits"][index]["recipe"]["image"].stringValue
                    let numberOfIngredients = json["hits"][index]["recipe"]["ingredientLines"].count
                    let recipeInstructionsURL = json["hits"][index]["recipe"]["url"].stringValue
                    var ingredientArray: [String] = []
                    for ingredientIndex in 0...numberOfIngredients {
                        let singleIngredient = json["hits"][index]["recipe"]["ingredientLines"][ingredientIndex].stringValue
                        ingredientArray.append(singleIngredient)
                    }
                    var urlRecipeName = name.lowercased()
                    urlRecipeName = urlRecipeName.replacingOccurrences(of: " ", with: "+")
                    let urlRecipePage = json["hits"][index]["recipe"]["shareAs"].stringValue
                    self.recipeArray.append(RecipeData(recipeName: name, recipeIngredients: ingredientArray, recipeURL: urlRecipePage, recipeImageURL: recipeImage, recipeInstructionsURL: recipeInstructionsURL, randomRecipeChosenName: self.randomRecipeChosen))
                }
            case .failure(let error):
                print("ERROR: \(error) failed to get data from url: \(self.recipesURLCombined)")
            }
            completed()
        }
    }
    
    func replaceRecipes(completed: @escaping () -> ()) {
        recipeArray = []
        recipeArray = [RecipeData]()
        randomFoodGenerator()
        urlsRetrieved.append(recipesURLCombined)
        Alamofire.request(recipesURLCombined).responseJSON {response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.totalRecipes = json["to"].intValue - json["from"].intValue
                let numberOfRecipes = json["hits"].count-1
                for index in 0...numberOfRecipes {
                    let name = json["hits"][index]["recipe"]["label"].stringValue
                    let recipeImage = json["hits"][index]["recipe"]["image"].stringValue
                    let numberOfIngredients = json["hits"][index]["recipe"]["ingredientLines"].count
                    let recipeInstructionsURL = json["hits"][index]["recipe"]["url"].stringValue
                    var ingredientArray: [String] = []
                    for ingredientIndex in 0...numberOfIngredients {
                        let singleIngredient = json["hits"][index]["recipe"]["ingredientLines"][ingredientIndex].stringValue
                        ingredientArray.append(singleIngredient)
                    }
                    var urlRecipeName = name.lowercased()
                    urlRecipeName = urlRecipeName.replacingOccurrences(of: " ", with: "+")
                    let urlRecipePage = json["hits"][index]["recipe"]["shareAs"].stringValue
                    self.recipeArray.append(RecipeData(recipeName: name, recipeIngredients: ingredientArray, recipeURL: urlRecipePage, recipeImageURL: recipeImage, recipeInstructionsURL: recipeInstructionsURL, randomRecipeChosenName: self.randomRecipeChosen))
                }
            case .failure(let error):
                print("ERROR: \(error) failed to get data from url: \(self.recipesURLCombined)")
            }
            completed()
        }
    }
}
