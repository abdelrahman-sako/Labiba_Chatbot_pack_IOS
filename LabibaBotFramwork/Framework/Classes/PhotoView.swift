//
//  PhotoView.swift
//  ImagineBot
//
//  Created by AhmeDroid on 10/24/16.
//  Copyright © 2016 Suhayb Al-Absi. All rights reserved.
//

import UIKit

class PhotoView: UIView, ReusableComponent
{
    var created: Bool = false
    static var reuseId: String = "photo-view"

    static func create<T>(frame: CGRect) -> T where T: UIView, T: ReusableComponent
    {
        
        let view = UIView.loadFromNibNamedFromDefaultBundle("PhotoView") as! PhotoView
        view.frame = frame
        view.created = false
        view.layer.cornerRadius = 10 + ipadFactor*20
        return view as! T
    }

    @IBOutlet weak var imageView: UIImageView!

    private weak var currentImage: UIImage!

    func showPhoto(image: UIImage) -> Void
    {

        DispatchQueue.main.async
        {

            self.imageView.image = nil //Don't remove this line - its written to reactivate Gif animation
            self.currentImage = image
            self.imageView.image = image
        }
    }

    @IBAction func photoWasTapped(_ sender: AnyObject)
    {
        
        let topVC = getTheMostTopViewController()
        let storyboard = Labiba.storyboard//topVC?.storyboard
        
        if let photoVC = storyboard.instantiateViewController(withIdentifier: "photoVC") as? PhotoViewController
        {
            photoVC.currentImage = self.currentImage
           // photoVC.modalPresentationStyle = .fullScreen
            topVC?.present(photoVC, animated: true, completion: {})
        }
    }

}
