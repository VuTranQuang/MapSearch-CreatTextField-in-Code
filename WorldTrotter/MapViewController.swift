//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by VuTQ10 on 2/25/20.
//  Copyright © 2020 VuTQ10. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var matchingItems: [MKMapItem] = [MKMapItem]()
    let sampleTextField = UITextField()
    override func loadView() {
//         Create a map view
        mapView = MKMapView()
        
        // Set is as *the* view of this view controller
        view = mapView
        
        // Setup SegmentedControl
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        let margins = view.layoutMarginsGuide
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let leadingContraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        topConstraint.isActive = true
        leadingContraint.isActive = true
        trailingConstraint.isActive = true
        

        // Creat TextField for Search
        sampleTextField.placeholder = "Enter text here"
        sampleTextField.font = UIFont.systemFont(ofSize: 15)
        sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.default
        sampleTextField.returnKeyType = UIReturnKeyType.done
        sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        sampleTextField.addTarget(self, action: #selector(textFieldReturn(_:)), for: .editingDidEndOnExit)
        sampleTextField.delegate = self
        sampleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(sampleTextField)
        
        let topText = sampleTextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8)
        let leadText = sampleTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingText = sampleTextField.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        topText.isActive = true
        leadText.isActive = true
        trailingText.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locationManager = CLLocationManager()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Tạo con trỏ trên map tại local
        let location = CLLocationCoordinate2DMake(21.0307043, 105.7826794)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region =  MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annonation = MKPointAnnotation()
        annonation.coordinate = location
        annonation.title = "FPT Duy Tân"
        annonation.subtitle = "Jamnagar"

        mapView.addAnnotation(annonation)
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // tạo điểm con trỏ trên Map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.markerTintColor = UIColor.blue
        }
        return view
    }
    
    // Type of Map
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    // TextField search
    @objc func textFieldReturn(_ sender: UITextField) {
        _ = sender.resignFirstResponder()
        mapView.removeAnnotations(mapView.annotations)
        self.performSearch()
    }

    func performSearch() {
         matchingItems.removeAll()
        let requets = MKLocalSearch.Request()
        requets.naturalLanguageQuery = sampleTextField.text
        requets.region = mapView.region
        
        let search = MKLocalSearch(request: requets)
        search.start(completionHandler: {(response, error) in
            if let results = response {
                if let err = error {
                    print("Error occurred in search: \(err.localizedDescription)")
                } else if results.mapItems.count == 0 {
                    print("No matches found")
                } else {
                    print("Matches found")
                    for item in results.mapItems {
                        print("Name = \(item.name ?? "No match")")
                        print("Phone = \(item.phoneNumber ?? "No match")")
                        
                        self.matchingItems.append(item as MKMapItem)
                        print("Matching items = \(self.matchingItems.count)")
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = item.name
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        })
    }
  
}


