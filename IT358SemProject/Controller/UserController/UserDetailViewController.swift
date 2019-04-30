//
//  UserDetailViewController.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 3/27/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase

class UserDetailViewController: UIViewController {

    
    //MARK: Properties
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var UserUniversity: UILabel!
    @IBOutlet weak var UserCourse: UILabel!
    @IBOutlet weak var UserPhNo: UILabel!
    @IBOutlet weak var UserEmailID: UILabel!
    @IBOutlet weak var UserAddress: UILabel!
    //@IBOutlet weak var UserInterest: UITextView!
    @IBOutlet weak var UserStatus: UITextView!
    @IBOutlet weak var UserInterest: UITextView!
    
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user{
            
            UserName.text = user.name
            UserUniversity.text = user.universityName
            UserCourse.text = user.universityCourse
            UserEmailID.text = user.email
            UserPhNo.text = user.contact
            UserAddress.text = user.address
            UserInterest.text = user.interest
            UserStatus.text = user.status
            let imageUrl = URL(string: user.imageURL)
            if imageUrl != nil{
                let imageData = try! Data(contentsOf: imageUrl!)
                UserImage.image = UIImage(data: imageData)
            }
        }
    }

}
