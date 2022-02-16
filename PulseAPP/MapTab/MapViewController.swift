//
//  MapViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 13.10.2021.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var locationManager: CLLocationManager!
    var mapCenter: CLLocationCoordinate2D?
    var mapCenterString: String?
    var latDelta: CLLocationDegrees?
    var longDelta: CLLocationDegrees?
    var geoposition: String?
    let rostovGeoString = "47.225624, 39.717085"
    
    @IBOutlet var mapView: MKMapView!
    
    private func registerAnnotationViewClasses() {
        mapView.register(MapPointAnnotationView.self, forAnnotationViewWithReuseIdentifier: MapPointAnnotationView.ReuseID)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        registerAnnotationViewClasses()
        
        mapView.delegate = self
    }
    
    //Func maps apple api mapview property for span to prefix property for span on server
    func regionSpanToServerPre(latDelta: CLLocationDegrees) -> Int {
        var prefix: Int = 3
        switch latDelta {
        case 0..<2.23:
            prefix = 4
        case 2.23..<11.1:
            prefix = 3
        case 11.1..<19:
            prefix = 2
        case 19..<140:
            prefix = 1
        default:
            prefix = 4
        }
        return prefix
    }
    
    @IBAction func addPublicationTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddPublicationSegue", sender: nil)
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //battery
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
        
    }

}

extension MapViewController: CLLocationManagerDelegate {
    
    //Setting region on user's current geoposition
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first {
            manager.stopUpdatingLocation()
            let userCoordinates = CLLocationCoordinate2D(latitude: manager.location?.coordinate.latitude ?? 47.225624, longitude: manager.location?.coordinate.longitude ?? 39.717085) //Using user's coordinates to zoom in or center of Rostov-on-Don
            
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: userCoordinates, span: span)
            mapView.setRegion(region, animated: true)
            
            let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
                mkAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)

                mapView.addAnnotation(mkAnnotation)
            
            self.geoposition = "\(userCoordinates.latitude), \(userCoordinates.longitude)"
        }
    }
    
    //Requesting Location Authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            return
        case .authorizedWhenInUse:
            return
        case .denied:
            return
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

 extension MapViewController: MKMapViewDelegate {
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         if annotation is MKUserLocation {
             return nil
         }
         
         //let annotationView: MKAnnotationView?
         
         guard let annotation = annotation as? MarkerAnnotation else { return nil }
         
         //annotationView = setupMarkerAnnotationView(for: annotation, on: mapView)
         
         return MapPointAnnotationView(annotation: annotation, reuseIdentifier: MapPointAnnotationView.ReuseID)
     }
     
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapCenter = mapView.centerCoordinate
        if let mapCenter = self.mapCenter {
            self.mapCenterString = "\(mapCenter.latitude), \(mapCenter.longitude)"
        }
        self.latDelta = mapView.region.span.latitudeDelta
        self.longDelta = mapView.region.span.longitudeDelta
        
        //print("Span degrees: Lat - : \(self.latDelta), Lon - : \(self.longDelta)")
        
        let prefix = regionSpanToServerPre(latDelta: latDelta!)
        print(prefix)
        
        if let mapCenterString = mapCenterString {
            MarkerAPIController.shared.getMarkers(with: mapCenterString, precision: prefix) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let markerPoints):
                        if let markerPoints = markerPoints.points {
                            self.setMarkersOnMap(points: markerPoints)
                        }
                    case .failure(let error):
                        print(error.title)
                    }
                }
            }
        }
    }

     
    func setMarkersOnMap(points: [MarkerPoint]) {
        for marker in points {
            let coordinate = CLLocationCoordinate2D(latitude: marker.latLon?.first ?? 0.0, longitude: marker.latLon?.last ?? 0.0)
            let pin = MarkerAnnotation(pulse: marker.pulse ?? 0, coordinate: coordinate)
            //EventsAnnotation(title: nil, subtitle: nil, coordinate: coordinate, pinTintColor: .red, typeId: String(marker.pulse ?? 0))
            self.mapView.addAnnotation(pin)
        }
    }
     
     private func setupMarkerAnnotationView(for annotation: MarkerAnnotation, on mapView: MKMapView) -> MKAnnotationView {
         let reuseIdentifier = NSStringFromClass(MarkerAnnotation.self)
         let flagAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation)
         
         //flagAnnotationView.canShowCallout = true
         
         // Provide the annotation view's image.
         let image = drawRatio(0, to: annotation.pulse, fractionColor: nil, wholeColor: .red)
         flagAnnotationView.image = image
         
         // Provide the left image icon for the annotation.
//         flagAnnotationView.leftCalloutAccessoryView = UIImageView(image: #imageLiteral(resourceName: "sf_icon"))
         
         // Offset the flag annotation so that the flag pole rests on the map coordinate.
         let offset = CGPoint(x: image.size.width / 2, y: -(image.size.height / 2) )
         flagAnnotationView.centerOffset = offset
         
         return flagAnnotationView
     }
     
     private func drawRatio(_ fraction: Int, to whole: Int, fractionColor: UIColor?, wholeColor: UIColor?) -> UIImage {
         let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
         return renderer.image { _ in
             // Fill full circle with wholeColor
             wholeColor?.setFill()
             UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()

             // Fill pie with fractionColor
             fractionColor?.setFill()
             let piePath = UIBezierPath()
             piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                            startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(fraction)) / CGFloat(whole),
                            clockwise: true)
             piePath.addLine(to: CGPoint(x: 20, y: 20))
             piePath.close()
             piePath.fill()

             // Fill inner circle with white color
             UIColor.white.setFill()
             UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24)).fill()

             // Finally draw count text vertically and horizontally centered
             let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
             let text = "\(whole)"
             let size = text.size(withAttributes: attributes)
             let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
             text.draw(in: rect, withAttributes: attributes)
         }
     }
 }
