//
//  UpdateInfoViewController.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 4/12/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UpdateInfoViewController: UIViewController {

    //MARK: Properties
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userAddress: UITextField!
    @IBOutlet weak var userCourse: UITextField!
    @IBOutlet weak var userUniversity: UITextField!
    @IBOutlet weak var userContact: UITextField!
    @IBOutlet weak var userInterest: UITextView!
    @IBOutlet weak var userStatus: UITextView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //MARK: Actions
    
    @IBAction func updateProfile(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        let user = [
            "UserName" : self.userName.text ?? "",
            "UserCourse" : self.userCourse.text ?? "",
            "UserEmailID" : StartViewController.email,
            "UserAddress" : self.userAddress.text ?? "",
            "UserContact" : self.userContact.text ?? "",
            "UserUniversity" : self.userUniversity.text ?? "",
            "UserInterest" : self.userInterest.text ?? "",
            "UserStatus" : self.userStatus.text ?? ""
            ] as [String : Any]
        
        Database.database().reference().child("User").child(uid ?? "").setValue(user)
    
    }
    
}
