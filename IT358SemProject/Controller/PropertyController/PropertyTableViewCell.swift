//
//  PropertyTableViewCell.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 3/14/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import UIKit

class PropertyTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var PropertyImage: UIImageView!
    @IBOutlet weak var PropertyName: UILabel!
    @IBOutlet weak var PropertyAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        PropertyName.font = UIFont(name: Theme.mainFontName, size: 20)
        PropertyAddress.font = UIFont(name: Theme.mainFontName, size: 20)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
