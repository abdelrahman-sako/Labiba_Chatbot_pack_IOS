//
//  CustomCollectionViewCell.swift
//  DubaiPoliceBot
//
//  Created by Yehya Titi on 4/20/19.
//  Copyright © 2019 Yehya Titi. All rights reserved.
//

import Foundation
import UIKit
//import AlamofireImage
//import Alamofire
//import Kingfisher

class CustomCollectionViewCell: UICollectionViewCell {
    //private var imageLoadingTask: DataRequest?

    @IBOutlet weak var bacgroundView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellNameLabel: UILabel!
    
    var cellImageName:String?
    class var CustomCell : CustomCollectionViewCell
    {
        let cell = Bundle.main.loadNibNamed("CustomCollectionViewCell", owner: self, options: nil)?.last as! CustomCollectionViewCell
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowRadius = 1.5
        cell.layer.shadowOpacity = 0.15
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = false
        
        return cell //as! CustomCollectionViewCell
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
       // self.backgroundColor = UIColor.white
        
    }
    
    func updateCellWithImage(imageUrl:String)
    {
        guard let url = URL(string: imageUrl) else {
            return
        }
        //self.cellImageView.kf.setImage(with: url)
        self.cellImageView.af_setImage(withURL: url)
        
//        imageLoadingTask?.cancel()
//        imageLoadingTask = Alamofire.request(imageUrl).responseImage(completionHandler: { (response) in
//
//
//            if let image = response.result.value
//            {
//
//                self.cellImageView.image = image
//                DispatchQueue.main.async
//                    {
//                        self.cellImageView.image = image
//                    }
//
//            }
//            else if let err = response.result.error
//            {
//
//                print("Error loading image for place: \(err.localizedDescription)")
//            }
//        })

       // self.cellImageName = name
       // self.cellImageView.image = UIImage(named: name)
    }
    
    func updateCellWithName(name:String)
    {
        self.cellNameLabel.text = name.replacingOccurrences(of: "MENU:", with: "")
    }
    
}
