//
//  MapView.swift
//  LabibaClient
//
//  Created by AhmeDroid on 7/4/17.
//  Copyright © 2017 Imagine Technologies. All rights reserved.
//

import UIKit
import MapKit
//import NVActivityIndicatorView

func captureMapSnapshot(location: CLLocationCoordinate2D, size: CGSize, completion: @escaping (UIImage?) -> Void)
{
    DispatchQueue.main.async
    {
        let mapView = MKMapView(frame: CGRect(origin: .zero, size: size))
        let radius: CLLocationDistance = 200
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -33.6, longitude: 151.20),
            latitudinalMeters: radius * 2.0, longitudinalMeters: radius * 2.0)

        mapView.region = region
        let point = MKPointAnnotation()
        point.coordinate = location
        mapView.addAnnotation(point)
        mapView.setCenter(location, animated: false)

        DispatchQueue.global(qos: .background).async {

            let options = MKMapSnapshotter.Options()
            options.region = mapView.region
            options.scale = UIScreen.main.scale
            options.size = size

            let shotter = MKMapSnapshotter(options: options)
            shotter.start
            { (snap, error) in

                guard let snapshot = snap
                else
                {
                    print("Failed to capture map image: \(error!.localizedDescription)")
                    completion(nil)
                    return
                }

                let pin = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
                pin.isSelected = true

                let image = snapshot.image

                UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)

                image.draw(at: CGPoint.zero)

                let visibleRect = CGRect(origin: CGPoint.zero, size: image.size)
                for annotation in mapView.annotations
                {

                    var point = snapshot.point(for: annotation.coordinate)

                    if visibleRect.contains(point)
                    {

                        point.x = point.x + pin.centerOffset.x - (pin.bounds.size.width / 2)
                        point.y = point.y + pin.centerOffset.y - (pin.bounds.size.height / 2)
                        pin.image?.draw(at: point)
                    }
                }

                let compositeImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                DispatchQueue.main.async
                {

                    completion(compositeImage)
                }
            }
        }
    }
}

class MapView: UIView, MKMapViewDelegate, ReusableComponent
{
    static var reuseId: String = "map-view"
     var created: Bool = false
    static func create<T>(frame: CGRect) -> T where T: UIView, T: ReusableComponent
    {
        
        let view = UIView.loadFromNibNamedFromDefaultBundle("MapView") as! MapView
        view.created = false
        view.frame = frame
        return view as! T
    }

    @IBOutlet weak var view_gradinet: UIView!
    @IBOutlet weak var lbl_distance: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var imageView: UIImageView!

    var indicator: NVActivityIndicatorView!

    func startIndicator() -> Void
    {

        var inf = self.indicator.frame
        inf.origin = CGPoint(x: self.bounds.midX - 20, y: self.bounds.midY - 20)

        self.indicator.frame = inf
        self.indicator.isHidden = false
        self.indicator.startAnimating()
    }

    func stopIndicator() -> Void
    {

        self.indicator.isHidden = true
        self.indicator.stopAnimating()
    }

    override func awakeFromNib()
    {
        super.awakeFromNib()

        indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.type = NVActivityIndicatorType.ballSpinFadeLoader
        indicator.color = UIColor.lightGray
        indicator.backgroundColor = UIColor.white
        indicator.padding = 5.0
        indicator.isHidden = true

        self.addSubview(indicator)

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.2
        self.layer.cornerRadius = Labiba._MapViewCornerRadius
        self.layer.masksToBounds = true

        self.imageView.layer.cornerRadius = 10
        self.imageView.layer.masksToBounds = true
//        let colors = UIColor(rgb: 0x3BB375)
//        let colors2 = UIColor(rgb: 0x289D72)
        //  view_gradinet.applyGradient(colours: [colors,colors2], locations: [0,1])
    }

    @IBAction func viewWasTapped(_ sender: Any)
    {

//        LocationViewController.present(onView: getTheMostTopViewController(),
//                withLocation: self.currentCoords)
      _ = LocationService.shared.openGoogleMapAppUsingLocation(placeName: nil, self.currentCoords)

    }

    var currentCoords = CLLocationCoordinate2D(latitude: 0, longitude: 0)

    func showMap(_ map: DialogMap) -> Void
    {

        self.currentCoords = map.coordinates
        //var currentLocation:CLLocationCoordinate2D!
        if map.snapshot != nil
        {
            self.imageView.image = map.snapshot
            /////////////////
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: self.currentCoords.latitude, longitude: self.currentCoords.longitude)

            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

                // Place details
                var placeMark: CLPlacemark?
                if placemarks?.count ?? 0 > 0 { placeMark = placemarks?[0] }
                // Location name
                var address = ""
                if let country = placeMark?.country
                {
                    address = address + "\(country)"
                    print(country)
                }

                if let street = placeMark?.thoroughfare
                {
                    address = address + " " + "\(street)"
                    print(street)
                }

                self.lbl_address.text = address
            })

            //let distance = calculateDistance(loc1: LocationService.shared.certainLocation, loc2: self.currentCoords)
            self.lbl_distance.text = map.distance != "" ? (map.distance ?? "") + "km".local : ""
            //////////////////

            return
        }

        self.startIndicator()
        captureMapSnapshot(location: map.coordinates, size: self.frame.size)
        { (image) in

            self.stopIndicator()

            map.snapshot = image

//            let loc2 = CLLocation(latitude: self.currentCoords.latitude, longitude: self.currentCoords.longitude)
//            let loc1 = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)

            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: self.currentCoords.latitude, longitude: self.currentCoords.longitude)

            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

                // Place details
                var placeMark: CLPlacemark?
                if placemarks?.count ?? 0 > 0 { placeMark = placemarks?[0] }
               // placeMark = placemarks?[0]

                // Address dictionary
                var address = ""
                if let country = placeMark?.country
                {
                    address = address + "\(country)"
                    print(country)
                }

                if let street = placeMark?.thoroughfare
                {
                    address = address + " " + "\(street)"
                    print(street)
                }

                if let locationName = placeMark?.name
                {
                    address = address + " " + "\(locationName)"
                    print(locationName)
                }
                self.lbl_address.text = address

            })

            //let distance = calculateDistance(loc1: LocationService.shared.certainLocation, loc2: self.currentCoords)
            self.lbl_distance.text = map.distance != "" ? (map.distance ?? "") + "km".local : ""//"\( (distance / 1000).formatted(0)! ) \( "km".local ) "
            self.imageView.image = image
        }
    }
}
