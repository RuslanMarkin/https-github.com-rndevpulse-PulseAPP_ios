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
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        
        MarkerAPIController.shared.getMarkers(with: "-33.927104071536974,151.0000000521541", precision: 4) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let markerPoints):
                    print(markerPoints)
                case .failure(let error):
                    print(error)
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    class HalfSizePresentationController : UIPresentationController {
        override var frameOfPresentedViewInContainerView: CGRect {
            get {
                guard let theView = containerView else {
                    return CGRect.zero
                }

                return CGRect(x: 0, y: theView.bounds.height/2, width: theView.bounds.width, height: theView.bounds.height/2)
            }
        }
    }
    
    @IBAction func addPublicationTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddPublicationSegue", sender: nil)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let addPublicationController = storyboard.instantiateViewController(withIdentifier: "AddPublicationTypeController") as! AddPublicationViewController
//        self.present(addPublicationController, animated: true, completion: nil)
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

extension MapViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    //Setting region on user's current geoposition
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.first {
            manager.stopUpdatingLocation()
            let userCoordinates = CLLocationCoordinate2D(latitude: manager.location?.coordinate.latitude ?? 47.225624, longitude: manager.location?.coordinate.longitude ?? 39.717085) //Using user's coordinates to zoom in or center of Rosto-on-Don
            
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: userCoordinates, span: span)
            mapView.setRegion(region, animated: true)
            
            let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
                mkAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)

                mapView.addAnnotation(mkAnnotation)
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
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.mapCenter = mapView.centerCoordinate
        if let mapCenter = self.mapCenter {
            self.mapCenterString = "\(mapCenter.latitude), \(mapCenter.longitude)"
        }
        self.latDelta = mapView.region.span.latitudeDelta
        self.longDelta = mapView.region.span.longitudeDelta

            if ((self.latDelta! < CLLocationDegrees(0.19)) && (self.longDelta! < CLLocationDegrees(0.19))) {
                MarkerAPIController.shared.getObjectsOrgsEvents(with: self.mapCenterString ?? geoposition, precision: 3, token: AuthUserData.shared.accessToken) {
                    result in
                    DispatchQueue.main.async {
                        switch result {
    }
}
