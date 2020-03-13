//
//  Post+MKAnnotation.swift
//  VideoPosts
//
//  Created by Jorge Alvarez on 3/13/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

extension Post: MKAnnotation {
    // NEW
   var title: String? {
       return comment
   }
    
    var coordinate: CLLocationCoordinate2D {
        return currentLocation
    }
}
