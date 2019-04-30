//
//  UserTableViewCell.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 3/20/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    
    //MARK: Properties
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userUniversity: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
