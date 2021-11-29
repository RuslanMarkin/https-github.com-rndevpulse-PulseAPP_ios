//
//  MapViewController.swift
//  PulseAPP
//
//  Created by Алексей Поддубный on 13.10.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
