//
//  LocationManager.swift
//  GBFitness
//
//  Created by Максим Лосев on 13.12.2022.
//

import Foundation
import CoreLocation
import RxSwift
import RxRelay

class LocationManager: NSObject {
    
    static let instance = LocationManager()
    
    override init() {
        super.init()
        configureLocationManager()
    }
    
    let locationManager = CLLocationManager()
    var location: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
//        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location.accept(locations.last)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
