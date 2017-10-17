//
//  ViewController.swift
//  FoodTracker
//
//  Created by Paul on 2017-10-08.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import os.log
import Parse



protocol SaveItemDelegate {
    func addMealObject(meal:Meal)
}


class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var saveDelegate: SaveItemDelegate?
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var meal: Meal?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.star
        }
        
        //enable the save button only if the text field has a valid meal name
        updateSaveButtonState()
        
        
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //disable save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {

        updateSaveButtonState()
        navigationItem.title = textField.text
        
    }

    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
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
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else
        {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
    }
    

    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer)
    {
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
    

    //MARK: SaveInformation to cloud & addMealsDelegate to push data to tableview
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        //error handling
        let name = nameTextField.text ?? ""
        
        // Convert photo to data
        guard let photo = photoImageView.image else {
            return
        }
        
        // compress photo and save it to data

        let data = PFFile(data: UIImageJPEGRepresentation(photo, 0.5)!)
        
        guard let pfFileData =  data else {
            return
        }
        //since Meal() is a subclass of NSManaged
        let meal = Meal(name: name, rating: ratingControl.rating, pfFile: pfFileData)
        
        
        meal?.saveInBackground()
        
        if let meal = meal {
        
            saveDelegate?.addMealObject(meal: meal)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
        
        

    
    //MARK: Save button after certain conditions
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    
    
    

}

