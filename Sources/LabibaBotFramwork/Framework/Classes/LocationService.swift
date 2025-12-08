//
//  LocationService.swift
//  Visit Jordan Bot
//
//  Created by AhmeDroid on 10/26/16.
//  Copyright © 2016 Imagine Technologies. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

enum AuthorizationLevel
{
    case always
    case whenInUse
}

@objc protocol LocationServiceDelegate: class
{
    @objc optional func locationService(_ service: LocationService, didReceiveLocation location: CLLocationCoordinate2D)
    @objc optional func locationService(_ service: LocationService, didReceiveAddress place: CLPlacemark)
    @objc optional func locationServiceFailedGettingLocation(_ service: LocationService)
    @objc optional func locationServiceFailedGettingAddress(_ service: LocationService)
}

class LocationService: NSObject, CLLocationManagerDelegate
{

    weak var delegate: LocationServiceDelegate?
    static var shared: LocationService = LocationService()

    let defaultLocation = CLLocationCoordinate2D(latitude: 31.9782797, longitude: 35.8458698)
    var authorizationLevel: AuthorizationLevel
    var locationManager: CLLocationManager

    private override init()
    {

        self.authorizationLevel = .always
        self.locationManager = CLLocationManager()

        super.init()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
    }

    func requestAuthorization() -> Void
    {
     guard Labiba.isLocationEnabled else{ return }

        if authorizationLevel == .always
        {
            self.locationManager.requestAlwaysAuthorization()
        }
        else
        {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func checkLocationAccess(from VC: UIViewController ,authorized:(()->Void )? = nil , cancelWithoutAuthorization:(()->Void)? = nil) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                let alert = UIAlertController(title: "app-title".localForChosnLangCodeBB, message: "appLacationServiceActivation".localForChosnLangCodeBB, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK".localForChosnLangCodeBB, style: .default, handler: { action in
                    print("default")
                    cancelWithoutAuthorization?()
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                }))
                alert.addAction(UIAlertAction(title: "Close".localForChosnLangCodeBB, style: .default, handler: { action in
                    cancelWithoutAuthorization?()
                }))
                VC.present(alert, animated: true, completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                authorized?()
            }
        }
        else {
            
            let alert = UIAlertController(title: "app-title".localForChosnLangCodeBB, message: "deviceLacationServiceActivation".localForChosnLangCodeBB, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localForChosnLangCodeBB, style: .default, handler: { action in
                cancelWithoutAuthorization?()
            }))
            
            
            VC.present(alert, animated: true, completion: nil)
            print("Location services are not enabled")
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        guard Labiba.isLocationEnabled else{ return }
        print("Location Change Authorization !")

        let status = CLLocationManager.authorizationStatus()

        if status == .notDetermined
        {

            if authorizationLevel == .always
            {
                manager.requestAlwaysAuthorization()
            }
            else
            {
                manager.requestWhenInUseAuthorization()
            }

        }
        else if status == .authorizedAlways
        {

            self.locationManager.startUpdatingLocation()

        }
        else if status == .authorizedWhenInUse
        {

            if authorizationLevel == .always
            {
                manager.requestAlwaysAuthorization()
            }
            else
            {
                self.locationManager.startUpdatingLocation()
            }

        }
        else if status == .denied || status == .restricted
        {

            showErrorMessage("Access to location service was denied by you. Please give access to location services to enjoy the full of features of the app.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {

        print("Error in location service: \(error.localizedDescription)")
        self.delegate?.locationServiceFailedGettingLocation?(self)
    }

    var certainLocation: CLLocationCoordinate2D
    {
        return self.currentLocation ?? self.defaultLocation
    }

    var currentPlacemark: CLPlacemark?
    var currentLocation: CLLocationCoordinate2D?

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard Labiba.isLocationEnabled else{ return }
        print("locationManager Did recieve user location ...")
        manager.stopUpdatingLocation()

        if let location = locations.last
        {

            self.currentLocation = location.coordinate
            self.delegate?.locationService?(self, didReceiveLocation: location.coordinate)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarksData, error) in

                if error != nil
                {

                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    self.delegate?.locationServiceFailedGettingAddress?(self)

                }
                else if let placemarks = placemarksData, placemarks.count > 0
                {

                    let pm = placemarks[0]
                    self.currentPlacemark = pm

                    let loc: String = pm.locality ?? ""
                    let sloc: String = pm.subLocality ?? ""
                    print("User location reverse geocoded: \(loc), \(sloc)")

                    self.delegate?.locationService?(self, didReceiveAddress: pm)

                }
                else
                {

                    print("Problem with the data received from geocoder")
                    self.delegate?.locationServiceFailedGettingAddress?(self)
                }
            })
        }
    }

    func updateLocation() -> Void
    {
        guard Labiba.isLocationEnabled else{ return }
        print("Updating user location ...")
        self.locationManager.startUpdatingLocation()
    }

    func openDefaultMapForDirections(_ location: CLLocationCoordinate2D)
    {

        if let userLoc = LocationService.shared.currentLocation
        {

            if !openGoogleMapAppForDirections(userLoc, loc2: location)
            {
                openAppleMapAppForDirections(location)
            }

        }
        else
        {

            openAppleMapAppForDirections(location)
        }
    }

    func openGoogleMapAppForDirections(_ loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) -> Bool
    {
       /*
         to open googl map this must be added to info.plist
         
         <key>LSApplicationQueriesSchemes</key>
         <array>
         <string>comgooglemaps</string>
         <string>comgooglemaps-x-callback</string>
         </array>
         */
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
        {

            let startParam = "saddr=\(loc1.joined)"
            let destinationParam = "daddr=\(loc2.joined)"
            let modeParam = "directionsmode=driving"
            let fullPath = "comgooglemaps://?\(startParam)&\(destinationParam)&\(modeParam)"
            
            if let fullUrl = URL(string: fullPath)
            {
                
                UIApplication.shared.open(fullUrl, options: [:], completionHandler: nil)
                return true
                
            }
            else
            {
                
                print("Corrupted URL for Google Maps");
                return false
            }

        }
        else
        {

            print("Can't use comgooglemaps://")
            return false
        }
    }
    
    func openGoogleMapAppUsingLocation( placeName:String? , _ location: CLLocationCoordinate2D) -> Bool
     {

         if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
         {
             var pinParam = ""
            if var name  = placeName {
                name = name.compressingWhiteSpaces()
                name = name.replacingOccurrences(of: " ", with: "+")
                pinParam =  "q=\(name)"
            }else{
               pinParam = "q=\(coordsString(location))"
            }
             let centerParam = "center=\(coordsString(location))"
             let zoomParam = "zoom=15"
             let viewsParam = "views=traffic"

             let fullPath = "comgooglemaps://?\(pinParam)&\(centerParam)&\(zoomParam)&\(viewsParam)"

             if let fullUrl = URL(string: fullPath)
             {
                UIApplication.shared.open(fullUrl, options: [:], completionHandler: nil)
                return true
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
        mapItem.openInMaps(launchOptions: options)
    }
}

func calculateDistance(loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) -> CLLocationDistance
{

    let dLoc1 = CLLocation(latitude: loc1.latitude, longitude: loc1.longitude)
    let dLoc2 = CLLocation(latitude: loc2.latitude, longitude: loc2.longitude)

    return dLoc1.distance(from: dLoc2)
}

extension CLLocationCoordinate2D
{

    var joined: String
    {
        return "\(self.latitude),\(self.longitude)"
    }
}

