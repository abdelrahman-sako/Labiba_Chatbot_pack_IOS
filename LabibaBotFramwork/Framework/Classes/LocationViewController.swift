//
//  LocationViewController.swift
//  LabibaAgents
//
//  Created by AhmeDroid on 10/23/17.
//  Copyright © 2017 Imagine Technologies. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{

    var currentTitle: String?
    var currentLocation: CLLocationCoordinate2D!

    class func present(onView vc: UIViewController, withLocation coords: CLLocationCoordinate2D, andTitle title: String? = nil)
    {

        if let locVC = Labiba.storyboard.instantiateViewController(withIdentifier: "locationVC") as? LocationViewController
        {

            locVC.currentLocation = coords
            locVC.currentTitle = title
            vc.present(locVC, animated: true, completion: {})
        }
    }

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var externalLinksView: UIView!

    @IBAction func showPlaceLocation(_ sender: AnyObject)
    {

        if let location = self.currentLocation
        {

            self.mapView.setCenter(location, animated: true)
        }
    }

    @IBAction func showUserLocation(_ sender: AnyObject)
    {

        if let coords = finder.lastFoundLocation
        {

            self.mapView.setCenter(coords, animated: true)
        }
        else
        {

            finder.lookForUserLocation
            { (coords) in

                if let _coords = coords
                {
                    self.mapView.setCenter(_coords, animated: true)
                }
            }
        }
    }

    @IBAction func openMapAppDirections(_ sender: AnyObject)
    {

        if let userLoc = finder.lastFoundLocation,
           let placeLoc = self.currentLocation
        {

            if !openGoogleMapAppForDirections(userLoc, loc2: placeLoc)
            {
                openAppleMapAppForDirections(placeLoc)
            }

        }
        else if let placeLoc = self.currentLocation
        {

            openAppleMapAppForDirections(placeLoc)

        }
        else if let location = self.currentLocation
        {

            openAppleMapAppForDirections(location)
        }
    }

    @IBAction func openMapApp(_ sender: AnyObject)
    {

        if let location = self.currentLocation
        {

            if !openGoogleMapAppUsingLocation(location)
            {
                openAppleMapAppUsingLocation(location)
            }
        }
    }

    func openGoogleMapAppForDirections(_ loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) -> Bool
    {

        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
        {

            let startParam = "saddr=\(coordsString(loc1))"
            let destinationParam = "daddr=\(coordsString(loc2))"
            let modeParam = "directionsmode=driving"
            let fullPath = "comgooglemaps://?\(startParam)&\(destinationParam)&\(modeParam)"

            if let fullUrl = URL(string: fullPath)
            {
                UIApplication.shared.openURL(fullUrl)
            }
            else
            {

                print("Corrupted URL for Google Maps");
            }

            return true
        }
        else
        {

            print("Can't use comgooglemaps://")
            return false
        }
    }

    func openGoogleMapAppUsingLocation(_ location: CLLocationCoordinate2D) -> Bool
    {

        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
        {

            var placeName: String = self.currentTitle ?? "Unknown Place"
            placeName = placeName.compressingWhiteSpaces()
            placeName = placeName.replacingOccurrences(of: " ", with: "+")

            let pinParam = "q=\(placeName)"
            let centerParam = "center=\(coordsString(location))"
            let zoomParam = "zoom=15"
            let viewsParam = "views=traffic"

            let fullPath = "comgooglemaps://?\(pinParam)&\(centerParam)&\(zoomParam)&\(viewsParam)"

            if let fullUrl = URL(string: fullPath)
            {
                UIApplication.shared.openURL(fullUrl)
            }
            else
            {

                print("Corrupted URL for Google Maps");
            }

            return true
        }
        else
        {

            print("Can't use comgooglemaps://")
            return false
        }
    }

    func openAppleMapAppForDirections(_ location: CLLocationCoordinate2D) -> Void
    {

        let coordinates = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let options = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.currentTitle ?? "Unknown Place"
        mapItem.openInMaps(launchOptions: options)
    }

    func openAppleMapAppUsingLocation(_ location: CLLocationCoordinate2D) -> Void
    {

        let regionDistance: CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.currentTitle ?? "Unknown Place"
        mapItem.openInMaps(launchOptions: options)
    }

    @IBAction func closeView(_ sender: AnyObject)
    {

        self.dismiss(animated: true, completion: {})
    }

    private var finder = LocationFinder()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        let radius: CLLocationDistance = 300

        finder.lookForUserLocation(completion: { _ in })

        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.mapView.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 31.9499895, longitude: 35.9394769),
            latitudinalMeters: radius * 2.0, longitudinalMeters: radius * 2.0)

        let marker = MKPointAnnotation()
        marker.title = self.currentTitle
        marker.coordinate = self.currentLocation

        self.mapView.setCenter(self.currentLocation, animated: false)
        self.mapView.addAnnotation(marker)
        self.mapView.selectAnnotation(marker, animated: true)
    }


}

func coordsString(_ coord: CLLocationCoordinate2D) -> String
{
    return "\(coord.latitude),\(coord.longitude)"
}

class LocationFinder: CLLocationManager, CLLocationManagerDelegate
{

    var lastFoundLocation: CLLocationCoordinate2D?
    private var locationFoundHandler: (CLLocationCoordinate2D?) -> Void = { _ in
    }

    func lookForUserLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) -> Void
    {

        switch CLLocationManager.authorizationStatus()
        {
        case .notDetermined, .restricted:
            self.requestWhenInUseAuthorization()
        default:
            break
        }

        self.delegate = self
        self.locationFoundHandler = completion
        self.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {

        if let location = locations.last
        {
            self.lastFoundLocation = location.coordinate
            self.locationFoundHandler(location.coordinate)
        }
        else
        {
            self.locationFoundHandler(nil)
        }

        self.stopUpdatingLocation()
        self.locationFoundHandler = { _ in
        }
    }
}
