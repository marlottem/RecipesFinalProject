//
//  AddRecipeVC.swift
//  Recipes
//
//  Created by Marc Marlotte on 11/26/17.
//  Copyright © 2017 Marc Marlotte. All rights reserved.
//

import UIKit

class AddRecipeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeNameTextField: UITextField!
    @IBOutlet weak var recipeIngredientsTextView: UITextView!
    
    var defaultsData = UserDefaults.standard
    var localRecipeAddedNameArray = [String]()
    var localRecipeAddedIngredientsArray = [String]()
    var localRecipeAddedImageArray = [UIImage]()
    
    struct FavoriteRecipesAdded {
        var recipeAddedName: String
        var recipeAddedIngredients: [String] = []
        var recipeAddedImage = UIImage()
    }
    
    var favoriteRecipesAdded = [FavoriteRecipesAdded]()
    

    var recipeImagePicker = UIImagePickerController()
    var recipeName: String = ""
    var recipeIngredients: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImagePicker.delegate = self
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 245/255, green: 105/255, blue: 35/255, alpha: 1.0)
    }
    
    func saveDefaultsData() {
        defaultsData.set(localRecipeAddedNameArray, forKey: "localRecipeAddedNameArray")
        defaultsData.set(localRecipeAddedIngredientsArray, forKey: "localRecipeAddedIngredientsArray")
    }
    
    //Pick an image from the library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedPicture = info[UIImagePickerControllerOriginalImage] as! UIImage
        recipeImage.image = selectedPicture
        dismiss(animated: true, completion: nil)
    }
    
    //Cancels choosing the image
    func imagePickerCanceled(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Shows Error Alert
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func addRecipeImagePressed(_ sender: UIButton) {
        recipeImagePicker.sourceType = .photoLibrary
        present(recipeImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        //Here i want to segue to favorite recipes and also save the information added to the array housing favorite recipes
    }
    
}
