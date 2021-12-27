//
//  LocationSearchTable.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 15.12.2021.
//

import Foundation
import UIKit
import MapKit

class LocationSearchTable: UITableViewController {
    
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    
    var completerResults: [MKLocalSearchCompletion]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else { return }
        
//        let request = MKLocalSearch.Request()
//        request.region = MKCoordinateRegion(center: currentCoordinate, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
//        request.naturalLanguageQuery = "300 S Pumpkin"

        //let formatter = CNPostalAddressFormatter()
        //formatter.style = .mailingAddress

//        let search = MKLocalSearch(request: request)
//        search.start { response, error in
//            let addresses = response?.mapItems.compactMap { item -> String? in
//                return item.placemark.locality
//            }
//            print(addresses)
//            self.matchingItems = addresses
//            self.tableView.reloadData()
//        }
        
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchBarText
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
                search.start { response, _ in
                guard let response = response else {
                    return
                }
                self.matchingItems = response.mapItems
                self.tableView.reloadData()
            }
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
                let selectedItem = matchingItems[indexPath.row].placemark
                cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}