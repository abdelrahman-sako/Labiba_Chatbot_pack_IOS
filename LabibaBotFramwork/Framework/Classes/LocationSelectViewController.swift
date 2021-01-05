//
//  LocationSelectViewController.swift
//  Shakawekom
//
//  Created by AhmeDroid on 4/11/17.
//  Copyright © 2017 Imagine Technologies. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol LocationSelectViewControllerDelegate
{

    func locationSelectDidReceiveAddress(_ address: String, atCoordinates coordinates: CLLocationCoordinate2D) -> Void
}

class LocationSelectViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{

    class func present(withDelegate delegate: LocationSelectViewControllerDelegate?)
    {

        if let rootVC = getTheMostTopViewController(),
           let locVC = Labiba.storyboard.instantiateViewController(withIdentifier: "locationSelectVC") as? LocationSelectViewController
        {

            locVC.delegate = delegate
            rootVC.present(locVC, animated: true, completion: {})
        }
    }

    @IBOutlet weak var mapView: MKMapView!

    let geocoder = CLGeocoder()
    var delegate: LocationSelectViewControllerDelegate?

    @IBOutlet weak var selectionButton: UIButton!

    @IBAction func selectAddress(_ sender: Any)
    {
        guard let selectedAddress = self.selectedAddress , let selectedLocation = self.selectedLocation else {
            let alert = UIAlertController(title: "detectLocation".localForChosnLangCodeBB,
                                          message: "locationError".localForChosnLangCodeBB,
                                          preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "Yes".localForChosnLangCodeBB, style: .default, handler: nil)
            alert.addAction(okayAction)
            self.present(alert, animated: true, completion: {})
            return
        }

        let alert = UIAlertController(title: "Select Location".localForChosnLangCodeBB,
                                      message: String(format: "location-msg".localForChosnLangCodeBB, selectedAddress),
                preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel".localForChosnLangCodeBB, style: .cancel, handler: { _ in })
        let okayAction = UIAlertAction(title: "Yes".localForChosnLangCodeBB, style: .default)
        { (action) in

            self.dismiss(animated: true)
            {
                self.delegate?.locationSelectDidReceiveAddress(selectedAddress, atCoordinates: selectedLocation)
            }
        }

        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: {})
    }

    @IBAction func showUserLocation(_ sender: Any)
    {

        self.lookForUserLocation()
    }

    private var indicator: UIActivityIndicatorView!
    private var indicatorContainer: UIView!

    override func viewDidLoad()
    {

        super.viewDidLoad()
        UIApplication.shared.setStatusBarColor(color: .clear)
        let w = self.view.frame.width
        let view = UIView(frame: CGRect(x: (w - 36) * 0.5, y: 25, width: 40, height: 40))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.white

        indicator = UIActivityIndicatorView(frame: CGRect(x: 4, y: 4, width: 32, height: 32))
        view.addSubview(indicator)

        indicatorContainer = view
        selectionButton.isHidden = true

        let radius: CLLocationDistance = 500

        self.mapView.delegate = self
        self.mapView.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: Labiba.defaultLocation.latitude, longitude: Labiba.defaultLocation.longitude),
            latitudinalMeters: radius * 2.0, longitudinalMeters: radius * 2.0)
        self.lookForUserLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LocationService.shared.checkLocationAccess(from: self, authorized: nil) {
            self.dismiss(animated: true, completion: {})
        }
    }
   

    func showLoadingIndicator() -> Void
    {
        self.view.addSubview(indicatorContainer)
        indicator.startAnimating()
    }

    func hideLoadingIndicator() -> Void
    {
        indicatorContainer.removeFromSuperview()
        indicator.stopAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Labiba.setStatusBarColor(color: Labiba._StatusBarColor)
    }

    private var selectedAddress: String?
    private var selectedLocation: CLLocationCoordinate2D?

    @IBAction func mapViewWasTapped(_ sender: Any)
    {

        if let _sender = sender as? UITapGestureRecognizer
        {

            let touchPos = _sender.location(in: self.mapView)
            let location = self.mapView.convert(touchPos, toCoordinateFrom: self.mapView)
            self.lookupForAddress(atCoordinate: location)
        }
    }

    var currentMarker: MKPointAnnotation?

    func lookupForAddress(atCoordinate coordinate: CLLocationCoordinate2D) -> Void
    {

        self.mapView.removeAnnotations(self.mapView.annotations)

        let marker = MKPointAnnotation()
        marker.title = "Loading ..."
        marker.coordinate = coordinate

        self.mapView.addAnnotation(marker)

        self.showLoadingIndicator()
        self.currentMarker = marker

        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        self.geocoder.reverseGeocodeLocation(location)
        { (placemarks, error) in

            let marker = self.currentMarker!

            self.hideLoadingIndicator()
            if error != nil
            {
                print("Error while reverse geocoding: \(error?.localizedDescription ??  "")")
                marker.title = "Unknown"
                return
            }

            if let result = placemarks?.first
            {

                self.selectedLocation = coordinate

                let lines = result.addressDictionary?["FormattedAddressLines"] as? [String]
                var fullAddress = "Unknown"
                if let _lines = lines , _lines.count > 0
                {
                    fullAddress = _lines[1..<_lines.count].joined(separator: ", ");
                 
                }
                

                self.selectedAddress = fullAddress
                self.selectionButton.isHidden = false

                print("location reverse geocoded ...")
                if (lines?.count ?? 0) >= 4 {
                var subtitle = lines?[2] ?? ""
                subtitle += subtitle.isEmpty == false && lines?[3] != nil ? ", " : ""
                subtitle += lines?[3] ?? ""
                marker.subtitle = subtitle
                }
                if lines?.count ?? 0 > 1{
                    marker.title = lines?[1]
                }
                self.mapView.selectAnnotation(marker, animated: true)
            }
        }

    }

    @IBAction func closeView(_ sender: Any)
    {

        self.dismiss(animated: true, completion: {})
    }

    private var locationManager = CLLocationManager()

    func lookForUserLocation() -> Void
    {

        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {

        if let location = locations.last
        {
            print("user location ..")
            self.mapView.setCenter(location.coordinate, animated: true)
            self.lookupForAddress(atCoordinate: location.coordinate)
        }

        self.locationManager.stopUpdatingLocation()
    }
}

