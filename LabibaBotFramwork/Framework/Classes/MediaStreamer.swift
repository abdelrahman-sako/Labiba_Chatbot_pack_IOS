//
//  MediaStreamer.swift
//  LabibaClient
//
//  Created by AhmeDroid on 7/6/17.
//  Copyright © 2017 Imagine Technologies. All rights reserved.
//

import UIKit
import AVFoundation

class MediaStreamer: UIView
{

    var timeObserver: Any?
    var player: AVPlayer?

    var currentUrl: URL!

    func setMedia(ofURL url: URL) -> Void
    {

        if self.currentUrl != nil && self.currentUrl == url
        {
            return
        }

        self.currentUrl = url
        self.streamMedia(ofURL: url)
    }

    func streamMedia(ofURL url: URL) -> Void
    {
    }

    func cancelMedia() -> Void
    { // ???????

        print("Cancel media: \(self)")
        player?.replaceCurrentItem(with: nil)
        player?.cancelPendingPrerolls()

        if self.timeObserver != nil
        {
            player?.removeTimeObserver(self.timeObserver!)
            self.timeObserver = nil
        }

        NotificationCenter.default.removeObserver(self)
        player?.removeObserver(self, forKeyPath: "status")
        player = nil
    }
}
