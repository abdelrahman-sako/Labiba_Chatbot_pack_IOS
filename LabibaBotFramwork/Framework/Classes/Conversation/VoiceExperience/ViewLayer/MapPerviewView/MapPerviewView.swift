//
//  MapPerviewView.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 7/28/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct  MapPreviewModel {
    var latitude:Double
    var longitude:Double
    var title:String
    var subtitle:String
}


class MapPerviewView: VoiceExperienceBaseView {
    
    
    class func create() -> MapPerviewView{
        let mapPerviewView = Labiba.bundle.loadNibNamed(String(describing: MapPerviewView.self), owner: nil, options: nil)![0] as! MapPerviewView
        return mapPerviewView
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var navigationBtn: UIButton!
    
    let radius: CLLocationDistance = 800
    var location :CLLocationCoordinate2D!
   // private var locationManager = CLLocationManager()
    
    override func awakeFromNib() {
        if #available(iOS 13.0, *) {
            mapView.overrideUserInterfaceStyle = .dark
        } else {
            // Fallback on earlier versions
        }
        
        mapView.delegate = self
      //  LocationService.shared.delegate = self
        LocationService.shared.updateLocation()
        
        containerView.layer.cornerRadius = Labiba.mapPrivewConfiguration.cornerRadius
        containerView.clipsToBounds = true
        
        titleLbl.textColor = Labiba.mapPrivewConfiguration.titleColor
        subtitleLbl.textColor = Labiba.mapPrivewConfiguration.subtitleColor
        titleLbl.font = applyBotFont( bold: true,size: 19)
        subtitleLbl.font = applyBotFont( bold: false,size: 17)
        navigationBtn.titleLabel?.font = applyBotFont( bold: false,size: 17)
        
        navigationBtn.layer.cornerRadius =  navigationBtn.frame.height/2
        let constraint = NSLayoutConstraint(item: mapView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 300)
        mapView.addConstraint(constraint)
        
        
    }
    

    
    func updateWithLocation(model:MapPreviewModel)  {
        titleLbl.text = model.title
        subtitleLbl.text = model.subtitle
        
        let currentLocationmarker = MKPointAnnotation()
        if let  currentLocation =  LocationService.shared.currentLocation {
            currentLocationmarker.coordinate = currentLocation
            self.mapView.addAnnotation(currentLocationmarker)
        }
        
        location = CLLocationCoordinate2D(latitude: model.latitude, longitude: model.longitude)
        
       
        self.mapView.region = MKCoordinateRegion(center: location, latitudinalMeters: radius * 2.0, longitudinalMeters: radius * 2.0)
        
        let marker = MKPointAnnotation()
        //        marker.title = "Loading ..."
        //        marker.subtitle = "zzLoading ..."
        marker.coordinate = location
        
        self.mapView.addAnnotation(marker)
        //  self.mapView.selectAnnotation(marker, animated: true)
        
      
    }
    
   
    
    override func startAnimation() {
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        self.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform.identity
            self.alpha = 1
        }, completion: nil)
    }
    
    override func removeWithAnimation() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: [], animations: {
            self.transform = CGAffineTransform(translationX: 0, y: -150)
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    
}


extension MapPerviewView:MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView()
        annotationView.annotation = annotation
        annotationView.image = Image(named: "radius-mark-icon")
        
          let scaleX: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
             scaleX.fromValue = 0.95
        scaleX.toValue = 1.2
             scaleX.duration = 1
             scaleX.autoreverses = true
             scaleX.repeatCount = Float.greatestFiniteMagnitude
        annotationView.layer.add(scaleX, forKey: "dsf")
        UIView.animate(withDuration: 1.5) {
            annotationView.transform = CGAffineTransform.identity
        }
        return annotationView
    }
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
//        polylineRenderer.strokeColor = UIColor.red
//        polylineRenderer.lineWidth = 5
//        return polylineRenderer
//    }
}


