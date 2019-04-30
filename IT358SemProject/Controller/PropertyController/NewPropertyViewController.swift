//
//  NewPropertyViewController.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 3/14/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import UIKit
import os.log
import CoreData
import Firebase

class NewPropertyViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    
    @IBOutlet weak var PropertyName: UITextField!
    @IBOutlet weak var PropertyAddress: UITextField!
    @IBOutlet weak var PropertyDesc: UITextView!
    @IBOutlet weak var PropertyImage1: UIImageView!
    @IBOutlet weak var PropertyImage2: UIImageView!
    @IBOutlet weak var PropertyImage3: UIImageView!
    @IBOutlet weak var PropertyImage4: UIImageView!
    @IBOutlet weak var OwnerName: UILabel!
    @IBOutlet weak var ownerContact: UILabel!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var universityNAme: UITextField!
    
    var properties: [NSManagedObject] = []
    var images: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PropertyName.delegate = self
        ownerContact.text = StartViewController.email
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        
        let predicate = NSPredicate(format: "%K == %@", "emailID", StartViewController.email)
        
        fetchRequest.predicate = predicate
        
        do {
            
            let persons = try managedContext.fetch(fetchRequest) as! [Person] // Need to downcast
            
            for p in persons{
                OwnerName.text = p.name
            }
            
        }catch let error as NSError {
                        
                        print("Could not save. \(error), \(error.userInfo)")
        }

        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    
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
    
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        PropertyImage1.image = selectedImage
        print(selectedImage.size)
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //Save button is presse""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       // super.prepare(for: segue, sender: sender)
        let propertiesDB = Database.database().reference().child("Properties")
        
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("university_images").child("\(imageName).png")

        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        let uploadTask = storageRef.putData((PropertyImage1.image?.pngData())!, metadata: metadata)
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
           
                               storageRef.downloadURL(completion: { url , error in
                                    if let error = error {
                                        print( error.localizedDescription)
                                    } else {
                                        print("Download URL is \(String(describing: url))")
                                        let propertyDictionary : NSDictionary = [
                                            "OwnerContact" : StartViewController.email,
                                            "PropertyName" : self.PropertyName.text!,
                                            "PropertyAddress" : self.PropertyAddress.text ?? "",
                                            "PropertyDesc" : self.PropertyDesc.text ?? "",
                                            "PropertyUniversity" : self.universityNAme.text!,
                                            "PropertyImageUrl" : url?.absoluteString ?? ""
                                        ]
            
                                propertiesDB.childByAutoId().setValue(propertyDictionary) {
                                            (error, ref) in
                                            if error != nil {
                                                print(error!)
                                            }
                                            else {
                                                print("Property saved successfully!")
                                                super.prepare(for: segue, sender: sender)
                                            }
                                        }
                                    }
                                })
        }
        //        if let uploadData = PropertyImage1.image?.pngData()
//        {
//            storageRef.putData(uploadData, metadata: nil) { (uploadedImageMeta, error) in
//
//                if error != nil
//                {
//                    print("Error took place \(String(describing: error?.localizedDescription))")
//                    return
//                } else {
//
//                    print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
//
//                    storageRef.downloadURL(completion: { url , error in
//                        if let error = error {
//                            print( error.localizedDescription)
//                        } else {
//                            print("Download URL is \(String(describing: url))")
//                            let propertyDictionary : NSDictionary = [
//                                "OwnerContact" : StartViewController.email,
//                                "PropertyName" : self.PropertyName.text!,
//                                "PropertyAddress" : self.PropertyAddress.text ?? "",
//                                "PropertyDesc" : self.PropertyDesc.text ?? "",
//                                "PropertyUniversity" : self.universityNAme.text!,
//                                "PropertyImageUrl" : url?.absoluteString
//                            ]
//
//                    propertiesDB.childByAutoId().setValue(propertyDictionary) {
//                                (error, ref) in
//                                if error != nil {
//                                    print(error!)
//                                }
//                                else {
//                                    print("Property saved successfully!")
//                                    super.prepare(for: segue, sender: sender)
//                                }
//                            }
//                        }
//                    })
//                } // End of else statement
//            }
//        } // end of outer if
        
        
        
    }
    
    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        PropertyDesc.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
   
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let name = PropertyName.text ?? ""
        saveButton.isEnabled = !name.isEmpty
    }
}
