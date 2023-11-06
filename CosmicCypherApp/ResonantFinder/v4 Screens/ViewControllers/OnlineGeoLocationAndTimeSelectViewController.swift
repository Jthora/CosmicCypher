//
//  OnlineGeoLocationSelectViewController.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 6/29/22.
//

import UIKit
import MapKit
import SwiftAA
import TimeZoneLocate

class OnlineGeoLocationAndTimeSelectViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate {
    
    static func presentModally(over presentingViewController: UIViewController) {
        guard let vc = UIStoryboard(name: "StarChartSelect", bundle: nil).instantiateViewController(withIdentifier: "OnlineGeoLocationAndTimeSelectViewController") as? OnlineGeoLocationAndTimeSelectViewController else {
            return
        }
        presentingViewController.present(vc, animated: true) {
            
        }
    }
        
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
        
        latitudeTextField.text = "\(StarChart.Core.current.coordinates.latitude.value)"
        longitudeTextField.text = "\(-StarChart.Core.current.coordinates.longitude.value)"
        
        let timezone = StarChart.Core.current.coordinates.location.timeZone
        
        datePicker.timeZone = StarChart.Core.current.coordinates.location.timeZone
        timePicker.timeZone = StarChart.Core.current.coordinates.location.timeZone
        
        datePicker.date = StarChart.Core.current.date//.convertToTimeZone(initTimeZone: <#T##TimeZone#>, timeZone: timezone)
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
        selectGeoDate()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: {
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
    
    func selectGeoDate() {
        let isLatLongSet:Bool
        let lat:Double
        let long:Double
        
        if let latitude = latitudeTextField.text?.toDouble(),
        let longitude = longitudeTextField.text?.toDouble() {
            lat = latitude
            long = longitude
            isLatLongSet = true
        } else {
            lat = StarChart.Core.current.coordinates.location.coordinate.latitude
            long = StarChart.Core.current.coordinates.location.coordinate.longitude
            isLatLongSet = false
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        // Lat Long
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let coordinates = GeographicCoordinates(location)
        
        let cityTitle = mapView.annotations.first?.description ?? ""
        
        print(cityTitle)
        
        let secondsFromGMT = Int(coordinate.longitude/180 * (60*60*12))
        
//        let timeZone: TimeZone
//        if isLatLongSet {
//            timeZone = location.timeZone
//        } else {
//            timeZone = TimeZone.current
//        }
        let timeZoneA = TimeZone(secondsFromGMT: 0)!
        let timeZoneB = TimeZone(secondsFromGMT: -secondsFromGMT)!
        let timeZoneC = TimeZone(secondsFromGMT: secondsFromGMT)!
        let timeZoneD = TimeZone.current
        let timeZone = location.timeZone
        
        print("timeZoneA: \(timeZoneA.secondsFromGMT())")
        print("timeZoneB: \(timeZoneB.secondsFromGMT())")
        print("timeZoneC: \(timeZoneC.secondsFromGMT())")
        print("timeZoneD: \(timeZoneD.secondsFromGMT())")
        print("timeZone: \(timeZone.secondsFromGMT())")
        
        let hour = timePicker.date.hour(timeZone: timeZone)
        let offsetHour = timePicker.date.hour()
        let minute = timePicker.date.minute(timeZone: timeZone)
        let offsetMinute = timePicker.date.minute()

        if var timeZoneDate = Date(year: datePicker.date.year,
                                   month: datePicker.date.month,
                                   day: datePicker.date.day,
                                   timeZone: timeZone,
                                   hour: hour,
                                   minute: minute,
                                   second: timePicker.date.second) {
            print("OnlineGeoLocate: TimeZone Offset: \(timeZone.description)")
            print("OnlineGeoLocate: datePicker date \(datePicker.date) - \(datePicker.date.formatted(date: .numeric, time: .complete))")
            print("OnlineGeoLocate: timePicker time \(timePicker.date) - \(timePicker.date.formatted(date: .numeric, time: .complete))")
            print("OnlineGeoLocate: current starchart changing \(timeZoneDate) - \(timeZoneDate.formatted(date: .numeric, time: .complete))")
            
            StarChart.Core.current = try! StarChartRegistry.main.getStarChart(date: timeZoneDate, geographicCoordinates: coordinates, onComplete: { starChart in
                ResonanceReportViewController.current?.update()
            })
        } else {
            print("OnlineGeoLocate: ERROR:: TimeZone Offset Missing")
        }
        
    }
}
