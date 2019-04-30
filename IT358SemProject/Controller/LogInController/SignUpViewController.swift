//
//  SignUpViewController.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 3/12/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class SignUpViewController: UIViewController {

    //MARK: Properties
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var passwordConfirm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //MARK: Action

    @IBAction func signUpAction(_ sender: UIButton) {
        
        if password.text != passwordConfirm.text {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Confirm Password does not match.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (user, error) in
                if error == nil {
                    
                    let uid = Auth.auth().currentUser?.uid
                    let usersDB = Database.database().reference().child("User").child(uid ?? "")
                    
                    let userDictionary : NSDictionary = [
                        "UserName" : "",
                        "UserCourse" : "",
                        "UserEmailID" : self.email.text!,
                        "UserAddress" : "",
                        "UserContact" : "",
                        "UserUniversity" : "",
                        "UserInterest" : "",
                        "UserStatus" : ""
                    ]
                    usersDB.setValue(userDictionary) {
                        (error, ref) in
                        if error != nil {
                            print(error!)
                        }
                        else {
                            StartViewController.email = self.email.text!
                            print("User saved successfully!")
                        }
                    }
                    self.performSegue(withIdentifier: "signupToHome", sender: self)
                }
                
            }
        }
    }
}
