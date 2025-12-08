//
//  CustomCollectionViewCellNoImageNoImage.swift
//  DubaiPoliceBot
//
//  Created by Yehya Titi on 4/20/19.
//  Copyright © 2019 Yehya Titi. All rights reserved.
//

import Foundation
import UIKit

class CustomCollectionViewCellNoImage: UICollectionViewCell {
    
    @IBOutlet weak var cellNameLabel: UILabel!
    class var CustomCell : CustomCollectionViewCellNoImage
    {
        let cell = Bundle.main.loadNibNamed("CustomCollectionViewCellNoImage", owner: self, options: nil)?.last
        return cell as! CustomCollectionViewCellNoImage
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
        
    }
    
    func updateCellWithName(name:String)
    {
        self.cellNameLabel.text = name.replacingOccurrences(of: "MENU:", with: "")
    }
    
}
