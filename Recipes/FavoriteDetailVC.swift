//
//  FavoriteDetailVC.swift
//  Recipes
//
//  Created by Marc Marlotte on 12/4/17.
//  Copyright © 2017 Marc Marlotte. All rights reserved.
//

import UIKit
import SafariServices

class FavoriteDetailVC: UIViewController {
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeIngredients: UITextView!
    
    var defaultsData = UserDefaults.standard
    var recipeNamee: String?
    var recipeIngredient: [String] = []
    var recipeImageURL: String?
    var recipeIngredientString = ""
    var recipeInstructionWebsite: String?
    var favoritesArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlPicture()
        recipeName.text = recipeNamee
        self.navigationItem.title = self.recipeNamee
        printRecipeIngredients()
        recipeIngredients.text = recipeIngredientString
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func printRecipeIngredients() {
        for index in 0...recipeIngredient.count-1 {
            recipeIngredientString += "\(recipeIngredient[index])\n"
        }
    }
    
    func urlPicture() {
        let imageURL = URL(string: recipeImageURL!)
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: imageURL!) { (data, response, error) in
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.recipeImage.image = image
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
    }
    
    @IBAction func viewInstructionsPressed(_ sender: UIButton) {
        let svc = SFSafariViewController(url: URL(string: recipeInstructionWebsite!)!)
        self.present(svc, animated: true, completion: nil)
    }
    
}
