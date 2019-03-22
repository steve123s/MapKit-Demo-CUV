//
//  PointReferenceAnnotation.swift
//  MapsDemoCUV
//
//  Created by Daniel Esteban Salinas Suárez on 3/22/19.
//  Copyright © 2019 Urbvan. All rights reserved.
//

import Foundation
import MapKit

class PointReferenceAnnotation: NSObject, MKAnnotation {
    
    //------------------------------------
    // MARK: - Properties
    //------------------------------------
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    //------------------------------------
    // MARK: - Initializers
    //------------------------------------
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
}
