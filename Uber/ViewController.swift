//
//  ViewController.swift
//  Uber
//
//  Created by shubham Garg on 21/07/20.
//  Copyright © 2020 shubham Garg. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController {
    @IBOutlet weak var mapKitView: MKMapView!
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        self.trackPermissionStatus()
      
    }
    
    
    func trackPermissionStatus(){
        let locStatus = CLLocationManager.authorizationStatus()
        switch locStatus {
             case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
             return
             case .denied, .restricted:
                let alert = UIAlertController(title: "Location Services are disabled", message: "Please enable Location Services in your Settings", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
             return
             case .authorizedAlways, .authorizedWhenInUse:
                if CLLocationManager.locationServicesEnabled() {
                          locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                          locationManager.startUpdatingLocation()
                      }
             break
          }
    }


}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if let location = locations.last{
               let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
               let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
            let anno = MKPointAnnotation();
            anno.coordinate = center;
            mapKitView.addAnnotation(anno);
               self.mapKitView.setRegion(region, animated: true)
//            locationManager.stopUpdatingLocation()
           }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
               switch status {
             case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
             return
             case .denied, .restricted:
                let alert = UIAlertController(title: "Location Services are disabled", message: "Please enable Location Services in your Settings", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
             return
             case .authorizedAlways, .authorizedWhenInUse:
                if CLLocationManager.locationServicesEnabled() {
                          locationManager.delegate = self
                          locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                          locationManager.startUpdatingLocation()
                      }
             break
          }
    }
}
