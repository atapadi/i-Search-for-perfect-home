//
//  PropertyDetailViewController.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 3/27/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import UIKit
import CoreData

class PropertyDetailViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var PropertyName: UILabel!
    @IBOutlet weak var PropertyAddress: UILabel!
    @IBOutlet weak var PropertyDesc: UITextView!
    @IBOutlet weak var PropertyImage1: UIImageView!
    
    @IBOutlet weak var PropertyUniversity: UILabel!
    
    @IBOutlet weak var OwnerContact: UILabel!
    
    var property : Properties?
    
    static var propertyAdd: String = ""
    static var propertyName: String = ""
    static var propertyDesc: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let property = property{
            
            PropertyName.text = property.name
            PropertyDesc.text = property.desc
            PropertyAddress.text = property.address
            OwnerContact.text = property.contact
            PropertyUniversity.text = property.universityName
            PropertyDetailViewController.propertyAdd = property.address
            PropertyDetailViewController.propertyName = property.name
            PropertyDetailViewController.propertyDesc = property.desc
            let imageUrl = URL(string: property.imageURL)
            if imageUrl != nil{
                let imageData = try! Data(contentsOf: imageUrl!)
                PropertyImage1.image = UIImage(data: imageData)
            }
        }
    }
    
}
