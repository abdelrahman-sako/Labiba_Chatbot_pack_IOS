//
//  VedioPlayerView.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 7/26/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit
import AVFoundation
class VedioPlayerView: VoiceExperienceBaseView {
    
    
    var mediaView:MediaView?
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size:CGSize,url:URL) {
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let w =  frame.width - 20//view.frame.width - BubbleMargin - AvatarWidth - 10 + 20
        let h = 0.75 * w
        let rect = CGRect(x: 10, y: 10, width: w, height: h)
        mediaView = MediaView.create(frame: rect)
        self.addSubview(mediaView!)
        addConstraint(frame:rect)
        addFullModeButton()
        
        //let url = URL(string: "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4")//URL(string: "https://botbuilder.labiba.ai/maker/files/c820530f-1c30-4494-8e2e-1eca0be775fb.mp4")
        mediaView?.streamMedia(ofURL: url)
        startAnimation()
     
    }
    
    
    func addConstraint(frame:CGRect) {
        mediaView?.translatesAutoresizingMaskIntoConstraints = false
        mediaView?.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        mediaView?.widthAnchor.constraint(equalToConstant: frame.height).isActive = true
        mediaView?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
        mediaView?.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        mediaView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        mediaView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
    }
    
    func addFullModeButton() {
        let button = UIButton(frame: self.frame)
        button.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        button.addTarget(self, action: #selector(enterFullMode), for: .touchUpInside)
        self.addSubview(button)
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
    
    @objc func enterFullMode() {
        NotificationCenter.default.post(name: Constants.NotificationNames.StopSpeechToText, object: nil)
        NotificationCenter.default.post(name: Constants.NotificationNames.StopTextToSpeech, object: nil)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
             mediaView?.openFullScreen()
        } catch {
            print(error)
        }
       
    }
}
