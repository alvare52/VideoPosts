//
//  MapViewController.swift
//  VideoPosts
//
//  Created by Jorge Alvarez on 3/12/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10_000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        checkLocationServices()
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location,
                                                 latitudinalMeters: regionInMeters,
                                                 longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
            print(currentLocation)
            currentLocation = location
            print(currentLocation)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // setup location manager
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting user know they have to turn this on
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // Blue dot
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation() // fires off didUpdateLocation
            break
        case .denied:
            // Show alert telling user how to turn on permissions
            break
        case .notDetermined:
            // Ask permission (can only ask ONCE)
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Parental Controls, show alert
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    // Whenever user location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude)
        
        let region = MKCoordinateRegion.init(center: center,
                                             latitudinalMeters: regionInMeters,
                                             longitudinalMeters: regionInMeters)
        
        mapView.setRegion(region, animated: true)
    }

    // Fires off when authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

