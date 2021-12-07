//
//  GeoDataViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 24.11.2021.
//

import UIKit
import CoreLocation

protocol GeoDataViewControllerDelegate {
    func sendGeoposition(geo: String)
}

class GeoDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var delegate: GeoDataViewControllerDelegate? = nil
    
    @IBOutlet weak var getGeopositionButton: UIBarButtonItem!
    
    var locManager = CLLocationManager()
    
    var geoposition: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locManager.desiredAccuracy = kCLLocationAccuracyBest //battery
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
    }
    
    override func didMove(toParent: UIViewController?) {
        if (self.delegate != nil) && (parent == nil) {
            self.delegate!.sendGeoposition(geo: geoposition!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            geoposition = "\(location.coordinate.latitude), \(location.coordinate.longitude)"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    @IBAction func getGeopositionButtonTapped(_ sender: Any) {
        locManager.startUpdatingLocation()
        if let _ = geoposition {
            getGeopositionButton.image = .none
            getGeopositionButton.title = "Done"
        }
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
