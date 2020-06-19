//
//  ViewController.swift
//  FoodTracker
//
//  Created by 纪常宇 on 6/15/20.
//  Copyright © 2020 纪常宇. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController,  UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var meal: Meal?
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func setLabel(_ sender: Any) {
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
         let isPresentingInAddMealMode = presentingViewController is UINavigationController
           
           if isPresentingInAddMealMode {
               dismiss(animated: true, completion: nil)
           }
           else if let owningNavigationController = navigationController{
               owningNavigationController.popViewController(animated: true)
           }
           else {
               fatalError("The MealViewController is not inside a navigation controller.")
           }
    }
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //mealNameLabel.text = "Default Text"
        nameTextField.delegate = self
                
        // Enable the Save button only if the text field has a valid Meal name.
        
        
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        updateSaveButtonState()

        // Do any additional setup after loading the view.
    }
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")}
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
         // Configure the destination view controller only when the save button is pressed.在传送meal之前，检查按的是哪个button，
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
    }

}

