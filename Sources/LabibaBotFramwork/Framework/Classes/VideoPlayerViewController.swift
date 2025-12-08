//
//  VideoPlayerViewController.swift
//  LabibaClient_DL
//
//  Created by AhmeDroid on 9/24/17.
//  Copyright © 2017 Imagine Technologies. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoPlayerViewController: AVPlayerViewController
{

    var videoUrl: URL?
    var currentTime:CMTime?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.showsPlaybackControls = true

        if let url = self.videoUrl
        {

            self.player = AVPlayer(url: url)
            if currentTime != nil {
                self.player?.seek(to: currentTime!)
            }
            self.player?.pause()
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.player?.play()
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.player?.pause()
    }
}
