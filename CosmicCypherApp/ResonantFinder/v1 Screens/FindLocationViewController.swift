//
//  FindLocationViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 10/8/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import UIKit
import MapKit
import SwiftAA

protocol FindLocationViewControllerDelegate {
    func setCoordsFromFindLocation(title:String, coords:CLLocationCoordinate2D)
}

class FindLocationViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearch.Request!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearch.Response!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var delegate:FindLocationViewControllerDelegate? = nil
    
    static func presentModally(over presentingViewController: UIViewController, delegate:FindLocationViewControllerDelegate) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FindLocationViewController") as? FindLocationViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            vc.delegate = delegate
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancelButtonTap(_ sender: UIButton) {
        self.dismiss(animated: true) {
            // Dismissed
        }
    }
    
    @IBAction func selectButtonTap(_ sender: UIButton) {
        // Set Lat Long and Location Title to Main Screen
        
        // Lat Long
        let location = CLLocation(latitude: pointAnnotation.coordinate.latitude, longitude: -pointAnnotation.coordinate.longitude)
        let coords = GeographicCoordinates(location)
        //GeoMagScanner.shared.grid.centralCoords = coords
        
        // Title
        let title = searchBar.text ?? "Automatic Coordinates"
        
        self.dismiss(animated: true) {
            // Dismissed
            self.delegate?.setCoordsFromFindLocation(title: title, coords: location.coordinate)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //1
        searchBar.resignFirstResponder()
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }

}
