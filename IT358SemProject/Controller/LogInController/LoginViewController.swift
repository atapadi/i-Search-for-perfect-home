//
//  LoginViewController.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 3/12/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Actions
    @IBAction func loginAction(_ sender: UIButton) {
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if error == nil{
                StartViewController.email = self.email.text!
                self.performSegue(withIdentifier: "loginToHome", sender: self)
            }
            else{
                var errorMessage = ""
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    default:
                        errorMessage = "Invalid email or password"
                        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
