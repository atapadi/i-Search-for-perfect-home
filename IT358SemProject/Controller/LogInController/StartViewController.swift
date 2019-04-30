//
//  StartViewController.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 3/12/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import UIKit
import Firebase

class StartViewController: UIViewController {

    //MARK: Properties
    
    public static var email: String = ""
    
    @IBAction func LoginButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            print(Auth.auth().currentUser?.email)
            StartViewController.email = (Auth.auth().currentUser?.email)!
            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
        }
    }
}
