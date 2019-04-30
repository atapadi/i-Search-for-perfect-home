//
//  HomeTableViewController.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 3/12/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import os.log
import FirebaseDatabase

class HomeTableViewController: UITableViewController, UISearchResultsUpdating {

    //MARK: Properties
    
    var temp = [Properties]()
    var properties : [NSManagedObjectContext] = []
    var tempImage = [PropertyImages]()
    var count = 0
    var filteredProperties = [Properties]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var databaseHandle: DatabaseHandle?
    var databaseQuery: DatabaseQuery?
    var ref: DatabaseReference?
    
    
    override func viewDidLoad() {
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter University"
        tableView.tableHeaderView = searchController.searchBar
        super.viewDidLoad()
        
        filteredProperties = temp
        ref = Database.database().reference()
        
        loadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        super.prepare(for: segue, sender: sender)
    
        switch(segue.identifier ?? "") {
            
        case "AddProperty":
            os_log("Adding a new property.", log: OSLog.default, type: .debug)
            
        case "ShowPropertyDetail":
            guard let propertyDetailViewController = segue.destination as? PropertyDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedPropertyCell = sender as? PropertyTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedPropertyCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedProperty = temp[indexPath.row]
            propertyDetailViewController.property = selectedProperty
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
        }
    }
    
    //MARK: Actions
    
    @IBAction func logOutAction(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    
    @IBAction func unwindToPropertyList(sender: UIStoryboardSegue) {
       // temp.removeAll()
       // loadData()
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering() {
            return filteredProperties.count
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

        let cellIdentifier = "PropertyTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PropertyTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PropertyTableViewCell.")
        }
        // Fetches the appropriate meal for the data source layout.
        let prop: Properties
        if isFiltering() {
            prop = filteredProperties[indexPath.row]
        } else {
            prop = temp[indexPath.row]
        }
        
        cell.PropertyName.text = prop.name
        cell.PropertyAddress.text = prop.address
        
        let imageUrl = URL(string: prop.imageURL)
        if imageUrl != nil{
            let imageData = try! Data(contentsOf: imageUrl!)
            cell.PropertyImage.image = UIImage(data: imageData)
        }
        return cell
    }

    
    //MARK: Private functions
    
    func loadData() {
        
            databaseHandle = ref?.child("Properties").observe(.childAdded, with: {(snapshot) in
                //let count = snapshot.childrenCount
                
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var newProperty = Properties(name: "", contact: "", address: "", universityName: "", desc: "", imageURL : "")
                
                newProperty.name = dictionary["PropertyName"] as? String ?? ""
                
                newProperty.address = dictionary["PropertyAddress"] as? String ?? ""
                
                newProperty.desc = dictionary["PropertyDesc"] as? String ?? ""
                
                newProperty.universityName = dictionary["PropertyUniversity"] as? String ?? ""
                
                newProperty.contact = dictionary["OwnerContact"] as? String ?? ""
                
                newProperty.imageURL = dictionary["PropertyImageUrl"] as? String ?? ""
            
                self.temp.append(newProperty)
                
                DispatchQueue.main.async { [weak self] in
                    //if(((self?.temp.count)! + 1) > Int(count)){
                    //    self?.temp.removeLast()
                    //}
                    self?.tableView.reloadData()
                }
            }
            })
    }
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredProperties = temp.filter({( prop : Properties) -> Bool in
            let bool = prop.universityName.lowercased().contains(searchText.lowercased())
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
