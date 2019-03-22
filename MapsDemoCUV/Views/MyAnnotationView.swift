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
    
    // Space station imageView
    let pinImageView = UIImageView(frame: CGRect(x: -15, y: -15, width: 30, height: 30))
    
    //------------------------------------
    // MARK: - Initializers
    //------------------------------------
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        // Make annotationView display default bubble with title and description. Previously was ignoring them.
        self.canShowCallout = true
        pinImageView.image = UIImage(named: "space-station")
        pinImageView.contentMode = .scaleAspectFit
        
        // titleLabel view
        let pinTitleLabel = UILabel(frame: CGRect(x: -15, y: 15, width: 30, height: 20))
        pinTitleLabel.text = annotation?.title ?? ""
        pinTitleLabel.textAlignment = .center
        
        addSubview(pinImageView)
        addSubview(pinTitleLabel)
    }
    
}
