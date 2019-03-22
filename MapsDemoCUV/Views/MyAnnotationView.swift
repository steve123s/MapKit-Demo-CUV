//
//  MyAnnotationView.swift
//  MapsDemoCUV
//
//  Created by Daniel Esteban Salinas Suárez on 3/22/19.
//  Copyright © 2019 Urbvan. All rights reserved.
//

import Foundation
import MapKit


class MyAnnotationView: MKAnnotationView {
    
    //------------------------------------
    // MARK: - Properties
    //------------------------------------
    
    
    //------------------------------------
    // MARK: - Initializers
    //------------------------------------
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
    }
    
}
