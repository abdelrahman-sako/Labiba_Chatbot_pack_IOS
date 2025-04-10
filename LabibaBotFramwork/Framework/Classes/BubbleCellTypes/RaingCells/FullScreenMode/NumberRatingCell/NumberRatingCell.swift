//
//  NumberRatingCell.swift
//  LabibaBotFramwork
//
//  Created by Osama Hasan on 06/04/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//

import UIKit

class NumberRatingCell: RatingCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var questionLabel: UILabel!
    
    var onSelected: ((Int) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = true
        
        let nib = UINib(nibName: "NumberItemCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "NumberItemCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension NumberRatingCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberItemCell", for: indexPath) as! NumberItemCell
        cell.numberLabel.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 10 - 8
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onSelected?(indexPath.row)
    }
    
}
