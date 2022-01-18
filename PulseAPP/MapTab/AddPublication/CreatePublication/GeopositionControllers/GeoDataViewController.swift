//
//  GeoDataViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 24.11.2021.
//

import UIKit
import MapKit
import CoreLocation
//import AVFAudio
//import simd

protocol GeoDataViewControllerDelegate {
    func sendGeoposition(geo: String)
    
    func sendAttachedToInfo(id: String, typeId: String)
    
    func sendGeoPointName(name: String)
}

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark, organization: SearchCompletionCustom?, placeName: String?)
}

//Subclassing MKPointAnnotation to show pins of org/events with red color
class EventsAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var pinTintColor: UIColor
    var typeId: String?
    
    init(title: String?, subtitle: String? = nil, coordinate: CLLocationCoordinate2D, pinTintColor: UIColor, typeId: String?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.pinTintColor = pinTintColor
        self.typeId = typeId
    }
}

//class OrgOrEventPins {
//    var id: String?
//    var typeId: String?
//    var name: String?
//    var location: CLLocationCoordinate2D?
//
//    init(id: String?, typeId: String?, name: String, location: CLLocationCoordinate2D?) {
//        self.id = id
//        self.typeId = typeId
//        self.name = name
//        self.location = location
//    }
//}

class GeoDataViewController: UIViewController {
    
    //Vars from search module---------------------------------------------------------------------------
    var mapView: MKMapView!
    var mapCenter: CLLocationCoordinate2D?
    var mapCenterString: String?
    var latDelta: CLLocationDegrees?
    var longDelta: CLLocationDegrees?
    var locationManager: CLLocationManager!
    var resultSearchController: UISearchController? = nil
    
    var selectedPin: MKPlacemark? = nil
    var selectedPinId: String?
    var selectedPinTypeId: String?
    var selectedAnnotation: EventsAnnotation?
    var visiblePins = [SearchCompletionCustom]()
    //var userLocIsGreen: Bool = false
    
    var showAttachButton: Bool?
    
    var locationSearchTable: LocationSearchTable?
    
    let centerMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "location-arrow-flat")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCenterOnUserLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var publicationType: PublicationType?
    //---------------------------------------------------------------------------------------------------
    
    
    var delegate: GeoDataViewControllerDelegate? = nil
    
    var geoposition: String?
    var matchingItems: [MKMapItem] = []
    
    //@IBOutlet weak var getGeopositionButton: UIBarButtonItem!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoView.isHidden = true
        infoLabel.isHidden = true
        
        configureMapView()
        configureLocationManager()
        //centerMapOnUserLocation()
        self.setMapview()
        
        view.addSubview(centerMapButton)
        centerMapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -124).isActive = true
        centerMapButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        centerMapButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        centerMapButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        centerMapButton.layer.cornerRadius = 50/2
        centerMapButton.alpha = 1
        
        //Setting up searchController
        locationSearchTable = (storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable)
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        //This configures the search bar, and embeds it within the navigation bar.
//        let statusBarHeight = navigationController?.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//        let naviBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()

        searchBar.placeholder = "Search"
//            searchBar.frame = CGRect(x: 0, y: statusBarHeight + naviBarHeight, width: (navigationController?.view.bounds.size.width)!, height: 64)
        searchBar.barStyle = .default
        searchBar.isTranslucent = false
        //view.addSubview(searchBar)
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        //resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        
//        This passes along a handle of the mapView from the main View Controller onto the locationSearchTable.
        locationSearchTable!.mapView = mapView
        locationSearchTable!.handleMapSearchDelegate = self
        locationSearchTable!.publicationType = publicationType
        
        mapView.delegate = self
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            if let geo = geoposition {
                self.delegate?.sendGeoposition(geo: geo)
            }
        }
    }
    
//    override func didMove(toParent parent: UIViewController?) {
//        super.didMove(toParent: parent)
//    }
    
    @objc func handleCenterOnUserLocation() {
        centerMapOnUserLocation()
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
    
    func configureMapView() {
        mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        view.addSubview(mapView)
        let statusBarHeight = navigationController?.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let naviBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        mapView.frame = CGRect(x: 0, y: statusBarHeight+naviBarHeight, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-(statusBarHeight+naviBarHeight+tabBarHeight))
        
        self.latDelta = mapView.region.span.latitudeDelta
        self.longDelta = mapView.region.span.longitudeDelta
        self.mapCenter = mapView.centerCoordinate
        if let mapCenter = self.mapCenter {
            self.mapCenterString = "\(mapCenter.latitude), \(mapCenter.longitude)"
        }
    }
    
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(region, animated: true)
    }
    
    func showAttachedInfo() {
        infoView.backgroundColor = .systemGray
        infoView.layer.cornerRadius = 5
        infoLabel.text = "Publication was attached to selected location"
        infoView.alpha = 1
        infoLabel.alpha = 1
        infoView.isHidden = false
        infoLabel.isHidden = false
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.infoView.alpha = 0
            self.infoLabel.alpha = 0
            self.infoView.backgroundColor = .systemBackground
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

    // MARK: - MKMapViewDelegate
//If visible on device region had changed, cache its current screen center on map
//And remember latDelta and longDelta which corresponds to network request parameter presision
//Fetching json with org/events data to pin them on map
extension GeoDataViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? EventsAnnotation {
                self.geoposition = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
                for point in visiblePins {
                    // Cycle works too much
                    if point.name == annotation.title {
                        self.selectedPinId = point.id
                        self.selectedPinTypeId = point.typeId
                        self.selectedAnnotation = annotation
                    }
                }
        } else {
            if let annotation = view.annotation {
                self.geoposition = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        visiblePins.removeAll()
        self.mapCenter = mapView.centerCoordinate
        if let mapCenter = self.mapCenter {
            self.mapCenterString = "\(mapCenter.latitude), \(mapCenter.longitude)"
        }
        self.latDelta = mapView.region.span.latitudeDelta
        self.longDelta = mapView.region.span.longitudeDelta
//        print(self.latDelta)
//        print(self.longDelta)
        if let geoposition = geoposition {
            if ((self.latDelta! < CLLocationDegrees(0.19)) && (self.longDelta! < CLLocationDegrees(0.19))) {
                MarkerAPIController.shared.getObjectsOrgsEvents(with: self.mapCenterString ?? geoposition, precision: 3, token: AuthUserData.shared.accessToken) {
                    result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let points):
                            if let points = points.points {
                                self.setPinsOnMap(for: points) //Be careful with force-unwrapping
                                for point in points {
//                                    let pointLocation = CLLocationCoordinate2D(latitude: point.geoposition!.first ?? 0.0, longitude: point.geoposition!.last ?? 0.0)
//                                    self.visiblePins.append(SearchCompletionCustom(location: pointLocation, id: point.id!, typeId: point.publicationType!.id!, name: point.name!, subname: point.description!))
                                    self.visiblePins.append(SearchCompletionCustom(point: point))
                                }
                                self.locationSearchTable!.visiblePins = self.visiblePins
                            }
                        case .failure(let error):
                            print(error.title)
                        }
                    }
                }
            } else {
                self.mapView.removeAnnotations(mapView.annotations)
            }
        }
        
        let visRect = mapView.visibleMapRect
        let inRectAnnotations = mapView.annotations(in: visRect)
        for anno: MKAnnotation in mapView.annotations {
            if let anno = anno as? EventsAnnotation {
                 if !(inRectAnnotations.contains(anno)) {
                     mapView.removeAnnotation(anno)
                 }
            }
        }
    }
    
    //Function sets pins fetched from server only if they are in visible area of device screen
    //Check of belonging to rangeLat and rangeLong is responsible for that
    func setPinsOnMap(for points: [MapPoint]) {
        //visiblePins.removeAll()
        if let mapCenter = mapCenter {
            let rangeLat = ((mapCenter.latitude - self.latDelta!)...(mapCenter.latitude + self.latDelta!))
            let rangeLong = ((mapCenter.longitude - self.longDelta!)...(mapCenter.longitude + self.longDelta!))
            for point in points {
                
                    if rangeLat.contains(point.geoposition!.first!) && rangeLong.contains(point.geoposition!.last!) {
                        
                        let coordinate = CLLocationCoordinate2D(latitude: point.geoposition?.first ?? 0.0, longitude: point.geoposition?.last ?? 0.0)
                        let title = point.name
                        let subtitle = point.description
                        let pin = EventsAnnotation(title: title, subtitle: subtitle, coordinate: coordinate, pinTintColor: .red, typeId: point.publicationType?.name)
                        self.mapView.addAnnotation(pin)
                    }
            }
            if let selectedPin = self.selectedPin {
                let locationCoordinate = selectedPin.coordinate
                let pin = EventsAnnotation(title: "Publication attached ✔️", subtitle: "", coordinate: locationCoordinate, pinTintColor: .red, typeId: nil)
                self.mapView.addAnnotation(pin)
                self.selectedAnnotation = pin
                //self.mapView.selectAnnotation(pin, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        } else {
            pinView?.annotation = annotation
        }
        //pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        if let annotation = annotation as? EventsAnnotation {
            //pinView?.pinTintColor = annotation.pinTintColor
            switch annotation.typeId {
            case "PUBLICATIONTYPE.Event":
                pinView?.image = UIImage(named: "event")
            case "PUBLICATIONTYPE.Organization":
                pinView?.image = UIImage(named: "organization")
            case "PUBLICATIONTYPE.MapObject":
                pinView?.image = UIImage(named: "mapObject")
            default:
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            }
        }
        
        pinView?.canShowCallout = true
        if self.showAttachButton! {
            let smallSquare = CGSize(width: 30, height: 30)
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            button.setBackgroundImage(UIImage(named: "car"), for: .normal)
            //button.setTitle("add post to this", for: .normal)
            button.addTarget(self, action: #selector(attach(sender: )), for: .touchUpInside)
            pinView?.leftCalloutAccessoryView = button
        }
        return pinView
    }
        
    @objc func attach(sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            sender.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        let alert = UIAlertController(title: "Attachment", message: "You are about to attach publication to this point", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Attach", style: .default) {
            action in
            if let id = self.selectedPinId, let typeId = self.selectedPinTypeId, let selectedAnno = self.selectedAnnotation, let geo = self.geoposition {
                self.delegate?.sendAttachedToInfo(id: id, typeId: typeId)
                self.delegate?.sendGeoPointName(name: selectedAnno.title ?? "")
                self.delegate?.sendGeoposition(geo: geo)
            }
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
}

    // MARK: - HandleMapSearch
//This extension is for search
//Drops pin to selected item in search
extension GeoDataViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark, organization: SearchCompletionCustom?, placeName: String?){
        
        if let organization = organization, let location = organization.location {
            
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            self.geoposition = "\(location.latitude), \(location.longitude)"
            
            self.selectedPinId = organization.id
            self.selectedPinTypeId = organization.typeId
            
            let alert = UIAlertController(title: "Attachment", message: "You are about to attach publication to this point", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Attach", style: .default) {
                action in
                if let id = self.selectedPinId, let typeId = self.selectedPinTypeId, let geo = self.geoposition {
                    self.delegate?.sendAttachedToInfo(id: id, typeId: typeId)
                    self.delegate?.sendGeoPointName(name: organization.name)
                    self.delegate?.sendGeoposition(geo: geo)
                }
                self.navigationController?.popViewController(animated: true)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            // cache the pin
            selectedPin = placemark
            // clear existing pins
            mapView.removeAnnotations(mapView.annotations)
            resultSearchController?.searchBar.text = ""
            var subtitle: String = ""
            if let city = placemark.locality,
            let state = placemark.administrativeArea {
                subtitle = "\(city) \(state)"
            }
            let annotation = EventsAnnotation(title: placemark.name, subtitle: subtitle, coordinate: placemark.coordinate, pinTintColor: .red, typeId: "")
            
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            self.geoposition = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
            if let placeName = placeName {
                self.delegate?.sendGeoPointName(name: placeName)
            } else {
                self.delegate?.sendGeoPointName(name: placemark.subThoroughfare ?? "")
            }
        }
    }
}


    // MARK: - CLLocationManager
extension GeoDataViewController: CLLocationManagerDelegate, UIGestureRecognizerDelegate {
        
        //User Location
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let userLocation = locations.first {
                manager.stopUpdatingLocation()
                let userCoordinates = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
                
                self.selectedPin = MKPlacemark(coordinate: userCoordinates)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: userCoordinates, span: span)
                mapView.setRegion(region, animated: true)
                
                
                //Wrap the following code into func, because it is used twice
                var subtitle: String?
                let geoCoder = CLGeocoder()
                
                geoCoder.reverseGeocodeLocation(CLLocation(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude)) { [weak self] (placemarks, error) in
                    guard let self = self else { return }
                    if let _ = error {
                        return
                    }
                    guard let placemark = placemarks?.first else {
                        return
                    }
                    
                    let street = placemark.thoroughfare ?? ""
                    let houseNumber = placemark.subThoroughfare ?? ""
                    subtitle = "\(street) \(houseNumber)"
                    
                    DispatchQueue.main.async {
                        self.delegate?.sendGeoPointName(name: subtitle ?? "")
                        //User Location Pin
                        
                        let myPin = EventsAnnotation(title: "Publication attached ✔️", subtitle: "You are here 😃", coordinate: userCoordinates, pinTintColor: .green, typeId: nil)
                        self.selectedAnnotation = myPin
                        //self.mapView.selectAnnotation(myPin, animated: true)
                        self.mapView.addAnnotation(myPin)
                        self.geoposition = "\(userCoordinates.latitude), \(userCoordinates.longitude)"
                        if let geo = self.geoposition {
                            self.delegate?.sendGeoposition(geo: geo)
                        }
                    }
                }
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
    
    func setMapview(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapView.addGestureRecognizer(lpgr)
    }
    
    //MARK: - Long press recongnizer
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
        let touchLocation = gestureReconizer.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation,toCoordinateFrom: mapView)
        self.geoposition = "\(locationCoordinate.latitude), \(locationCoordinate.longitude)"
            self.mapView.removeAnnotations(self.mapView.annotations)
      //      print("Annotation Removed")
        //let locationCoordinates = CLLocationCoordinate2D(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            self.selectedPin = MKPlacemark(coordinate: locationCoordinate)
            print(self.selectedPin)
            
            var subtitle: String?
            let geoCoder = CLGeocoder()
            
            //ReverseGeocode is used to get street name and house number from (lat, long)
            geoCoder.reverseGeocodeLocation(CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)) { [weak self] (placemarks, error) in
               
                guard let self = self else { return }
                if let _ = error {
                    return
                }
                guard let placemark = placemarks?.first else {
                    return
                }
                
                if let country = placemark.country, let administrativeArea = placemark.administrativeArea, let subAdmin = placemark.subAdministrativeArea, let locality = placemark.locality, let subLocal = placemark.subLocality {
                    print("\(country), ---\(administrativeArea), ---\(subAdmin), ---\(locality), ---\(subLocal), ---\n")
                }
                
                if let street = placemark.thoroughfare, let houseNumber = placemark.subThoroughfare {
                    subtitle = "\(street) \(houseNumber)"
                } else {
                    subtitle = "Somewhere"
                }
                
                
                DispatchQueue.main.async {
                    let pin = EventsAnnotation(title: "Publication attached ✔️", subtitle: subtitle ?? "", coordinate: locationCoordinate, pinTintColor: .green, typeId: nil)
                    self.mapView.addAnnotation(pin)
                    self.selectedAnnotation = pin
                    self.mapView.selectAnnotation(pin, animated: true)
                    self.delegate?.sendGeoPointName(name: subtitle ?? "")
                    //self.showAttachedInfo()
                }
            }

            
        return
      }
        if gestureReconizer.state != UIGestureRecognizer.State.began {
        return
      }
    }
}


