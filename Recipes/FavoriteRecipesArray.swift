//
//  FavoriteRecipesArray.swift
//  Recipes
//
//  Created by Marc Marlotte on 12/4/17.
//  Copyright © 2017 Marc Marlotte. All rights reserved.
//

import Foundation


struct FavRecipe: Codable {
    var recipeName: String
    var recipeIngredients: String
    var recipeURL: String
    var recipeImageURL: String
    var recipeInstructionsURL: String
    var randomRecipeChosenName: String
}

