import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(_ currentLocation: CLLocation)
    func tracingLocationDidFailWithError( _error: Error)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    
    static let sharedInstane = LocationService()
    var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        }
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.delegate = self
    }
    func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }
    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.currentLocation = location
        delegate?.tracingLocation(currentLocation!)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.tracingLocationDidFailWithError(_error: error)
    }
}
