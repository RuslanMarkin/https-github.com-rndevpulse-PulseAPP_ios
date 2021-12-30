//
//  LocationSearchTable.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 15.12.2021.
//

import Foundation
import UIKit
import MapKit

struct Location {
    let title: String
    let coordinates: CLLocationCoordinate2D
}

class LocationSearchTable: UITableViewController {
    
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var visiblePins: [OrgOrEventPins]?
    var matchingOrgs: [OrgOrEventPins] = []
    var matchingAddresses: [OrgOrEventPins] = []
    var boundingRegion: MKCoordinateRegion?
    
    var publicationType: PublicationType?
    
    var completerResults: [MKLocalSearchCompletion]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let mapView = mapView {
            boundingRegion = MKCoordinateRegion(center: mapView.centerCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        }
        
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }

}

extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let _ = mapView, let searchBarText = searchController.searchBar.text else { return }
        switch publicationType?.name {
        case "PUBLICATIONTYPE.Post":
            if let visiblePins = self.visiblePins {
                self.matchingOrgs = visiblePins.filter { $0.name?.contains(searchBarText) ?? false }
                self.tableView.reloadData()
            }
        default:
            findLocations(with: searchBarText) { [weak self] locations in
                DispatchQueue.main.async {
                    self?.matchingAddresses = locations
                    self?.tableView.reloadData()
                }
            }
            
            
//            Ба
//            request.resultTypes = .address
//            request.naturalLanguageQuery = searchBarText
//            request.region = mapView.region//boundingRegion ?? MKCoordinateRegion(MKMapRect.world)
//            let search = MKLocalSearch(request: request)
//                search.start { response, _ in
//                guard let response = response else {
//                    return
//                }
//                self.matchingItems = response.mapItems
//                self.tableView.reloadData()
//            }
        }
        
            
    }
    
    func findLocations(with query: String, completion: @escaping (([OrgOrEventPins]) -> Void)) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            
            let models: [OrgOrEventPins] = places.compactMap({ place in
                var name = ""
                if let locationName = place.name {
                    name += locationName
                }
                
                if let adminRegion = place.administrativeArea {
                    name += ", \(adminRegion)"
                }
                
                if let locality = place.locality {
                    name += ", \(locality)"
                }
                
                if let country = place.country {
                    name += ", \(country)"
                }
                
                print("\n\(place)\n\n")
                let result = OrgOrEventPins(id: nil, typeId: nil, name: name, location: place.location!.coordinate)
                
                return result
            })
            completion(models)
            
        }
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch publicationType?.name {
        case "PUBLICATIONTYPE.Post":
            return matchingOrgs.count
        default:
            return matchingAddresses.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        switch publicationType?.name {
        case "PUBLICATIONTYPE.Post":
            let selectedItem = matchingOrgs[indexPath.row]
            cell.textLabel?.text = selectedItem.name
            return cell
        default:
            let selectedItem = matchingAddresses[indexPath.row]
            cell.textLabel?.text = selectedItem.name
            //cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch publicationType?.name {
        case "PUBLICATIONTYPE.Post":
            let selectedItem = MKPlacemark(coordinate: matchingOrgs[indexPath.row].location)
            handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem, organization: matchingOrgs[indexPath.row], placeName: nil)
            dismiss(animated: true, completion: nil)
        default:
            let selectedItem = matchingAddresses[indexPath.row]
            let placemark = MKPlacemark(coordinate: selectedItem.location)
            handleMapSearchDelegate?.dropPinZoomIn(placemark: placemark, organization: nil, placeName: selectedItem.name)
            dismiss(animated: true, completion: nil)
        }
    }
}
