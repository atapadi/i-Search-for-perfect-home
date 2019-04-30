//
//  Address.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 4/15/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import MapKit
import Contacts


class Address: NSObject, MKAnnotation {
    
    let title: String?
    
    let locationName: String
    
    let discipline: String
    
    let coordinate: CLLocationCoordinate2D
    
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        
        self.locationName = locationName
        
        self.discipline = discipline
        
        self.coordinate = coordinate
        
        super.init()
        
    }
    
    var subtitle: String? {
        
        return locationName
        
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    // Here you create an MKMapItem from an MKPlacemark.
    // The Maps app is able to read this MKMapItem, and display the right thing.
    
    func mapItem() -> MKMapItem {
        
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = title
        
        return mapItem
        
    }
}


