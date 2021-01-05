//
//  SSRadioButton.swift
//  SampleProject
//
//  Created by Shamas on 18/05/2015.
//  Copyright (c) 2015 Al Shamas Tufail. All rights reserved.
//  with circle stroke attribute

import Foundation
import UIKit
@IBDesignable

class SSRadioButton: UIButton {
    
    fileprivate var circleLayer = CAShapeLayer()
    fileprivate var fillCircleLayer = CAShapeLayer()
    fileprivate var isArabic = LbLanguage.isArabic
    override var isSelected: Bool {
        didSet {
            toggleButon()
        }
    }
    /**
     Color of the radio button circle. Default value is UIColor red.
     */
    @IBInspectable var circleColor: UIColor = UIColor.red {
        didSet {
            circleLayer.strokeColor = strokeColor.cgColor
            self.toggleButon()
        }
    }
    
    /**
     Color of the radio button stroke circle. Default value is UIColor red.
     */
    @IBInspectable var strokeColor: UIColor = UIColor.gray {
        didSet {
            circleLayer.strokeColor = strokeColor.cgColor
            self.toggleButon()
        }
    }
    
    /**
     Radius of RadioButton circle.
     */
    @IBInspectable var circleRadius: CGFloat = 5.0
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    fileprivate func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        circleFrame.origin.x +=  circleLayer.lineWidth 
        circleFrame.origin.y = bounds.height/2 - circleFrame.height/2
        return circleFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    fileprivate func initialize() {
        circleLayer.frame =  CGRect(x: isArabic ? bounds.width - (3*circleRadius ):circleRadius, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        circleLayer.lineWidth = 2
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = strokeColor.cgColor
        layer.addSublayer(circleLayer)
        fillCircleLayer.frame =  CGRect(x: isArabic ? bounds.width - (3*circleRadius ):circleRadius, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        fillCircleLayer.lineWidth = 2
        fillCircleLayer.fillColor = UIColor.clear.cgColor
        fillCircleLayer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(fillCircleLayer)
        self.titleEdgeInsets = isArabic ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (4*circleRadius + 4*circleLayer.lineWidth)) :UIEdgeInsets(top: 0, left: (4*circleRadius + 4*circleLayer.lineWidth), bottom: 0, right: 0)
        self.toggleButon()
    }
    /**
     Toggles selected state of the button.
     */
    func toggleButon() {
        if self.isSelected {
            fillCircleLayer.fillColor = circleColor.cgColor
            circleLayer.strokeColor = circleColor.cgColor
//            let animation = CABasicAnimation(keyPath: "transform.scale")
//              animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//              animation.fromValue = 1
//              animation.toValue = 0
//              animation.duration = 1
//              animation.fillMode = CAMediaTimingFillMode.forwards
//            fillCircleLayer.add(animation, forKey: nil)
              
        } else {
            fillCircleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.strokeColor = strokeColor.cgColor
//            let animation = CABasicAnimation(keyPath: "transform.scale")
//              animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//              animation.fromValue = 0
//              animation.toValue =  1
//              animation.duration = 1
//              animation.fillMode = CAMediaTimingFillMode.forwards
//            fillCircleLayer.add(animation, forKey: nil)
        }
    }
    
    fileprivate func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame())
    }
    
    fileprivate func fillCirclePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame().insetBy(dx: 2, dy: 2))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.frame = CGRect(x: isArabic ? bounds.width - (3*circleRadius ):circleRadius, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        circleLayer.path = circlePath().cgPath
        fillCircleLayer.frame = CGRect(x: isArabic ?  bounds.width - (3*circleRadius):circleRadius, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        fillCircleLayer.path = fillCirclePath().cgPath
         self.titleEdgeInsets = isArabic ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (4*circleRadius + 4*circleLayer.lineWidth)) :UIEdgeInsets(top: 0, left: (4*circleRadius + 4*circleLayer.lineWidth), bottom: 0, right: 0)
    }
    
    override func prepareForInterfaceBuilder() {
        initialize()
    }
}
