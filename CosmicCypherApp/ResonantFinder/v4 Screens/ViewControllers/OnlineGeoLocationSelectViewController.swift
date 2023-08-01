//
//  OnlineGeoLocationSelectViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 7/22/23.
//

import UIKit
import MapKit
import SwiftAA
import TimeZoneLocate

class OnlineGeoLocationSelectViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    
    var originViewController:UIViewController? = nil
    
    static func presentModally(over presentingViewController: UIViewController, originViewController: UIViewController?) {
        guard let vc = UIStoryboard(name: "GeoLocationSelect", bundle: nil).instantiateViewController(withIdentifier: "OnlineGeoLocationSelectViewController") as? OnlineGeoLocationSelectViewController else {
            return
        }
        vc.originViewController = originViewController
        presentingViewController.present(vc, animated: true) {
            
        }
    }
        
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var touchZoneView: UIView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var selectDateButton: UIButton!
    
    var dataMode:DataMode = .aspectEventScannerCore
    
    var searchController:UISearchController? = nil
    var annotation:MKAnnotation? = nil
    var localSearchRequest:MKLocalSearch.Request? = nil
    var localSearch:MKLocalSearch? = nil
    var localSearchResponse:MKLocalSearch.Response? = nil
    var error:NSError? = nil
    var pointAnnotation:MKPointAnnotation? = nil
    var pinAnnotationView:MKPinAnnotationView? = nil
    
    var delegate:FindLocationViewControllerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        
        latitudeTextField.text = "\(StarChart.Core.current.coordinates.latitude.value)"
        longitudeTextField.text = "\(-StarChart.Core.current.coordinates.longitude.value)"
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        ResonanceReportViewController.current?.update()
        ResonanceReportViewController.current?.renderStarChart()
    }
    
    @IBAction func selectButtonTap(_ sender: UIButton) {
        // Set Lat Long and Location Title to Main Screen
        selectGeoLocation()
        originViewController?.dismiss(animated: true, completion: {
            // Dismissed
        })
    }
    
    func selectedLocation() -> CLLocation {
        let lat:Double
        let long:Double
        
        if let latitude = latitudeTextField.text?.toDouble(),
        let longitude = longitudeTextField.text?.toDouble() {
            lat = latitude
            long = longitude
        } else {
            lat = StarChart.Core.current.coordinates.location.coordinate.latitude
            long = StarChart.Core.current.coordinates.location.coordinate.longitude
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        // Lat Long
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return location
    }
    
    func selectedTimeZone() -> TimeZone {
        return selectedLocation().timeZone
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //1
        searchBar.resignFirstResponder()
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation!)
        }
        //2
        localSearchRequest = MKLocalSearch.Request()
        localSearchRequest!.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest!)
        localSearch!.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertController.Style.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation!.title = searchBar.text
            let coords = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            self.pointAnnotation!.coordinate = coords
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation!.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView!.annotation!)
            
            self.latitudeTextField.text = "\(Double(coords.latitude))"
            self.longitudeTextField.text = "\(Double(coords.longitude))"
        }
    }
    
    
    @IBAction func rootViewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if latitudeTextField.text?.isEmpty == true || latitudeTextField.text == nil || longitudeTextField.text?.isEmpty == true || longitudeTextField.text == nil {
            selectDateButton.isEnabled = false
        } else {
            selectDateButton.isEnabled = true
        }
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        touchZoneView.isHidden = false
        tapGestureRecognizer.isEnabled = true
        
        if latitudeTextField.text?.isEmpty == true || latitudeTextField.text == nil || longitudeTextField.text?.isEmpty == true || longitudeTextField.text == nil {
            selectDateButton.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        touchZoneView.isHidden = true
        tapGestureRecognizer.isEnabled = false
        
        selectDateButton.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func xButtonTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Select GeoLocation
    func selectGeoLocation() {
        let lat:Double
        let long:Double
        
        // Handle different situations 
        if let latitude = latitudeTextField.text?.toDouble(),
        let longitude = longitudeTextField.text?.toDouble() {
            lat = latitude
            long = longitude
        } else {
            switch dataMode {
            case .aspectEventScannerCore:
                lat = AspectEventScanner.Core.coordinates.location.coordinate.latitude
                long = AspectEventScanner.Core.coordinates.location.coordinate.longitude
            case .starChartCore:
                lat = StarChart.Core.current.coordinates.location.coordinate.latitude
                long = StarChart.Core.current.coordinates.location.coordinate.longitude
            }
        }
        
        // Lat Long to Coordinate
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let coordinates = GeographicCoordinates(location)
        
        let cityTitle = mapView.annotations.first?.description ?? ""
        
        print(cityTitle)
        
        switch dataMode {
        case .aspectEventScannerCore:
            AspectEventScanner.Core.coordinates = coordinates
        case .starChartCore:
            let timeZoneDate = StarChart.Core.current.date
            StarChart.Core.current = StarChartRegistry.main.getStarChart(date: timeZoneDate, geographicCoordinates: coordinates, onComplete: { starChart in
                ResonanceReportViewController.current?.update()
            })
        }
    }
}


extension OnlineGeoLocationSelectViewController {
    enum DataMode {
        case aspectEventScannerCore
        case starChartCore
    }
                
    func modeFor(_ object:AnyObject) -> OnlineGeoLocationSelectViewController.DataMode {
        if object is AspectEventScanner.Core {
            return .aspectEventScannerCore
        } else {
            return .starChartCore
        }
    }
}
