//
//  MarkerAnnotation.swift
//  PulseAPP
//
//  Created by Михаил Иванов on 16.02.2022.
//

import Foundation
import MapKit

class MarkerAnnotation: NSObject, MKAnnotation {
    
    var pulse: Int = 0
    var color: UIColor = UIColor.red
    
    private var latitude: CLLocationDegrees = 0
    private var longitude: CLLocationDegrees = 0

    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            // For most uses, `coordinate` can be a standard property declaration without the customized getter and setter shown here.
            // The custom getter and setter are needed in this case because of how it loads data from the `Decodable` protocol.
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
    init(color: UIColor, pulse: Int, coordinate: CLLocationCoordinate2D) {
        super.init()
        self.color = color
        self.pulse = pulse
        self.coordinate = coordinate
    }
}
