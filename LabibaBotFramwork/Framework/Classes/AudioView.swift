//
//  AudioView.swift
//  LabibaClient
//
//  Created by AhmeDroid on 7/6/17.
//  Copyright © 2017 Imagine Technologies. All rights reserved.
//

import UIKit
import AVFoundation
//import NVActivityIndicatorView

class AudioView: MediaStreamer, ReusableComponent {
    var created:Bool = false
    static var reuseId: String {
        return "audio-view"
    }
    
    static func create<T>(frame: CGRect) -> T where T : UIView, T : ReusableComponent {
        
        let view = UIView.loadFromNibNamedFromDefaultBundle("AudioView") as! AudioView
        view.frame = frame
        view.created = false
        return view as! T
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var progressContainer: UIView!
    @IBOutlet weak var progressBar: UIView!
    
    private var audioPlayer:AVPlayer?
    @IBOutlet weak var playbackButton: UIButton!
    
    var loadingIndicator:NVActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.2
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false
        
        let pf = self.playbackButton.frame
        loadingIndicator = NVActivityIndicatorView(frame: pf)
        loadingIndicator.type = NVActivityIndicatorType.ballScale
        loadingIndicator.backgroundColor = playbackButton.backgroundColor
        loadingIndicator.padding = 3
        
        loadingIndicator.layer.cornerRadius = pf.height * 0.5
        loadingIndicator.layer.masksToBounds = false
    }
    
    var party:ConversationParty = .bot {
        
        didSet {
            
            self.loadingIndicator.frame = self.playbackButton.frame
            
            switch self.party {
                
            case .bot:
                
                self.loadingIndicator.color = BotBubbleColor
                self.loadingIndicator.backgroundColor = UserBubbleColor
                
                self.backgroundColor = BotBubbleColor
                self.playbackButton.tintColor = BotBubbleColor
                self.playbackButton.backgroundColor = UserBubbleColor
                self.progressBar.backgroundColor = UserBubbleColor
                self.progressContainer.backgroundColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
                self.timeLabel.backgroundColor = UserBubbleColor
                self.timeLabel.textColor = BotBubbleColor
                self.layer.shadowRadius = 1.0
                self.dateLabel.textColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
                
            case .user:
                
                self.loadingIndicator.color = UserBubbleColor
                self.loadingIndicator.backgroundColor = BotBubbleColor
                
                self.backgroundColor = UserBubbleColor
                self.playbackButton.tintColor = UserBubbleColor
                self.playbackButton.backgroundColor = BotBubbleColor
                self.progressBar.backgroundColor = BotBubbleColor
                self.progressContainer.backgroundColor = #colorLiteral(red: 0.7389355964, green: 0.7389355964, blue: 0.7389355964, alpha: 1)
                self.timeLabel.backgroundColor = BotBubbleColor
                self.timeLabel.textColor = UserBubbleColor
                self.layer.shadowRadius = 0.0
                self.dateLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
            }
        }
    }
    
    func showLoadingIndicator() -> Void {
        
        DispatchQueue.main.async {
            self.addSubview(self.loadingIndicator)
            self.loadingIndicator.startAnimating()
        }
    }
    
    
    func hideLoadingIndicator() -> Void {
        
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.removeFromSuperview()
        }
    }
    
    func setProgress(_ progress:CGFloat ) -> Void {
        
        DispatchQueue.main.async {
            
            var bnds = self.progressContainer.bounds
            bnds.size.width = progress.isNaN ? 0.0 : progress * bnds.width
            
            self.progressBar.frame = bnds
        }
    }
    
    override func streamMedia(ofURL url:URL) -> Void {
        
        isPlaying = false
        isFinised = false
        isReady = false
        
        let item = AVPlayerItem(url: url)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying(note:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: item)
        DispatchQueue.main.async {
            
            self.audioPlayer?.pause()
            self.audioPlayer?.seek(to: CMTime(seconds: 0, preferredTimescale: 100))
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "mm:ss"
            
            self.showLoadingIndicator()
            self.timeLabel.text = formatter.string(from: Date(timeIntervalSince1970: 0))
            self.setProgress( 0.0 )
            
            self.audioPlayer = AVPlayer(playerItem: item)
            self.audioPlayer?.addObserver(self, forKeyPath: "status",
                                          options: NSKeyValueObservingOptions.new,
                                          context: nil)
            
            self.audioPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 300),
                                                      queue: nil,
                                                      using:
                { [weak self] (time) in
                    
                    let date = Date(timeIntervalSince1970: time.seconds)
                    self?.timeLabel.text = formatter.string(from: date)
                    
                    let progress = CGFloat(time.seconds) / CGFloat(item.duration.seconds)
                    
                    self?.setProgress( progress )
            })
            
            self.player = self.audioPlayer
            self.playMode()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let player = audioPlayer, let key = keyPath, let obj = object as? AVPlayer, obj == player && key == "status" {
            
            switch player.status {
            case .readyToPlay, .failed:
                self.hideLoadingIndicator()
                isReady = true
                break
            default:
                break
            }
        }
    }
    
    private var isFinised:Bool = false
    private var isReady:Bool = false
    @objc func playerDidFinishPlaying(note: NSNotification) {
        replayMode()
        isFinised = true
        isPlaying = false
    }
    
    func replayMode() -> Void {
        playbackButton.setImage(Image(named: "ic_replay"), for: .normal)
    }
    
    func pauseMode() -> Void {
        self.isPlaying = true
        playbackButton.setImage(Image(named: "ic_pause"), for: .normal)
    }
    
    func playMode() -> Void {
        self.isPlaying = false
        playbackButton.setImage(Image(named: "ic_play_arrow"), for: .normal)
    }
    
    private var isPlaying:Bool = false
    @IBOutlet weak var timeLabel: UILabel!
    @IBAction func playPause(_ sender: Any) {
        
        if isPlaying {
            
            audioPlayer?.pause()
            playMode()
            
            isPlaying = false
        } else {
            
            if isFinised {
                audioPlayer?.seek(to: CMTime(seconds: 0, preferredTimescale: 100))
            }
            
            audioPlayer?.play()
            pauseMode()
            
            isPlaying = true
        }
    }
}

enum PlayingMode {
    case None
    case Pause
    case Play
}
