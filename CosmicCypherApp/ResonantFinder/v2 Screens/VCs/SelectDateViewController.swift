//
//  SelectDateViewController.swift
//  ResonantFinder
//
//  Created by Jordan Trana on 12/13/19.
//  Copyright © 2019 Jordan Trana. All rights reserved.
//

import UIKit
import MapKit
import SwiftAA
import TimeZoneLocate

class SelectDateViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var touchZoneView: UIView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var selectDateButton: UIButton!
    
    var searchController:UISearchController? = nil
    var annotation:MKAnnotation? = nil
    var localSearchRequest:MKLocalSearch.Request? = nil
    var localSearch:MKLocalSearch? = nil
    var localSearchResponse:MKLocalSearch.Response? = nil
    var error:NSError? = nil
    var pointAnnotation:MKPointAnnotation? = nil
    var pinAnnotationView:MKPinAnnotationView? = nil
    
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
        
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        
        datePicker.date = StarChart.Core.current.date
        timePicker.date = StarChart.Core.current.date
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ResonanceReportViewController.current?.update()
        ResonanceReportViewController.current?.renderStarChart()
    }
    
    
    @IBAction func cancelButtonTap(_ sender: UIButton) {
        self.dismiss(animated: true) {
            // Dismissed
        }
    }
    
    @IBAction func selectButtonTap(_ sender: UIButton) {
        // Set Lat Long and Location Title to Main Screen
        
        let isLatLongSet:Bool
        let lat:Double
        let long:Double
        
        if let latitude = Double(latitudeTextField.text ?? "0"),
        let longitude = Double(longitudeTextField.text ?? "0") {
            lat = latitude
            long = longitude
            isLatLongSet = true
        } else {
            lat = 0
            long = 0
            isLatLongSet = false
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        // Lat Long
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let coordinates = GeographicCoordinates(location)
        
        let cityTitle = mapView.annotations.first?.description ?? ""
        
        print(cityTitle)
        
        //let secondsFromGMT = Int(coordinate.longitude/180 * (60*60*12))
        
        let timeZone: TimeZone
        if isLatLongSet {
            timeZone = location.timeZone
        } else {
            timeZone = TimeZone.current
        }
        
        if let timeZoneDate = Date(year: datePicker.date.year, month: datePicker.date.month, day: datePicker.date.day, timeZone: timeZone, hour: timePicker.date.hour, minute: timePicker.date.minute, second: timePicker.date.second) {
            print("TimeZone Offset: \(location.timeZone.description)")
            StarChart.Core.current = StarChartRegistry.main.getStarChart(date: timeZoneDate, geographicCoordinates: coordinates, onComplete: { starChart in
                ResonanceReportViewController.current?.update()
            })
        } else {
            print("ERROR:: TimeZone Offset Missing")
        }
        
        
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: {
            // Dismissed
        })
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
}
