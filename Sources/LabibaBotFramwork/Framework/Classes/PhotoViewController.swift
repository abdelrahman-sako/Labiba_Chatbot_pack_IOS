//
//  PhotoViewController.swift
//  ImagineBot
//
//  Created by AhmeDroid on 10/24/16.
//  Copyright © 2016 Suhayb Al-Absi. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate
{

    @IBOutlet weak var imageContainer: UIScrollView!

    var currentImage: UIImage!

    var imageView: UIImageView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        if let image = self.currentImage
        {

            // Creates an image view with a test image
            self.imageView = UIImageView(image: image)
            self.imageView.backgroundColor = UIColor.black
            self.imageView.layer.magnificationFilter = CALayerContentsFilter.nearest

            // Add the imageview to the scrollview
            self.imageContainer.addSubview(self.imageView)

            // Sets the following flag so that auto layout is used correctly
            //self.imageContainer.translatesAutoresizingMaskIntoConstraints = false;
            //self.imageView.translatesAutoresizingMaskIntoConstraints = false;

            // Sets the image frame as the image size
            self.imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height);

            // Tell the scroll view the size of the contents
            self.imageContainer.contentSize = image.size;

            // Add doubleTap recognizer to the scrollView
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollViewDoubleTapped(recognizer:)))
            doubleTapRecognizer.numberOfTapsRequired = 2;
            doubleTapRecognizer.numberOfTouchesRequired = 1;
            self.imageContainer.addGestureRecognizer(doubleTapRecognizer)


            // Add two finger recognizer to the scrollView
            let twoFingerTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollViewTwoFingerTapped(recognizer:)))
            twoFingerTapRecognizer.numberOfTapsRequired = 1;
            twoFingerTapRecognizer.numberOfTouchesRequired = 2;
            self.imageContainer.addGestureRecognizer(twoFingerTapRecognizer)
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

        self.setupScales()
    }

    //
    // MARK - Scroll View scales setup and center
    //

    func setupScales() -> Void
    {

        // Set up the minimum & maximum zoom scales
        let scrollViewFrame = self.imageContainer.frame;
        let scaleWidth = scrollViewFrame.size.width / self.imageContainer.contentSize.width;
        let scaleHeight = scrollViewFrame.size.height / self.imageContainer.contentSize.height;
        let minScale = min(scaleWidth, scaleHeight);

        self.imageContainer.minimumZoomScale = minScale;
        self.imageContainer.maximumZoomScale = 1.0;
        self.imageContainer.zoomScale = minScale;

        self.centerScrollViewContents();
    }

    func centerScrollViewContents() -> Void
    {

        // This method centers the scroll view contents also used on did zoom
        let boundsSize = self.imageContainer.bounds.size;
        var contentsFrame = self.imageView.frame;

        if (contentsFrame.size.width < boundsSize.width)
        {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0;
        }
        else
        {
            contentsFrame.origin.x = 0.0;
        }

        if (contentsFrame.size.height < boundsSize.height)
        {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0;
        }
        else
        {
            contentsFrame.origin.y = 0.0;
        }

        self.imageView.frame = contentsFrame;
    }

    //
    // MARK - ScrollView Delegate methods
    //

    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {

        return self.imageView
    }


    func scrollViewDidZoom(_ scrollView: UIScrollView)
    {

        // The scroll view has zoomed, so we need to re-center the contents
        self.centerScrollViewContents();
    }

    //
    // MARK - ScrollView gesture methods
    //

    @objc private func scrollViewDoubleTapped(recognizer: UIGestureRecognizer) -> Void
    {

        // Get the location within the image view where we tapped
        let pointInView = recognizer.location(in: self.imageView)

        // Get a zoom scale that's zoomed in slightly, capped at the maximum zoom scale specified by the scroll view
        var newZoomScale = self.imageContainer.zoomScale * 1.5;
        newZoomScale = min(newZoomScale, self.imageContainer.maximumZoomScale);

        // Figure out the rect we want to zoom to, then zoom to it
        let scrollViewSize = self.imageContainer.bounds.size;

        let w = scrollViewSize.width / newZoomScale;
        let h = scrollViewSize.height / newZoomScale;
        let x = pointInView.x - (w / 2.0);
        let y = pointInView.y - (h / 2.0);

        let rectToZoomTo = CGRect(x: x, y: y, width: w, height: h);

        self.imageContainer.zoom(to: rectToZoomTo, animated: true)
    }

    @objc func scrollViewTwoFingerTapped(recognizer: UIGestureRecognizer) -> Void
    {

        // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
        var newZoomScale = self.imageContainer.zoomScale / 1.5;
        newZoomScale = max(newZoomScale, self.imageContainer.minimumZoomScale);
        self.imageContainer.setZoomScale(newZoomScale, animated: true)
    }

    // MARK - Rotation

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation)
    {

        self.imageContainer.contentSize = self.imageView.image!.size
        self.setupScales()
    }

    @IBAction func closeView(_ sender: AnyObject)
    {

        self.dismiss(animated: true, completion: {})
    }
}




