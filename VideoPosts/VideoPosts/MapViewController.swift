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
    
    var postController = PostController()
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10_000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        mapView.delegate = self
        
        checkLocationServices()
        mapView.register(MKMarkerAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: "PostView")
        print(postController.posts.count)
        mapView.addAnnotations(postController.posts)
        print("\(mapView.annotations)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        print(postController.posts.count)
        mapView.addAnnotations(postController.posts)
        print("\(mapView.annotations)")
//        if let postController = postController {
//            print("postController not nil")
//            if postController.posts.count > 0 {
//                print("posts count: \(postController.posts.count)")
//                mapView.addAnnotations(postController.posts)
//                print(mapView.annotations)
//            }
//        }
    }
    
    // 1
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // setup location manager
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting user know they have to turn this on
            print("Go to your Settings > Privacy > Location Services > turn on")
        }
    }
    
    // 2
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // 3
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // This is where we want to be
            mapView.showsUserLocation = true // Blue dot
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
    
    // 4
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
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let post = annotation as? Post else {
            print("Annotation couldn't be cast as a Post")
            return nil
            //fatalError("Only post options are currently supported")
        }
        
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PostView", for: annotation) as? MKMarkerAnnotationView else {
            fatalError("Missing a registered map annotation view")
        }
        
        
        
        return annotationView
    }
    
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

