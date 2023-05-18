//
//  VMenuCell.swift
//  LabibaBotFramwork
//
//  Created by Osama Hasan on 10/05/2023.
//  Copyright © 2023 Abdul Rahman. All rights reserved.
//

import UIKit

class VMenuCell: UITableViewCell {

    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var contanierView: UIView!
    @IBOutlet weak var menuContentLabel: UILabel!
    @IBOutlet weak var menuImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupUI(){
        menuImageView.isHidden = Labiba.vMenuTheme.isImageHidden
        menuImageView.backgroundColor = Labiba.vMenuTheme.imageBackgroundColor
        menuImageView.tintColor  = Labiba.vMenuTheme.imageTintColor
        
        menuImageView.roundCorners(corners: Labiba.vMenuTheme.imageCornerTheme.corners,
                                   radius: Labiba.vMenuTheme.imageCornerTheme.radius)
        
        menuContentLabel.font = Labiba.vMenuTheme.contentLabelTheme.fontStyle
        menuContentLabel.textColor = Labiba.vMenuTheme.contentLabelTheme.textColor
        
        contanierView.layer.cornerRadius = 8
        
        if let shadow = Labiba.vMenuTheme.shadow {
            contanierView.applyShadow(color: shadow.color,
                                      opacity: shadow.opacity, offset: shadow.offset,radius: shadow.radius)
        }        
    }
    

    func setData(model:DialogCard){
        guard let url = URL(string: model.imageUrl ?? "") else {
            return
        }
        menuImageView.af_setImage(withURL: url)
        menuContentLabel.text = model.title
        
    }
    
}
