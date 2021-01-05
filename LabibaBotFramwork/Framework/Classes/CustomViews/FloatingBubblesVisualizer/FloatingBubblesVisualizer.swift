//
//  FloatingBubblesVisualizer.swift
//  BOJ_AnimatedCircularVisualizer
//
//  Created by Abdulrahman on 7/8/20.
//  Copyright © 2020 Imagine Technologies. All rights reserved.
//

import UIKit

class FloatingBubblesVisualizer: UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var shadowImg: UIImageView!
    @IBOutlet weak var firstBallImg: UIImageView!
    @IBOutlet weak var scondBallImg: UIImageView!
    @IBOutlet weak var thirdBallImg: UIImageView!
    
    var isAnimating:Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit()  {
        Labiba.bundle.loadNibNamed("FloatingBubblesVisualizer", owner: self, options: nil)
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
        logoImg.image = Image(named: "logo")
        shadowImg.image = Image(named: "shadow")
        firstBallImg.image = Image(named: "firstBall")
        scondBallImg.image = Image(named: "scondBall")
        thirdBallImg.image = Image(named: "thirdBall")
        
        shadowImg.alpha = 0
        firstBallImg.alpha = 0
        scondBallImg.alpha = 0
        thirdBallImg.alpha = 0
        
        TextToSpeechManeger.Shared.delegate = self
    }
    
    func startAnimation() {
        if isAnimating{ return}
        isAnimating = true
        rotation(view: shadowImg, duration: 15)
        wiggle(view: shadowImg, duration: 0.5)
        
        rotation(view: firstBallImg, duration: 12,revers: true)
        rotation(view: scondBallImg, duration: 24,revers: true)
        rotation(view: thirdBallImg, duration: 12,revers: true)
        
        shadowImg.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        firstBallImg.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        scondBallImg.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        thirdBallImg.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.shadowImg.alpha = 1
            self?.firstBallImg.alpha = 1
            self?.scondBallImg.alpha = 1
            self?.thirdBallImg.alpha = 1
            self?.shadowImg.transform = CGAffineTransform.identity
            self?.firstBallImg.transform = CGAffineTransform.identity
            self?.scondBallImg.transform = CGAffineTransform.identity
            self?.thirdBallImg.transform = CGAffineTransform.identity
        }
    }
    
    func stopAnimation(completionHandler:@escaping ()->Void)  {
      if !isAnimating{
        completionHandler()
        return
        
        }
        isAnimating = false
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.shadowImg.alpha = 0
            self?.firstBallImg.alpha = 0
            self?.scondBallImg.alpha = 0
            self?.thirdBallImg.alpha = 0
            self?.firstBallImg.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self?.scondBallImg.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self?.thirdBallImg.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }) { [weak self](_) in
            self?.shadowImg.layer.removeAllAnimations()
            self?.firstBallImg.layer.removeAllAnimations()
            self?.scondBallImg.layer.removeAllAnimations()
            self?.thirdBallImg.layer.removeAllAnimations()
            self?.firstBallImg.transform = CGAffineTransform.identity
            self?.scondBallImg.transform = CGAffineTransform.identity
            self?.thirdBallImg.transform = CGAffineTransform.identity
            completionHandler()
        }
    }
    
    
    
    private func rotation(view:UIView , duration:Double , revers:Bool = false)  {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = revers ? -(Double.pi * 2) : Double.pi * 2
        rotation.duration = duration
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        view.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    private func wiggle(view:UIView,duration:Double)  {
        let scaleX: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale.x")
        scaleX.fromValue = 0.95
        scaleX.toValue = 1
        scaleX.duration = duration
        scaleX.autoreverses = true
        scaleX.repeatCount = Float.greatestFiniteMagnitude
        let scaleY: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale.y")
        scaleY.fromValue = 0.95
        scaleY.toValue = 1
        scaleY.duration = duration
        scaleY.beginTime = CACurrentMediaTime() + duration/2
        scaleY.autoreverses = true
        scaleY.repeatCount = Float.greatestFiniteMagnitude
        
        view.layer.add(scaleX, forKey: "XscaleAnimation")
        view.layer.add(scaleY, forKey: "YscaleAnimation")
    }
    
    func pauseLayer(layer:CALayer)  {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0
        layer.timeOffset = pausedTime
    }
    
    func resumeLayer(layer:CALayer)  {
        let pausedTime:CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        
        let timeSincePause:CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    
}

extension FloatingBubblesVisualizer: TextToSpeechDelegate{
    func TextToSpeechDidStart() {
        DispatchQueue.main.async {
            print("TextToSpeechDidStart")
            self.startAnimation()
        }
        
    }
    
    func TextToSpeechDidStop() {
         DispatchQueue.main.async {
            print("TextToSpeechDidStop")
            self.stopAnimation(completionHandler: {})
        }
    }
    
    
}
