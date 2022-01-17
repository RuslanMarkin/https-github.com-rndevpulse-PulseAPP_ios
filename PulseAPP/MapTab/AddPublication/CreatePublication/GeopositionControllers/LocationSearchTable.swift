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

class SearchCompletionCustom {
    var location: CLLocationCoordinate2D?
    var id: String?
    var typeId: String?
    var name: String
    var subname: String
    var mkCompletion: MKLocalSearchCompletion?
    
    init(location: CLLocationCoordinate2D? = nil, id: String? = nil, typeId: String? = nil, mklocal: MKLocalSearchCompletion) {
        self.location = location
        self.id = id
        self.typeId = typeId
        self.name = mklocal.title
        self.subname = mklocal.subtitle
        self.mkCompletion = mklocal
    }
    
    init(point: MapPoint) {
        
        let pointLocation = CLLocationCoordinate2D(latitude: point.geoposition!.first ?? 0.0, longitude: point.geoposition!.last ?? 0.0)
        self.location = pointLocation
        self.id = point.id
        self.typeId = point.publicationType!.id
        self.name = point.name!
        self.subname = point.description!
        self.mkCompletion = nil
    }
}

class LocationSearchTable: UITableViewController {
    
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    private var searchCompleter: MKLocalSearchCompleter?
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    private var currentPlacemark: CLPlacemark?
    
    var completerResults: [SearchCompletionCustom]?
    
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    var visiblePins: [SearchCompletionCustom]?
    var matchingOrgs: [SearchCompletionCustom]?
    //var matchingAddress: OrgOrEventPins?
    var boundingRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    
    private var places: [MKMapItem]? {
        didSet {
            if let mapItem = places?.first {
                handleMapSearchDelegate?.dropPinZoomIn(placemark: mapItem.placemark, organization: nil, placeName: mapItem.name)
                print("mapItem \(String(describing: mapItem.placemark))")
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private var localSearch: MKLocalSearch? {
        willSet {
            // Clear the results and cancel the currently running local search before starting a new search.
            places = nil
            localSearch?.cancel()
        }
    }
    
    var publicationType: PublicationType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let mapView = mapView {
            boundingRegion = MKCoordinateRegion(center: mapView.centerCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startProvidingCompletions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopProvidingCompletions()
    }
    
    private func startProvidingCompletions() {
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter?.delegate = self
        searchCompleter?.resultTypes = .address
        searchCompleter?.region = searchRegion
    }
    
    private func stopProvidingCompletions() {
        searchCompleter = nil
    }
    
//    func parseAddress(selectedItem:MKPlacemark) -> String {
//        // put a space between "4" and "Melrose Place"
//        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
//        // put a comma between street and city/state
//        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
//        // put a space between "Washington" and "DC"
//        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
//        let addressLine = String(
//            format:"%@%@%@%@%@%@%@",
//            // street number
//            selectedItem.subThoroughfare ?? "",
//            firstSpace,
//            // street name
//            selectedItem.thoroughfare ?? "",
//            comma,
//            // city
//            selectedItem.locality ?? "",
//            secondSpace,
//            // state
//            selectedItem.administrativeArea ?? ""
//        )
//        return addressLine
//    }

}

extension LocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let _ = mapView, let searchBarText = searchController.searchBar.text else { return }
        matchingOrgs?.removeAll()
        if let visiblePins = self.visiblePins {
            let pins = visiblePins.filter { $0.name.contains(searchBarText) }
            matchingOrgs = pins
//            for pin in pins {
//                matchingOrgs?.append(SearchCompletionCustom(location: pin.location, id: pin.id, typeId: pin.typeId, name: pin.name, subname: pin.subname))
//            }
        }
        searchCompleter?.queryFragment = searchController.searchBar.text ?? "" //This row forms searchCompletion
        self.tableView.reloadData()
    }
}

extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingOrgs?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        if let selectedItem = matchingOrgs?[indexPath.row] {
            cell.textLabel?.attributedText = NSMutableAttributedString(string: selectedItem.name)
            cell.detailTextLabel?.attributedText = NSMutableAttributedString(string: selectedItem.subname)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let organization = matchingOrgs?[indexPath.row], let location = organization.location {
                let selectedItem = MKPlacemark(coordinate: location)
                handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem, organization: organization, placeName: nil)
            } else {
                if let suggestion = matchingOrgs?[indexPath.row] {
                    //print(suggestion.title)
                    search(for: suggestion)
                }
            }
            dismiss(animated: true, completion: nil)
    }
}

extension LocationSearchTable: MKLocalSearchCompleterDelegate {
    
    /// - Tag: QueryResults
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // As the user types, new completion suggestions are continuously returned to this method.
        // Overwrite the existing results, and then refresh the UI with the new results.
        
        let suggestions = completer.results
        let organizations = suggestions.map({ (suggestion) -> SearchCompletionCustom in
        
            return SearchCompletionCustom(location: nil, id: nil, typeId: nil, mklocal: suggestion)
        })
        matchingOrgs?.append(contentsOf: organizations)
           
        self.tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Handle any errors returned from MKLocalSearchCompleter.
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription). The query fragment is: \"\(completer.queryFragment)\"")
        }
    }
    
    /// - Parameter suggestedCompletion: A search completion provided by `MKLocalSearchCompleter` when tapping on a search completion table row
    private func search(for suggestedCompletion: SearchCompletionCustom) {
        
        let completion = suggestedCompletion.mkCompletion!
        let searchRequest = MKLocalSearch.Request(completion: completion)
        //searchRequest.naturalLanguageQuery = (suggestedCompletion as MKLocalSearchCompletion).subname
        search(using: searchRequest)
    }
    
    /// - Tag: SearchRequest
    private func search(using searchRequest: MKLocalSearch.Request) {
        // Confine the map search area to an area around the user's current location.
        searchRequest.region = boundingRegion
        
        // Include only point of interest results. This excludes results based on address matches.
        searchRequest.resultTypes = .pointOfInterest
        
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { [unowned self] (response, error) in
            guard error == nil else {
                self.displaySearchError(error)
                return
            }
            
            self.places = response?.mapItems
            //print(self.places)
            // Used when setting the map's region in `prepareForSegue`.
            if let updatedRegion = response?.boundingRegion {
                self.boundingRegion = updatedRegion
            }
        }
    }
    
    private func displaySearchError(_ error: Error?) {
        if let error = error as NSError?, let errorString = error.userInfo[NSLocalizedDescriptionKey] as? String {
            let alertController = UIAlertController(title: "Could not find any places.", message: errorString, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
}

