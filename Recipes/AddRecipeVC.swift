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
    
    var recipeImagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImagePicker.delegate = self
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
}
