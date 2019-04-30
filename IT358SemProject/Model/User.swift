//
//  User.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 4/9/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import Foundation

class User{
    
    //MARK: Properties
    
    var name: String
    var contact: String
    var universityCourse: String
    var universityName: String
    var email: String
    var imageURL : String
    var address : String
    var interest : String
    var status : String
    
    //MARK: Initializations
    
    init(name: String, contact: String, universityCourse: String, universityName: String, email: String, imageURL : String, address : String, interest : String, status : String){
        self.name = name
        self.universityCourse = universityCourse
        self.contact = contact
        self.universityName = universityName
        self.email = email
        self.imageURL = imageURL
        self.address = address
        self.interest = interest
        self.status = status
    }
    
}
