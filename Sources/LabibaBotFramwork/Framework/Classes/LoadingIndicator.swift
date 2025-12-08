//
//  PhotoLoader.swift
//  LabibaClient_DL
//
//  Created by AhmeDroid on 9/24/17.
//  Copyright © 2017 Imagine Technologies. All rights reserved.
//

import UIKit
//import NVActivityIndicatorView

enum LoadingIndicatorMode
{
    case typing
    case uploading
}

class LoadingIndicator: UIView
{

    var indicator: NVActivityIndicatorView

    var mode: LoadingIndicatorMode = .typing
    {

        didSet
        {
            switch self.mode
            {
            case .typing:
                self.indicator.type = NVActivityIndicatorType.ballPulse
                self.indicator.color = UIColor.gray
                self.indicator.backgroundColor = BotBubbleColor
                self.backgroundColor = BotBubbleColor
            case .uploading:
                self.indicator.type = NVActivityIndicatorType.ballScaleMultiple
                self.indicator.color = UIColor.white
                self.indicator.backgroundColor = UserBubbleColor
                self.backgroundColor = UserBubbleColor
            }
        }
    }

    init(size: CGSize)
    {

        indicator = NVActivityIndicatorView(frame: CGRect(origin: CGPoint.zero, size: size))
        indicator.padding = 7.0
        indicator.layer.cornerRadius = 10
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        super.init(frame: CGRect(origin: CGPoint.zero, size: size))

        self.addSubview(indicator)

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.2
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false
    }

    required init?(coder aDecoder: NSCoder)
    {
        self.indicator = NVActivityIndicatorView(frame: CGRect.zero)
        super.init(coder: aDecoder)
    }

    override func layoutSubviews()
    {
        super.layoutSubviews()

        var f = self.indicator.frame
        f.origin.x = (self.frame.width - f.width) / 2.0
        f.origin.y = (self.frame.height - f.height) / 2.0

        self.indicator.frame = f
    }

    func start() -> Void
    {
        self.indicator.startAnimating()
    }

    func stop() -> Void
    {
        self.indicator.stopAnimating()
    }
}
