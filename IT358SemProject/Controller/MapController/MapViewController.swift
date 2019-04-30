//
//  MapViewController.swift
//  IT358SemProject
//
//  Created by Akanksha Tapadia on 4/15/19.
//  Copyright © 2019 Akanksha Tapadia. All rights reserved.
//

import UIKit
import MapKit
//import CoreLocation

class MapViewController: UIViewController {
    
    let regionRadius: CLLocationDistance = 10000 // 1000 meters: a little more than half a mile
    
    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let geocoder = CLGeocoder()
        var lat: CLLocationDegrees?
        var lon: CLLocationDegrees?
        geocoder.geocodeAddressString(PropertyDetailViewController.propertyAdd) {
            (placemarks, error) in
            
            let placemark = placemarks?.first
            lat = placemark?.location?.coordinate.latitude
            lon = placemark?.location?.coordinate.longitude
            //print("Lat: \(String(describing: lat)), Lon: \(String(describing: lon))")
            
            
            let initialLocation = CLLocation(latitude: 40.5123, longitude: -88.9947)
            
            self.centerMapOnLocation(location: initialLocation)
            
            let address = Address(title: PropertyDetailViewController.propertyName,
                                  
                                  locationName: PropertyDetailViewController.propertyAdd,
                                  
                                  discipline: PropertyDetailViewController.propertyDesc,
                                  
                                  coordinate: CLLocationCoordinate2D(latitude: lat ?? 0, longitude: lon ?? 0)
            )
            
            self.mapView.addAnnotation(address)
            
        }
        
        mapView.delegate = self
    }
    
    // location argument is the center point, with north-south and east-west spans for the region
    func centerMapOnLocation(location: CLLocation) {
        
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
}

extension MapViewController: MKMapViewDelegate {
    
    // 1
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // 2
        
        guard let annotation = annotation as? Address else { return nil }
        
        // 3
        
        let identifier = "marker"
        
        var view: MKMarkerAnnotationView
        
        // 4
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            as? MKMarkerAnnotationView {
            
            dequeuedView.annotation = annotation
            
            view = dequeuedView
            
        } else {
            
            // 5
            
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            view.canShowCallout = true
            
            view.calloutOffset = CGPoint(x: -5, y: 5)
            
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }
        
        return view
        
    }
    // tell MapKit what to do when the user taps the callout button
    
    // In this method, you grab the Attraction object that this tap refers to, and then launch the Maps app
    // by creating an associated MKMapItem, and calling openInMaps(launchOptions:) on the map item.
    // Notice you’re passing a dictionary to this method. This allows you to specify a few different options;
    //  here the DirectionModeKey is set to Driving. This causes the Maps app to show driving directions
    // from the user’s current location to this pin. Neat!
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 
                 calloutAccessoryControlTapped control: UIControl) {
        
        let location = view.annotation as! Address
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        location.mapItem().openInMaps(launchOptions: launchOptions)
        
    }
    
}




