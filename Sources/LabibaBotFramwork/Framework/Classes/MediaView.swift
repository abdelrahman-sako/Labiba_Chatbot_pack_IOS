//
//  MediaView.swift
//  LabibaClient
//
//  Created by AhmeDroid on 7/6/17.
//  Copyright © 2017 Imagine Technologies. All rights reserved.
//

import UIKit
import AVFoundation

class MediaView: MediaStreamer, ReusableComponent
{
    var created: Bool = false
    static var reuseId: String
    {
        return "media-view"
    }

    static func create<T>(frame: CGRect) -> T where T: UIView, T: ReusableComponent
    {

        let view = UIView.loadFromNibNamedFromDefaultBundle("MediaView") as! MediaView
        view.created = false
        view.frame = frame
        return view as! T
    }

    var playerLayer: AVPlayerLayer!
   
    override func awakeFromNib()
    {
        super.awakeFromNib()
        playerLayer = AVPlayerLayer()
        self.layer.insertSublayer(playerLayer, at: 0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.2
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        let topLimit:CGFloat = Labiba._OpenFromBubble ? 80 : -4
        NotificationCenter.default.addObserver(forName: Constants.NotificationNames.StopMedia, object: nil, queue: OperationQueue.main) { [weak self](notification) in
                self?.playerLayer.player?.pause()
                self?.playIcon.isHidden = false
        }
        
        NotificationCenter.default.addObserver(forName: Constants.NotificationNames.CheckMediaEndDisplaying, object: nil, queue: nil) { [weak self](notification) in
            let centerInTopView = self?.convert(self?.center ?? CGPoint(x: 0, y: 0), to: getTheMostTopView())
            
            if centerInTopView?.y ?? -5 < topLimit || centerInTopView?.y ?? 0 > (getTheMostTopView()?.frame.height) ?? 0 {
                self?.playerLayer.player?.pause()
                self?.playIcon.isHidden = false
            }
        }
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        playerLayer.frame = self.bounds
    }

    var currentVideoUrl: URL!

    override func streamMedia(ofURL url: URL) -> Void
    {

        self.currentVideoUrl = url

        let item = AVPlayerItem(url: url)
        NotificationCenter.default.addObserver(self,
                selector: #selector(playerDidFinishPlaying(note:)),
                name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                object: item)

        DispatchQueue.main.async
        {

            self.playerLayer.player?.pause()
            self.playerLayer.player?.seek(to: CMTime(seconds: 0, preferredTimescale: 100))

            print("Playing video: \(url.path)")

            self.playerLayer.player = AVPlayer(playerItem: item)
            self.player = self.playerLayer.player
            self.playMode()
            self.isFinised = false
        }
    }

    private var isFinised: Bool = false

    @objc func playerDidFinishPlaying(note: NSNotification)
    {
        replayMode()
        isFinised = true
        playIcon.isHidden = true
    }

    func replayMode() -> Void
    {
        playIcon.setImage(Image(named: "ic_replay_48pt"), for: .normal)
    }

    func playMode() -> Void
    {
        playIcon.setImage(Image(named: "ic_play_circle_filled_48pt"), for: .normal)
    }

    @IBOutlet weak var playIcon: UIButton!

    @IBAction func playPause(_ sender: Any)
    {
        let isPlayIconHidden = playIcon.isHidden // before post because it will always return false after post
      NotificationCenter.default.post(name: Constants.NotificationNames.StopMedia, object: nil)
        if isPlayIconHidden
        {

            playerLayer.player?.pause()
        }
        else
        {

            if isFinised
            {

                isFinised = false
                playMode()
                playerLayer.player?.seek(to: CMTime(seconds: 0, preferredTimescale: 100))
            }
            NotificationCenter.default.post(name: Constants.NotificationNames.StopSpeechToText, object: nil)
            NotificationCenter.default.post(name: Constants.NotificationNames.StopTextToSpeech, object: nil)
            playerLayer.player?.play()
        }

        playIcon.isHidden = !isPlayIconHidden
    }
    
    func openFullScreen()  {
        if let videoVC = Labiba.storyboard.instantiateViewController(withIdentifier: "videoVC") as? VideoPlayerViewController
               {
                   self.playerLayer.player?.pause()
                   self.playIcon.isHidden = false
                   videoVC.videoUrl = self.currentVideoUrl
                   videoVC.currentTime = playerLayer.player?.currentTime()
                   getTheMostTopViewController()!.present(videoVC, animated: true, completion: {})
               }
    }

    @IBAction func enterFullscreenMode(_ sender: Any)
    {
        openFullScreen()
       
//        NotificationCenter.default.post(name: Constants.NotificationNames.FullscreenVideoRequested,
//                object: nil,
//                userInfo: ["videoUrl": self.currentVideoUrl, "currentTime":playerLayer.player?.currentTime()] )
    }
    
    
}
