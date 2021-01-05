//
//  RadiusViewController.swift
//  Dilluna
//
//  Created by Suhayb Ahmad on 7/15/18.
//  Copyright © 2018 Ali Hajjaj. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//import MaterialComponents

public protocol RadiusViewControllerDelegate: class
{

    func radiusController(_ radiusVC: RadiusViewController, didSelectLocation location: CLLocationCoordinate2D, withDistance distance: Double) -> Void
}

public class RadiusViewController: UIViewController, MKMapViewDelegate, LocationServiceDelegate
{

    public class func presentOn<Type: UIViewController & RadiusViewControllerDelegate>(_ vc: Type)
    {

        if let radiusVC = Labiba.storyboard.instantiateViewController(withIdentifier: "radiusVC") as? RadiusViewController
        {

            radiusVC.delegate = vc
            vc.present(radiusVC, animated: true, completion: nil)
        }
    }

    class func presentOn(_ vc: UIViewController, withDelegate del: RadiusViewControllerDelegate?)
    {

        if let radiusVC = Labiba.storyboard.instantiateViewController(withIdentifier: "radiusVC") as? RadiusViewController
        {

            radiusVC.delegate = del
            vc.present(radiusVC, animated: true, completion: nil)
        }
    }

    weak var delegate: RadiusViewControllerDelegate?
    var currentRadius: CLLocationDistance = 0

    @IBOutlet weak var radiusLabel: UILabel!

    @IBAction func cancelPressed(_ sender: Any)
    {

        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func okayPressed(_ sender: Any)
    {

        self.dismiss(animated: true)
        {

            self.delegate?.radiusController(self, didSelectLocation: self.mapView.region.center, withDistance: self.currentRadius)
        }
    }

    override public func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        LocationService.shared.delegate = self
    }

    override public func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)

        LocationService.shared.delegate = nil
    }

    @IBAction func showMyLocation(_ sender: Any)
    {

        LocationService.shared.updateLocation()
        self.mapView.setCenter(CLLocationCoordinate2D(latitude: 25.204974, longitude: 55.270641), animated: true)
    }

    func locationService(_ service: LocationService, didReceiveLocation location: CLLocationCoordinate2D)
    {

        self.mapView.setCenter(location, animated: true)
    }

    override public func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

        let circleCenter = CLLocationCoordinate2D(latitude: 25.204974, longitude: 55.270641)
        let circle = MKCircle(center: circleCenter, radius: self.currentRadius)

        self.mapView.setVisibleMapRect(circle.boundingMapRect, animated: true)
        self.displayDistance()
    }

    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {

        self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.removeAnnotations(self.mapView.annotations)

        let reg = self.mapView.region
        let c = reg.center
        let s = reg.span

        var loc1 = CLLocation(latitude: c.latitude, longitude: c.longitude)
        var loc2 = CLLocation(latitude: c.latitude, longitude: c.longitude + s.longitudeDelta / 2.0)
        let radius1 = loc1.distance(from: loc2) * 0.8

        loc1 = CLLocation(latitude: c.latitude, longitude: c.longitude)
        loc2 = CLLocation(latitude: c.latitude + s.latitudeDelta / 2.0, longitude: c.longitude)
        let radius2 = loc1.distance(from: loc2) * 0.8

        let radius = min(radius1, radius2)

        self.currentRadius = radius
        self.mapView.addOverlay(MKCircle(center: c, radius: radius))

        let point = MKPointAnnotation()
        point.coordinate = c

        self.mapView.addAnnotation(point)
        self.displayDistance()
    }

    func displayDistance() -> Void
    {

        self.radiusLabel.text = formatRadius(self.currentRadius)
        let c = self.mapView.region.center

        self.showLoadingIndicator()
        lookupForAddress(atCoordinate: c)
        { [weak self] (address) in

            self?.hideLoadingIndicator()

            if let addr = address
            {

                let fullStr = String(format: "radius-title".local, addr)
                let range = (fullStr as NSString).range(of: addr)
                let attrStr = NSMutableAttributedString(string: fullStr)

                attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
                self?.titleLabel.attributedText = attrStr

            }
            else
            {

                self?.titleLabel.text = "radius-default-title".local
            }
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var mapView: MKMapView!

    private var indicator: UIActivityIndicatorView!
    private var indicatorContainer: UIView!

    override public func viewDidLoad()
    {
        super.viewDidLoad()

        let w = self.view.frame.width
        let view = UIView(frame: CGRect(x: (w - 36) * 0.5, y: 25, width: 40, height: 40))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.white

        indicator = UIActivityIndicatorView(frame: CGRect(x: 4, y: 4, width: 32, height: 32))
        view.addSubview(indicator)

        indicatorContainer = view

        self.mapView.delegate = self

        let radius: CLLocationDistance = 15000
        self.currentRadius = radius

        self.mapView.isRotateEnabled = false
////        self.mapView.region = MKCoordinateRegionMakeWithDistance(
//            LocationService.shared.certainLocation,
//            radius * 2.0, radius * 2.0)
        self.mapView.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.204974, longitude: 55.270641),
            latitudinalMeters: radius * 2.0, longitudinalMeters: radius * 2.0)
//        LocationService.shared.certainLocation
        self.mapView.setCenter(CLLocationCoordinate2D(latitude: 25.204974, longitude: 55.270641), animated: false)
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

    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {

        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 0.1)
        renderer.strokeColor = UIColor(red: 1, green: 0.3, blue: 0.3, alpha: 0)
        renderer.lineWidth = 1

        return renderer
    }

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {

        let marker: MKAnnotationView
        if let _marker = self.mapView.dequeueReusableAnnotationView(withIdentifier: "marker")
        {
            _marker.annotation = annotation
            marker = _marker
        }
        else
        {
            marker = MKAnnotationView(annotation: annotation, reuseIdentifier: "marker")
            marker.image = Image(named: "radius-mark-icon")
        }

        return marker
    }
}

func formatRadius(_ value: Double) -> String
{

    let nf = NumberFormatter()
    nf.maximumFractionDigits = 2
    nf.minimumIntegerDigits = 1

    if value > 1000
    {
        return nf.string(from: NSNumber(value: value / 1000))! + " \("km".local)"
    }
    else
    {
        return nf.string(from: NSNumber(value: value))! + " \("meter".local)"
    }
}

func lookupForAddress(atCoordinate coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) -> Void
{

    let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in

        if error != nil
        {
            print("Error while reverse geocoding: \(error!.localizedDescription)")
            completion(nil)
            return
        }

        if let result = placemarks?.first
        {

            let country = result.country
            let city = result.locality
            let town = result.subLocality
            let area = result.subAdministrativeArea
            let fare = result.subThoroughfare

            print()
            print()
            print("- country -")
            print(country ?? "NULL")
            print("- city -")
            print(city ?? "NULL")
            print("- town -")
            print(town ?? "NULL")
            print("- area -")
            print(area ?? "NULL")
            print("- Fare -")
            print(fare ?? "NULL")
            print("- address -")
            print(result.addressDictionary ?? "NULL")
            print()

            var address: String? = nil
            if let name = result.addressDictionary?["Name"] as? String
            {

                address = name

            }
            else if let street = result.addressDictionary?["Street"] as? String
            {

                address = street

            }
            else if let fare = result.addressDictionary?["Thoroughfare"] as? String
            {

                address = fare + "\(result.addressDictionary?["SubThoroughfare"] ?? "")"

            }
            else if let lines = result.addressDictionary?["FormattedAddressLines"] as? [String], lines.count > 2
            {

                address = lines[0]
            }

            completion(address)

        }
        else
        {
            completion(nil)
        }
    }

}
