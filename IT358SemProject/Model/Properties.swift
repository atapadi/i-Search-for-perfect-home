//
//  Property.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 4/3/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import Foundation

class Properties{
    
    //MARK: Properties
    
    var name: String
    var contact: String
    var address: String
    var universityName: String
    var desc: String
    var imageURL : String
    
    //MARK: Initializations
    
    init(name: String, contact: String, address: String, universityName: String, desc: String, imageURL : String){
        self.name = name
        self.address = address
        self.contact = contact
        self.universityName = universityName
        self.desc = desc
        self.imageURL = imageURL
    }
    
}
