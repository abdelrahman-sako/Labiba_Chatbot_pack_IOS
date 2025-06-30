//
//  VMenuCell.swift
//  LabibaBotFramwork
//
//  Created by Osama Hasan on 10/05/2023.
//  Copyright © 2023 Abdul Rahman. All rights reserved.
//

import UIKit

class VMenuCell: UITableViewCell {
  
  @IBOutlet weak var trailingStackViewConst: NSLayoutConstraint!
  @IBOutlet weak var leadingStackViewConst: NSLayoutConstraint!
  @IBOutlet weak var stackView: UIStackView!
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
    
    stackView.semanticContentAttribute = Labiba.botLang == .en ? .forceLeftToRight : .forceRightToLeft
    menuContentLabel.semanticContentAttribute  = Labiba.botLang == .en ? .forceLeftToRight : .forceRightToLeft
    if let shadow = Labiba.vMenuTheme.shadow {
      contanierView.applyShadow(color: shadow.color,
                                opacity: shadow.opacity, offset: shadow.offset,radius: shadow.radius)
    }
  }
  
  
  func setData(model:DialogCard){
      var fontSize = 13.0
   
      fontSize = Labiba.BotChatBubble.fontsize
      let lang = model.title.detectedLangauge()
      if lang == "ar" {model.title.addArabicAlignment()}
      menuContentLabel.font = applyBotFont(textLang: LabibaLanguage(rawValue: lang ?? "") ?? .ar ,bold:true, size: fontSize )
      menuContentLabel.text = model.title.trimmingCharacters(in: .whitespacesAndNewlines)
    if let url = URL(string: model.imageUrl ?? ""){
      menuImageView.af_setImage(withURL: url)
      leadingStackViewConst.constant = 5
      trailingStackViewConst.constant = 5
        menuImageView.isHidden = false

    } else {
      menuImageView.isHidden = true
      leadingStackViewConst.constant = 20
      trailingStackViewConst.constant = 20
    }
    
    
  }
  
}
