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
    struct RecipeData {
        var recipeName: String
        var recipeIngredients: [String]
        var recipeURL: String
        
    }
    var recipeArray = [RecipeData]()
    var totalRecipes = 0
    var urlsRetrieved = [String]()
    var recipesURL = "http://api.yummly.com/v1/api/recipes?_app_id=e25a7c65&_app_key=d1e30787fe56eeec28a292df9e9c6c60"
    
    func getRecipes(completed: @escaping () -> ()) {
        urlsRetrieved.append(recipesURL)
        Alamofire.request(recipesURL).responseJSON {response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.totalRecipes = json["totalMatchCount"].intValue
//                self.recipesURL = json["next"].stringValue
                let numberOfRecipes = json["matches"].count-1
                for index in 0...numberOfRecipes {
                    let name = json["matches"][index]["recipeName"].stringValue
                    let ingredients = json["matches"][index]["ingredients"].stringValue
                    var urlRecipeName = name.lowercased()
                    urlRecipeName = urlRecipeName.replacingOccurrences(of: " ", with: "+")
                    let urlRecipePage = "\(self.recipesURL)&q=\(urlRecipeName)"
                    self.recipeArray.append(RecipeData(recipeName: name, recipeIngredients: [ingredients], recipeURL: urlRecipePage))
                    print("\(index) \(name) \(ingredients) \(urlRecipePage)")
                }
            case .failure(let error):
                print("ERROR: \(error) failed to get data from url: \(self.recipesURL)")
            }
            completed()
        }
    }
}
