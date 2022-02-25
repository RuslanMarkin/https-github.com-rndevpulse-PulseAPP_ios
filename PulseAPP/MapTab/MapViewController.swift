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
    
    var showAttachButton: Bool?
    var locationManager: CLLocationManager!
    var mapCenter: CLLocationCoordinate2D?
    var mapCenterString: String?
    var latDelta: CLLocationDegrees?
    var longDelta: CLLocationDegrees?
    var geoposition: String?
    let rostovGeoString = "47.225624, 39.717085"
    let colors = [UIColor.blue, UIColor.magenta, UIColor.green, UIColor.yellow, UIColor.brown] //colors for annotations on map
    
    @IBOutlet var mapView: MKMapView!
    
    private func registerAnnotationViewClasses() {
        mapView.register(MapPointAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier
        )
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
        case 0..<1.88:
            prefix = 4
        case 1.88..<9.88:
            prefix = 3
        case 9.88..<15:
            prefix = 2
        case 15..<140:
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
         if annotation is ClusterAnnotationView {
             return nil
         }
         //print(String(annotation.pulse ?? 0))
         
       guard let annotation = annotation as? MarkerAnnotation else { return nil }
        let pAnn = MapPointAnnotationView(annotation: annotation as! MKAnnotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    
         return pAnn
//         var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation)
//         pinView = MapPinView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//         return pinView

     }
     
     
     
     
     
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.mapView.removeAnnotations(mapView.annotations)
        //self.mapCenter = mapView.centerCoordinate
        //if let mapCenter = self.mapCenter {
          //  self.mapCenterString = "\(mapCenter.latitude), \(mapCenter.longitude)"
        // }
        self.latDelta = mapView.region.span.latitudeDelta
        self.longDelta = mapView.region.span.longitudeDelta
        
        //print("Span degrees: Lat - : \(self.latDelta), Lon - : \(self.longDelta)")
        
        let prefix = regionSpanToServerPre(latDelta: latDelta!)
        print(prefix)
        
        //if let mapCenterString = mapCenterString {
            MarkerAPIController.shared.getMarkers(Lat: mapView.centerCoordinate.latitude, Lon: mapView.centerCoordinate.longitude, precision: prefix) { result in
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
        //}
    }
     
     
    func setMarkersOnMap(points: [MarkerPoint]) {
        //All code below is needed to display annotations on map with different colors (typeId for markerPoint = UIColor).
        
//
//        let dic = Dictionary(grouping: points, by: {$0.typeName}) //Grouping [MarkerPoint]. Result is dictionary [<typeId> : [MarkerPoint]]
//        var i = 0
//
//        let names = Array(dic.keys) //Creating only typeIds array
//        let sortedNames = names.sorted { $0! < $1! } //Sorting typeIds array in ascending way
//
//        var colorsForMarkersOnMap: [String: UIColor] = [:] //Preparing dictionary for [typeId: UIColor]
//        sortedNames.forEach { n in
//            if let n = n {
//                colorsForMarkersOnMap[n] = colors[i]
//                i += 1
//            }
//        }
//
//        //Having [typeId: UIColor] dictionary we initialize MarkerAnnotation instance with proper color
//        dic.forEach { (key: String?, value: [MarkerPoint]) in
//            value.forEach { marker in
//                if let key = key {
//                    let coordinate = CLLocationCoordinate2D(latitude: marker.latLon?.first ?? 0.0, longitude: marker.latLon?.last ?? 0.0)
//                    let pin = MarkerAnnotation(color: colorsForMarkersOnMap[key] ?? UIColor.red, pulse: marker.pulse ?? 0, coordinate: coordinate)
//                    self.mapView.addAnnotation(pin)
//                }
//            }
//        }
        points.forEach { point in
            
            let coordinate = CLLocationCoordinate2D(latitude: point.latLon?.first ?? 0.0, longitude: point.latLon?.last ?? 0.0)
            let pin = MarkerAnnotation(color: UIColor.yellow, pulse: point.pulse ?? 0, typeName: point.typeName, coordinate: coordinate)
            self.mapView.addAnnotation(pin)
        }
     
    }
     
     
          
        func drawRatio(_ fraction: Int, to whole: Int, fractionColor: UIColor?, wholeColor: UIColor?) -> UIImage {
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
                  let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                                     NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
                  let text = "\(whole)"
                  let size = text.size(withAttributes: attributes)
                  let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
                  text.draw(in: rect, withAttributes: attributes)
              }
          }
          
          func sortWithKeys(_ dict: [String?: [MarkerPoint]]) -> [String?: [MarkerPoint]] {
              let sorted = dict.sorted(by: { $0.key! < $1.key! })
              var newDict: [String?: [MarkerPoint]] = [:]
              for sortedDict in sorted {
                  newDict[sortedDict.key] = sortedDict.value
              }
              return newDict
          }
 }
 
