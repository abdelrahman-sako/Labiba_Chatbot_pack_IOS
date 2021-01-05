//
//  CustomMapPicker.swift
//  dubaiPolice
//
//  Created by Yehya Titi on 1/20/19.
//  Copyright © 2019 Imagine Inc. All rights reserved.
//

//import Foundation
//import GoogleMaps
//import UIKit
//import GooglePlaces
////import SVProgressHUD
//import Alamofire
import MapKit
//
protocol CustomMapPickerDelegate:class
{
    func CustomMapPickerIsSelected(_ address: String, atCoordinates coordinates:CLLocationCoordinate2D, Radius: String ) -> Void
}
//
//
//class CustomMapPicker: UIViewController, GMSMapViewDelegate, UITextFieldDelegate, GMSAutocompleteResultsViewControllerDelegate, UITableViewDelegate, UITableViewDataSource
//{
//    
//    weak var customMapPickerDelegate:CustomMapPickerDelegate?
//    
//    ///*****************////
//    @IBOutlet weak var textField: UITextField!
//    
//    var autocompleteTableView: UITableView!
//    var autocompleteUrls = [String]()
//    var allSuggestions = [Prediction]()
//    var SelectedCoordinate = CLLocationCoordinate2D()
//    ///*****************////
//    
//    class func present(withDelegate delegate: CustomMapPickerDelegate?)
//    {
//        GMSPlacesClient.provideAPIKey(Labiba._GoogleApiKey)
//        GMSServices.provideAPIKey(Labiba._GoogleApiKey)
//        
//        if let viewC = getTheMostTopViewController(),
//            let mapVC = Labiba.storyboard.instantiateViewController(withIdentifier: "customMapPicker") as? CustomMapPicker
//        {
//            mapVC.customMapPickerDelegate = delegate
//            viewC.present(mapVC, animated: true, completion: {})
//        }
//        
//    }
//    
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace)
//    {
//        print("Done")
//        //searchController?.isActive = false
//        checkAddress(coordinate: place.coordinate)
//    }
//    
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error)
//    {
//        print("Not Done")
//        //searchController?.isActive = false
//    }
//    
//    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController)
//    {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//    
//    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController)
//    {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//    }
//    
//    
//    
//    @IBOutlet weak var MapView: GMSMapView!
//    @IBOutlet weak var AddressLabel: UILabel!
//    @IBOutlet weak var SendButton: UIButton!
//    @IBOutlet weak var RadiusSelector: UISegmentedControl!
//    
//    @IBAction func SendButtonClicked(_ sender: UIButton)
//    {
//        if(SelectedCoordinate.longitude != 0.0)
//        {
//            let radius = RadiusSelector.selectedSegmentIndex
//            var radiusArea:String
//            if(radius == 0)
//            {
//                radiusArea = "1"
//            }
//            else if(radius == 1)
//            {
//                radiusArea = "3"
//            }
//            else
//            {
//                radiusArea = "5"
//            }
//            self.dismiss(animated: true)
//            self.customMapPickerDelegate?.CustomMapPickerIsSelected("String", atCoordinates: SelectedCoordinate, Radius: radiusArea)
//        }
//        else
//        {
//            showToast(message: "Click to choose location")
//        }
//    }
//    @IBAction func RadiusSelectorChanged(_ sender: UISegmentedControl)
//    {
//        if(SelectedCoordinate.longitude != 0.0)
//        {
//            checkAddress(coordinate: SelectedCoordinate)
//        }
//        
//    }
//    ///////////////
//    //    var resultsViewController: GMSAutocompleteResultsViewController?
//    //    var searchController: UISearchController?
//    //    var resultView: UITextView?
//    ////////////
//    
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        MapView.delegate = self
//        
//        let camera = GMSCameraPosition.camera(withLatitude: 25.2048, longitude: 55.2708, zoom: 10)
//        MapView?.camera = camera
//        MapView?.animate(to: camera)
//        MapView?.isMyLocationEnabled = false
//        
//        //////////////////////////
//        //        resultsViewController = GMSAutocompleteResultsViewController()
//        //        resultsViewController?.delegate = self
//        //        let filters = GMSAutocompleteFilter()
//        //        filters.country = "AE"
//        //        resultsViewController?.autocompleteFilter = filters
//        //        //resultsViewController?.autocompleteFilter?.country = "ARE"
//        //
//        //
//        //        searchController = UISearchController(searchResultsController: resultsViewController)
//        //        searchController?.searchResultsUpdater = resultsViewController
//        //
//        //        let subView = UIView(frame: CGRect(x: 0, y: 40.0, width: 350.0, height: 45.0))
//        //
//        //        subView.addSubview((searchController?.searchBar)!)
//        //        view.addSubview(subView)
//        //        searchController?.searchBar.sizeToFit()
//        //        searchController?.hidesNavigationBarDuringPresentation = false
//        //
//        //        // When UISearchController presents the results view, present it in
//        //        // this view controller, not one further up the chain.
//        //        definesPresentationContext = true
//        
//        ////////////////////////////
//        ///*****************////
//        autocompleteTableView = UITableView(frame: CGRect(x:textField.frame.minX, y:textField.frame.maxY, width: textField.frame.width, height: 0.0), style: UITableView.Style.plain)
//        
//        textField.delegate = self
//        
//        autocompleteTableView.delegate = self
//        autocompleteTableView.dataSource = self
//        autocompleteTableView.isScrollEnabled = true
//        autocompleteTableView.isHidden = false
//        
//        autocompleteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        self.view.addSubview(autocompleteTableView)
//        ///*****************////
//    }
//    
//    
//    func mapView(_ MapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D)
//    {
//        checkAddress(coordinate: coordinate)
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool
//    {
//        self.view.endEditing(true)
//        return false
//    }
//    func checkAddress(coordinate: CLLocationCoordinate2D)
//    {
//        SelectedCoordinate = coordinate
//        
//        let geocoder = GMSGeocoder()
//        let coordinate = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude)
//        var currentAddress = GMSAddress()
//        
//        geocoder.reverseGeocodeCoordinate(coordinate)
//        { response , error in
//            if let address = response?.firstResult()
//            {
//                currentAddress = address
//                if(currentAddress.locality == "Dubai")
//                {
//                    self.MapView.clear()
//                    let position = coordinate
//                    let marker = GMSMarker(position: position)
//                    marker.map = self.MapView
//                    var subLocality = ""
//                    if let address = currentAddress.subLocality
//                    {
//                        subLocality = address + " - "
//                    }
//                    let FormattedAddress = subLocality + currentAddress.locality! + " - " + currentAddress.country!
//                    self.AddressLabel.text = FormattedAddress
//                    self.AddRadius(coordinate: coordinate)
//                }
//                else
//                {
//                    self.showToast(message: "Selected Location should be in Dubai")
//                }
//            }
//        }
//        
//        
//    }
//    
//    
//    func showToast(message : String)
//    {
//        
//        let toastLabel = UILabel(frame: CGRect(x: 5, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 10, height: 35))
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        toastLabel.textColor = UIColor.white
//        toastLabel.textAlignment = .center;
//        toastLabel.font = UIFont(name: "Montserrat-Light", size: 8.0)
//        toastLabel.text = message
//        toastLabel.alpha = 1.0
//        toastLabel.layer.cornerRadius = 10;
//        toastLabel.clipsToBounds  =  true
//        self.view.addSubview(toastLabel)
//        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
//            toastLabel.alpha = 0.0
//        }, completion: {(isCompleted) in
//            toastLabel.removeFromSuperview()
//        })
//    }
//    
//    ///*****************////
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//    {
//        autocompleteTableView.isHidden = false
//        let substring = (self.textField.text! as NSString).replacingCharacters(in: range, with: string)
//        if(substring == "")
//        {
//            autocompleteTableView.isHidden = true
//        }
//        else
//        {
//            getPlaces(SearchString: substring)
//        }
//        return true
//    }
//    
//    //    func searchAutocompleteEntriesWithSubstring(substring: String)
//    //    {
//    //        autocompleteUrls.removeAll(keepingCapacity: false)
//    //
//    //        for CurrentPlace in allPlaces
//    //        {
//    //            var myString:NSString! = CurrentPlace as NSString
//    //
//    //            var substringRange :NSRange! = myString.range(of: substring)
//    //
//    //            if (substringRange.location  == 0)
//    //            {
//    //                autocompleteUrls.append(CurrentPlace)
//    //            }
//    //        }
//    //        autocompleteTableView.frame = CGRect(x:textField.frame.minX, y:textField.frame.maxY, width: textField.frame.width, height: CGFloat(50.0 * Double(autocompleteUrls.count)))
//    //        autocompleteTableView.reloadData()
//    //autocompleteTableView.hidden = false
//    //    }
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int
//    {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return allSuggestions.count
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        let autoCompleteRowIdentifier = "cell"
//        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: autoCompleteRowIdentifier, for: indexPath as IndexPath) as UITableViewCell
//        let index = indexPath.row as Int
//        cell.textLabel!.text = allSuggestions[index].description
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
//    {
//        textField.endEditing(true)
//        //let selectedCell : UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
//        //textField.text = self.allSuggestions[indexPath.row].description
//        self.textField.text = ""
//        self.autocompleteTableView.isHidden = true
//        GetPlaceDataByPlaceID(pPlaceID: self.allSuggestions[indexPath.row].placeID)
//        
//    }
//    
//    func AddRadius(coordinate: CLLocationCoordinate2D)
//    {
//        let radius = RadiusSelector.selectedSegmentIndex
//        var radiusArea:Double
//        if(radius == 0)
//        {
//            radiusArea = 1000
//        }
//        else if(radius == 1)
//        {
//            radiusArea = 3000
//        }
//        else
//        {
//            radiusArea = 5000
//        }
//        //        let circle = GMSCircle()
//        //        circle.radius = radiusArea // Meters
//        //        circle.fillColor = UIColor.red.withAlphaComponent(0.2)
//        //        circle.position = coordinate
//        //        circle.strokeWidth = 0.5;
//        //        circle.strokeColor = UIColor.black
//        //        circle.map = MapView;
//    }
//    
//    func GetPlaceDataByPlaceID(pPlaceID: String)
//    {
//        let placesClient = GMSPlacesClient.shared()
//        
//        //  pPlaceID = "ChIJXbmAjccVrjsRlf31U1ZGpDM"
//        placesClient.lookUpPlaceID(pPlaceID, callback: { (place, error) -> Void in
//            
//            if let error = error
//            {
//                print("lookup place id query error: \(error.localizedDescription)")
//                return
//            }
//            
//            if let place = place
//            {
//                //                print("Place name \(place.name)")
//                //                print("Place address \(place.formattedAddress!)")
//                //                print("Place placeID \(place.placeID)")
//                //                print("Place attributions \(place.attributions)")
//                //                print("\(place.coordinate.latitude)")
//                //                print("\(place.coordinate.longitude)")
//                self.checkAddress(coordinate: place.coordinate)
//            }
//            else
//            {
//                print("No place details for \(pPlaceID)")
//            }
//        })
//    }
//    
//    ///*****************////
//    
//    func getPlaces (SearchString : String)
//    {
//        //        SVProgressHUD.setDefaultStyle(.light)
//        //        SVProgressHUD.setDefaultMaskType(.black)
//        //        SVProgressHUD.setForegroundColor(UIColor.darkGray)
//        //        SVProgressHUD.setBackgroundColor(UIColor.white)
//        //        SVProgressHUD.show(withStatus: "\(localString("loading")) ...")
//        
//        let FixedSearchString = SearchString.replacingOccurrences(of: " ", with: "+")
//        Alamofire.request("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=dubai+" + FixedSearchString + "&key=" + Labiba._GoogleApiKey,
//                          method: .get).responseData { response in
//                            //SVProgressHUD.dismiss()
//                            do
//                            {
//                                let json = response.data
//                                let decoder = JSONDecoder()
//                                let result = try decoder.decode(PlacesAutoCompleteModel.self, from: json!)
//                                self.ReloadAutocompleteSuggestions(result: result)
//                            }
//                            catch let parseError as NSError
//                            {
//                                print("JSON Error \(parseError.localizedDescription)")
//                            }
//        }
//        
//    }
//    
//    func ReloadAutocompleteSuggestions(result: PlacesAutoCompleteModel)
//    {
//        allSuggestions.removeAll()
//        allSuggestions = result.predictions
//        if(allSuggestions.count == 0)
//        {
//            autocompleteTableView.isHidden = true
//        }
//        else
//        {
//            autocompleteTableView.isHidden = false
//            autocompleteTableView.frame = CGRect(x:textField.frame.minX, y:textField.frame.maxY, width: textField.frame.width, height: CGFloat(50.0 * Double(allSuggestions.count)))
//            autocompleteTableView.reloadData()
//        }
//        
//        
//    }
//    
//}
//
////extension ViewController: GMSAutocompleteResultsViewControllerDelegate {
////    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
////                           didAutocompleteWith place: GMSPlace) {
////        searchController?.isActive = false
////        // Do something with the selected place.
////        print("Place name: \(place.name)")
////        print("Place address: \(place.formattedAddress)")
////        print("Place attributions: \(place.attributions)")
////    }
////
////    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
////                           didFailAutocompleteWithError error: Error){
////        // TODO: handle the error.
////        print("Error: ", error.localizedDescription)
////    }
////
////    // Turn the network activity indicator on and off again.
////    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
////        UIApplication.shared.isNetworkActivityIndicatorVisible = true
////    }
////
////    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
////        UIApplication.shared.isNetworkActivityIndicatorVisible = false
////    }
////}
