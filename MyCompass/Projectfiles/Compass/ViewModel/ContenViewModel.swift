//
//  CompassViewModel.swift
//  Sensors
//
//  Created by Andreas Kluge on 09.11.23.
//

import Foundation
import CoreLocation
import CoreMotion

class ContenViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager: CLLocationManager
    @Published var authorizationStatus: CLAuthorizationStatus
        
    private var motionManager: CMMotionManager!
    
    @Published var longitude: Double    = 0.0
    @Published var latitude: Double     = 0.0
    @Published var altitude: Double     = 0.0
    @Published var longitudeText: String    = ""
    @Published var latitudeText: String     = ""
    
    @Published var city: String             = "Palo Alto"
    @Published var state: String            = "California"
    @Published var country: String          = "United States of America"
    @Published var address: String          = "Infinite Loop 1"
    
    
    @Published var speed: Double        = 0.0
    @Published var course: Double       = 0.0
    
    @Published var headingDM: Double    = 0.0
    @Published var headingText: String  = "NW"
    
    
    @Published var trimX: Double        = 0.0
    @Published var trimY: Double        = 0.0
    
    override init(){
        //print ("init ContenViewModel")
        //Location
        locationManager                 = CLLocationManager()
        authorizationStatus             = locationManager.authorizationStatus
        super.init()
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate        = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        //Motion
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { data, error in
            //print(data)
            self.trimX  = data?.acceleration.x ?? 0.0
            self.trimY  = data?.acceleration.y ?? 0.0
            
            self.trimX  = self.trimX*30 * -1
            self.trimY  = self.trimY*30
            
            
        }
        
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical,to: OperationQueue.main) { data, error in
            //print("\(data)")
            self.headingDM  = data?.heading ?? 0.0
            self.headingDM  = self.headingDM * -1
        }
        
    }
    
    deinit{
        

        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()

        
        if(motionManager != nil){
            motionManager.stopAccelerometerUpdates()
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]  ) {
        //print("didUpdateLocations")
        
        // Handle location update
        if let location = locations.first {
            latitude        = location.coordinate.latitude
            longitude       = location.coordinate.longitude
            altitude        = location.altitude
            speed           = location.speed
            course          = location.course
            
            latitudeText    = self.getLocationDegreesFrom(latitude: latitude)
            longitudeText   = self.getLocationDegreesFrom(longitude: longitude)
            
            let geoCoder:CLGeocoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude), completionHandler: { (places, error) in
                if error == nil {
                  //self.placemark = places?[0]
                    let placemark: CLPlacemark  = (places?[0])!
                    //self.address                = placemark.postalAddress
                    self.city                       = placemark.locality ?? ""
                    self.address                    = "\(placemark.thoroughfare ?? "") \(placemark.subThoroughfare ?? "")"
                    self.state                      = placemark.administrativeArea ?? ""
                    
                } else {
                  //self.placemark = nil
                }
              })
            
            
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //print("didUpdateHeading trueHeading: \(newHeading.trueHeading) magneticHeading: \(newHeading.magneticHeading)")
        //self.heading = -1.0 * newHeading.magneticHeading
        //print("Heading Float: \(self.heading)")
        //print ( "\((Int)(newHeading.magneticHeading))")
        
        switch (Int)(newHeading.magneticHeading){
        case 340...360:
            self.headingText = "N"
        case 0...20:
            self.headingText = "N"
        case 20...70:
            self.headingText = "NE"
        case 70...110:
            self.headingText = "E"
        case 110...160:
            self.headingText = "SE"
        case 160...200:
            self.headingText = "S"
        case 200...250:
            self.headingText = "SW"
        case 250...290:
            self.headingText = "W"
        case 290...340:
            self.headingText = "NW"
        default:
            self.headingText = "X"
        }
    
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("didFailWithError error: \(error)")
        // Handle failure to get a user’s location
    }
    
    
    
    func getLocationDegreesFrom(latitude: Double) -> String {

        var latSeconds = Int(latitude * 3600)

        let latDegrees = latSeconds / 3600

        latSeconds = abs(latSeconds % 3600)

        let latMinutes = latSeconds / 60

        latSeconds %= 60

        return String(

            format: "%d°%d'%d\" %@",
            abs(latDegrees),
            latMinutes,
            latSeconds,
            latDegrees >= 0 ? "N" : "S"

        )

    }

    func getLocationDegreesFrom(longitude: Double) -> String {

        var longSeconds = Int(longitude * 3600)

        let longDegrees = longSeconds / 3600

        longSeconds = abs(longSeconds % 3600)

        let longMinutes = longSeconds / 60

        longSeconds %= 60

        return String(

            format: "%d°%d'%d\" %@",
            abs(longDegrees),
            longMinutes,
            longSeconds,
            longDegrees >= 0 ? "E" : "W"

        )

    }
    
}
/*extension CLLocation {
    var dms: String { latitude + " " + longitude }
    var latitude: String {
        let (degrees, minutes, seconds) = coordinate.latitude.dms
        return String(format: "%d°%d'%d\"%@", abs(degrees), minutes, seconds, degrees >= 0 ? "N" : "S")
    }
    var longitude: String {
        let (degrees, minutes, seconds) = coordinate.longitude.dms
        return String(format: "%d°%d'%d\"%@", abs(degrees), minutes, seconds, degrees >= 0 ? "E" : "W")
    }
}
*/
