//
//  ViewController.swift
//  MapsDemoCUV
//
//  Created by Daniel Esteban Salinas Suárez on 3/22/19.
//  Copyright © 2019 Urbvan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //------------------------------------
    // MARK: - IBOutlets
    //------------------------------------

    @IBOutlet weak var mapView: MKMapView!
    
    //------------------------------------
    // MARK: - Properties
    //------------------------------------
    
    let locationManager = CLLocationManager()
    var annotations = [PointReferenceAnnotation]()
    
    //------------------------------------
    // MARK: - VC Lifecycle Methods
    //------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsScale = true
        
        locationManager.delegate = self
        
        // Check for Location Services
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
        }
        
        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation,
                                                latitudinalMeters: 5000, longitudinalMeters: 5000)
            mapView.setRegion(viewRegion, animated: false)
        }
        
        // Long Press GestureRecognizer
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(addPoint(gestureRecognizer:)))
        mapView.addGestureRecognizer(tapGesture)
        
    }
    
    
    //------------------------------------
    // MARK: - Private Methods
    //------------------------------------
    
    @objc private func addPoint(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinates = mapView.convert(touchPoint,
                                          toCoordinateFrom: mapView)
        let annotation = PointReferenceAnnotation(title: String(annotations.count),
                                                  coordinate: coordinates)
        annotations.insert(annotation, at: annotations.count)
        mapView.addAnnotation(annotation)
    }
    
    //------------------------------------
    // MARK: - Route Painting
    //------------------------------------
    
    public func calculateRoutesIn(_ annotations: [PointReferenceAnnotation]) {
        let points = annotations.map { $0.coordinate }
        
        var routes = [MKRoute]()
        
        let routeGroup = DispatchGroup()
        for (index,point) in points.enumerated() {
            guard index < points.count-1 else { continue }
            routeGroup.enter()
            self.showRouteOnMap(fromCoordinate: point, toCoordinate: points[index+1], completionHandler: { (route) in
                routes.append(route)
                routeGroup.leave()
            })
        }
        routeGroup.notify(queue: .main) { [weak self] in
            self?.paintRouteForArray(routes)
        }
    }
    
    private func showRouteOnMap(fromCoordinate: CLLocationCoordinate2D, toCoordinate: CLLocationCoordinate2D, completionHandler: @escaping (MKRoute) -> Void) {
        
        let sourcePlacemark = MKPlacemark(coordinate: fromCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: toCoordinate, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            completionHandler(route)
        }
    }
    
    private func paintRouteForArray(_ routes: [MKRoute]) {
        for route in routes {
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            let rectangularRegion = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rectangularRegion), animated: true)
        }
        
    }
    
    //------------------------------------
    // MARK: - IBActions
    //------------------------------------
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        calculateRoutesIn(annotations)
    }
    

}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: CGFloat.random(in: 0...1),
                                       green: CGFloat.random(in: 0...1),
                                       blue: CGFloat.random(in: 0...1),
                                       alpha: 1.0)
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return MyAnnotationView(annotation: annotation, reuseIdentifier: "ISS")
    }
    
    
}

