//
//  LocationManager.swift
//  DailyDigest
//
//  Created by Rishik Dev on 12/04/23.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var country: String?
    
    private let clLocationManager = CLLocationManager()
    private var location: CLLocation?
    
    override init() {
        super.init()
        clLocationManager.delegate = self
        clLocationManager.requestWhenInUseAuthorization()
        clLocationManager.desiredAccuracy = kCLLocationAccuracyReduced
        clLocationManager.startUpdatingLocation()
    }
    
    func requestLocation() {
        clLocationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: \(error.localizedDescription)")
        clLocationManager.stopUpdatingLocation()
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.clLocationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation) { [weak self] (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    self?.country = firstLocation?.country
                    completionHandler(firstLocation)
                }
                else {
                    // An error occurred during geocoding.
                    completionHandler(nil)
                }
            }
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
}
