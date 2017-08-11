//
//  MapViewController.swift
//  Contacts
//
//  Created by Michael Rose on 8/11/17.
//  Copyright © 2017 Mike Rose. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var zipCode: String!
    var mapView: MKMapView!
    
    required init(zipCode: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.zipCode = zipCode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibNameOrNil:, nibBundleOrNil:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Zip Code"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didDone))
        
        view.backgroundColor = UIColor.white
        
        // Map view
        mapView = MKMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        // Get location from zip code
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(zipCode) { (placemarks, error) in
            if placemarks != nil {
                let placemark = placemarks!.first!
                let mapMark = MKPlacemark(placemark: placemark)
                
                let span = MKCoordinateSpanMake(0.5, 0.5)
                let region = MKCoordinateRegionMake(placemark.location!.coordinate, span)
                
                self.mapView.setRegion(region, animated: false)
                self.mapView.addAnnotation(mapMark)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private
    
    func didDone() {
        dismiss(animated: true, completion: nil)
    }

}
