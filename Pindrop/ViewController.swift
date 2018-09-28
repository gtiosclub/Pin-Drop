//
//  ViewController.swift
//  Pindrop
//
//  Created by Will Said on 9/26/18.
//  Copyright © 2018 Will Said. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    
    var pins: [Pin] = []
    
    
    // MARK: - IB OUTLETS
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self.mapView)
        let coordinate = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        addPin(at: coordinate)
    }
    
    
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        loadPins()
    }
    
    
    
    // MARK: - HELPER FUNCTIONS
    
    func addPin(at coordinate: CLLocationCoordinate2D) {
        let alert = UIAlertController(title: "New Pin", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Name"
        }
        alert.addTextField { textField in
            textField.placeholder = "Caption"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in    // void closure
            guard let textFields = alert.textFields else { return }
            let name = textFields[0].text ?? ""  // nil coalescing operator
            let description = textFields[1].text ?? ""

            // structs and classes: show first few slides. construct the Pin yourself.
            let pin = Pin(name: name, description: description, latitude: coordinate.latitude, longitude: coordinate.longitude)

            // "Self." inside closure
            self.add(pin: pin)
            self.mapView.addAnnotation(pin) // Pin needs to be a class to conform to MKAnnotation
        }
        
        alert.addAction(saveAction)
        
        self.present(alert, animated: true)
    }
    
    
    func add(pin: Pin) {
        self.pins.append(pin)
        Pin.save(pins: self.pins)
    }
    
    
    func loadPins() {
        if let pins = Pin.loadPins() {
            self.pins = pins
            self.mapView.addAnnotations(pins)
        }
    }
}


// MARK: - MKMAPVIEWDELEGATE
extension ViewController: MKMapViewDelegate {
    // compare to table view delegation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            annotationView.annotation = annotation
            return annotationView
        }
        
        return nil
    }
}

