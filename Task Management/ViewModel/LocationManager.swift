//
//  LocationManager.swift
//  Task Management
//
//  Created by MAC on 08/03/25.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var latestLocation: CLLocation?
    
    weak var locationDelegate: LocationDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 0
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        latestLocation = locations.sorted { $0.horizontalAccuracy < $1.horizontalAccuracy }.first
        locationDelegate?.currentLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            start()
            break
        case .authorized:
            start()
            break
        @unknown default:
            break
        }
    }
}

protocol LocationDelegate: AnyObject{
    func currentLocation()
}
