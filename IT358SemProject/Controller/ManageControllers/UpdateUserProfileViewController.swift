//
//  UpdateUserProfileViewController.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 3/20/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import UIKit
import os.log
import CoreData
import FirebaseDatabase
import FirebaseAuth
import Firebase


class UpdateUserProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    
    //MARK: Properties
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userUniversity: UITextField!
    @IBOutlet weak var userCourse: UITextField!
    @IBOutlet weak var userPhone: UITextField!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    @IBOutlet weak var userAddress: UITextField!
    @IBOutlet weak var userInterests: UITextView!
    @IBOutlet weak var userStatus: UITextView!
    
    var person: [NSManagedObject] = []
    var userID: String = ""
    static var name = ""
    
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        loadData()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
           super.viewDidAppear(animated)
    }
    
    //MARK: Navigation
    //Save button is pressed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        UpdateUserProfileViewController.name = userName.text ?? ""
        
        super.prepare(for: segue, sender: sender)
        
        let profileImageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(profileImageName).png")
        
        
        if let uploadData =  userImage.image?.pngData()
        {
            storageRef.putData(uploadData, metadata: nil) { (uploadedImageMeta, error) in
                
                if error != nil
                {
                    print("Error took place \(String(describing: error?.localizedDescription))")
                    return
                } else {
                    
                    print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
                    
                    storageRef.downloadURL(completion: { url , error in
                        if let error = error {
                            print( error.localizedDescription)
                        } else {
                            print("Download URL is \(String(describing: url))")
                            let user = [
                                "UserCourse" : self.userCourse.text ?? "",
                                "UserEmailID" : StartViewController.email,
                                "UserName" : self.userName.text ?? "",
                                "UserContact" : self.userPhone.text ?? "",
                                "UserUniversity" : self.userUniversity.text ?? "",
                                "UserAddress" : self.userAddress.text ?? "",
                                "UserStatus" : self.userStatus.text ?? "",
                                "UserInterest" : self.userInterests.text ?? "",
                                "PropertyImageUrl" : url?.absoluteString ?? ""
                                ] as [String : Any]
                            
                            Database.database().reference().child("User").child(self.uid ?? "").setValue(user)
                                {
                                (error, ref) in
                                if error != nil {
                                    print(error!)
                                }
                                else {
                                    print("Property saved successfully!")
                                }
                            }
                        }
                    })
                } // End of else statement
            }
        } // end of outer if        
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
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
        
        userImage.image = selectedImage
        print(selectedImage.size)
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Private functions
    
    func loadData() {
        userEmail.text = StartViewController.email
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("User").child(userID!).observeSingleEvent(of: .value, with:
        { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                UpdateUserProfileViewController.name = dictionary["UserName"] as? String ?? ""
                self.userName.text = dictionary["UserName"] as? String
                self.userUniversity.text = dictionary["UserUniversity"] as? String
                self.userCourse.text = dictionary["UserCourse"] as? String
                self.userPhone.text = dictionary["UserContact"] as? String
                self.userInterests.text = dictionary["UserInterest"] as? String
                self.userStatus.text = dictionary["UserStatus"] as? String
                self.userAddress.text = dictionary["UserAddress"] as? String
                let imageStr = dictionary["PropertyImageUrl"] as? String
                
                let imageUrl = URL(string: imageStr ?? "")
                if imageUrl != nil{
                    let imageData = try! Data(contentsOf: imageUrl!)
                    self.userImage.image = UIImage(data: imageData)
                }
            }
        }) {(error) in
        print(error.localizedDescription)
        }
    }
}

