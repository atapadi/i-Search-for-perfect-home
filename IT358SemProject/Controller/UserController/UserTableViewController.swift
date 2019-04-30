//
//  UserTableViewController.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 3/20/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import os.log
import FirebaseDatabase

class UserTableViewController: UITableViewController, UISearchResultsUpdating {

    //MARK: Properties
    
    var temp = [User]()
    var persons : [NSManagedObjectContext] = []
    var count = 0
    var filteredUsers = [User]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var databaseHandle: DatabaseHandle?
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        
        // Setup the Search Controller
      
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter University"
        tableView.tableHeaderView = searchController.searchBar
        super.viewDidLoad()
        
        filteredUsers = temp
        ref = Database.database().reference()
        
        self.loadDataUserDetails()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        tableView.reloadData()
//    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "ShowUserDetail":
            guard let userDetailViewController = segue.destination as? UserDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedUserCell = sender as? UserTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedUserCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedUser = temp[indexPath.row]
            userDetailViewController.user = selectedUser
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering() {
            return filteredUsers.count
        }
        return temp.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(90)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "UserTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserTableViewCell  else {
            fatalError("The dequeued cell is not an instance of UserTableViewCell.")
        }
        // Fetches the appropriate meal for the data source layout.
        let user: User
        if isFiltering() {
            user = filteredUsers[indexPath.row]
        } else {
            //temp.removeAll()
            //self.loadDataUserDetails()
            user = temp[indexPath.row]
        }
        
        cell.userName.text = user.name
        cell.userUniversity.text = user.universityName
        
        let imageUrl = URL(string: user.imageURL)
        if imageUrl != nil{
            let imageData = try! Data(contentsOf: imageUrl!)
            cell.userImage.image = UIImage(data: imageData)
        }
        return cell
    }
    
    
    //MARK: Private functions
    
    func loadDataUserDetails() {

        databaseHandle = ref?.child("User").observe(.childAdded, with: {(snapshot1) in
            
            if let dictionary = snapshot1.value as? [String: AnyObject] {
                
                var newUser = User(name: "", contact: "", universityCourse: "", universityName: "", email: "", imageURL:"", address: "", interest: "", status: "")
                
                newUser.name = dictionary["UserName"] as! String
                newUser.contact = dictionary["UserPhNo"] as? String ?? ""
                newUser.universityCourse = dictionary["UserCourse"] as? String ?? ""
                newUser.universityName = dictionary["UserUniversity"] as? String ?? ""
                newUser.email = dictionary["UserEmailID"] as? String ?? ""
                newUser.imageURL = dictionary["PropertyImageUrl"] as? String ?? ""
                newUser.address = dictionary["UserAddress"] as? String ?? ""
                newUser.interest = dictionary["UserInterest"] as? String ?? ""
                newUser.status = dictionary["UserStatus"] as? String ?? ""
                
                self.temp.append(newUser)
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        })
       // tableView.reloadData()
    }

    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredUsers = temp.filter({( user : User) -> Bool in
            let bool = user.universityName.lowercased().contains(searchText.lowercased())
            if bool == true{
                return true
            }
            else{
                return false
            }
            
        })
        
        tableView.reloadData()
    }
    
}
