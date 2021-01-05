//
//  CustomTableViewCell.swift
//  DubaiPoliceBot
//
//  Created by Yehya Titi on 4/20/19.
//  Copyright © 2019 Yehya Titi. All rights reserved.
//

import Foundation
import UIKit
//import SwiftyJSON

protocol CustomCollectionCellDelegate:class {
    func collectionView(dialogIndex: Int,selectedCardIndex: Int,selectedCellDialogCardButton:DialogCardButton?, didTappedInTableview TableCell:CustomTableViewCell)
    func finishedDisplayForDialog(dialog: ConversationDialog)
    //other delegate methods that you can define to perform action in viewcontroller
}

class CustomTableViewCell:UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var cellDelegate:CustomCollectionCellDelegate? //define delegate
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var CollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var CollectionViewWidth: NSLayoutConstraint!
    var myDialog: [String: JSON]?
    var SelectedDialogIndex:Int?
    var aDisplayedDialogs:EntryDisplay?
    let cellReuseId = "CollectionViewCell"
    let cellReuseIdNoImage = "CollectionViewCellNoImage"
    var isAnItemSelected:Bool = false
    var isFirstReloading:Bool = true
    class var customCell : CustomTableViewCell {
        let cell = Constants.mainBundle.loadNibNamed("CustomTableViewCell", owner: self, options: nil)?.last
        return cell as! CustomTableViewCell
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        //TODO: need to setup collection view flow layout

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 2.0 + 15*ipadFactor
        flowLayout.minimumInteritemSpacing = 5.0 + 15*ipadFactor
        self.myCollectionView.collectionViewLayout = flowLayout
        self.myCollectionView.isScrollEnabled = false
        //Comment if you set Datasource and delegate in .xib
        self.myCollectionView.dataSource = self
        self.myCollectionView.delegate = self
        
        //register the xib for collection view cell
        let cellNib = UINib(nibName: "CustomCollectionViewCell", bundle: Constants.mainBundle)
         let cellNibNoImage = UINib(nibName: "CustomCollectionViewCellNoImage", bundle: Constants.mainBundle)
        self.myCollectionView.register(cellNib, forCellWithReuseIdentifier: cellReuseId)
         self.myCollectionView.register(cellNibNoImage, forCellWithReuseIdentifier: cellReuseIdNoImage)
        self.myCollectionView.applySemanticAccordingToBotLang()
    }
    
    //MARK: Instance Methods
    func updateCellWith(selectedDialogIndex: Int,displayedDialogs:EntryDisplay)
    {
        self.SelectedDialogIndex = selectedDialogIndex
        self.aDisplayedDialogs = displayedDialogs
        let CellHeight = ((UIScreen.main.bounds.width / 3.0) ) * ceil(CGFloat((self.aDisplayedDialogs?.dialog.cards?.items.count)!) / 3.0)
        if self.aDisplayedDialogs?.dialog.cards?.items.count == 1 {
            self.backgroundColor = .clear
            //self.myCollectionView.isScrollEnabled = false
        }else{
//            self.backgroundColor = Labiba._MenuCardsCollectionColor ?? .clear
            self.backgroundColor = Labiba.MenuCardView.collectionColor
            //self.myCollectionView.isScrollEnabled = true
        }
        CollectionViewHeight.constant = CellHeight
        self.myCollectionView.reloadData()
        self.myCollectionView.layoutIfNeeded()
        guard let dialog = aDisplayedDialogs?.dialog else {
            return
        }
        self.cellDelegate?.finishedDisplayForDialog(dialog: dialog)
        isFirstReloading = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let categoryItems = self.aDisplayedDialogs?.dialog.cards?.items
        {
            return categoryItems.count
        }
        else
        {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let CellWidth = (UIScreen.main.bounds.width / 3) - (20 + ipadFactor*(ipadMargin - 17))
        return CGSize(width: CellWidth, height: CellWidth + 15 + ipadFactor*20)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if let categoryImageName = self.aDisplayedDialogs?.dialog.cards?.items[indexPath.item].imageUrl
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! CustomCollectionViewCell
            if let categoryImageName = self.aDisplayedDialogs?.dialog.cards?.items[indexPath.item].imageUrl
            {
                cell.updateCellWithImage(imageUrl: categoryImageName)
            }
            if let categoryName = self.aDisplayedDialogs?.dialog.cards?.items[indexPath.item].title
            {
                cell.updateCellWithName(name: categoryName)
            }
            let TapPress = UITapGestureRecognizer(target: self, action: #selector(CustomTableViewCell.handleTap))
            cell.addGestureRecognizer(TapPress)
            TapPress.cancelsTouchesInView = true
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 1)
            cell.layer.shadowRadius = 1.5
            cell.layer.shadowOpacity = 0.15
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
//            cell.cellNameLabel.textColor = Labiba._MenuCardText.color ?? UIColor(argb: 0x00936D)
//            cell.cellNameLabel.font = applyBotFont(size: Labiba._MenuCardText.fontSize)
//            cell.bacgroundView.backgroundColor = Labiba._MenuCardColor ?? .white
            
            cell.cellNameLabel.textColor = Labiba.MenuCardView.textColor
            cell.cellNameLabel.font = applyBotFont(size: Labiba.MenuCardView.fontSize)
            cell.bacgroundView.backgroundColor = Labiba.MenuCardView.backgroundColor
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdNoImage, for: indexPath) as! CustomCollectionViewCellNoImage
            
            if let categoryName = self.aDisplayedDialogs?.dialog.cards?.items[indexPath.item].title
            {
                cell.updateCellWithName(name: categoryName)
            }
            let TapPress = UITapGestureRecognizer(target: self, action: #selector(CustomTableViewCell.handleTap))
            cell.addGestureRecognizer(TapPress)
            TapPress.cancelsTouchesInView = true
            
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 1)
            cell.layer.shadowRadius = 1.5
            cell.layer.shadowOpacity = 0.15
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = false
//            cell.cellNameLabel.textColor = Labiba._MenuCardText.color ?? UIColor(argb: 0x00936D)
            cell.cellNameLabel.textColor = Labiba.MenuCardView.textColor
            if cell.cellNameLabel.text?.count == 1 {
//                cell.cellNameLabel.font = applyBotFont(bold: true, size: Labiba._MenuCardText.fontSize + 12)
                cell.cellNameLabel.font =  applyBotFont(bold: true, size: Labiba.MenuCardView.fontSize + 12)
            }else{
//                cell.cellNameLabel.font = applyBotFont( size: Labiba._MenuCardText.fontSize )
                cell.cellNameLabel.font = applyBotFont( size: Labiba.MenuCardView.fontSize )
            }
//            cell.backgroundColor = Labiba._MenuCardColor ?? .white
            cell.backgroundColor = Labiba.MenuCardView.backgroundColor
            return cell
        }
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        isAnItemSelected = true
//        if self.aDisplayedDialogs?.dialog.cards?.items[(indexPath.item)].buttons.count ?? 0 > 0 {
//        let SelectedCellDialogCardButton = self.aDisplayedDialogs?.dialog.cards?.items[(indexPath.item)].buttons[0]
//        self.cellDelegate?.collectionView(dialogIndex: SelectedDialogIndex! ,selectedCardIndex: indexPath.item ,selectedCellDialogCardButton: SelectedCellDialogCardButton, didTappedInTableview: self)
//        }
//    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer)
    {
        isAnItemSelected = true
        let p = gestureRecognizer.location(in: self.myCollectionView)
        guard let indexPath = self.myCollectionView.indexPathForItem(at: p) else{
            return
        }
        if self.aDisplayedDialogs?.dialog.cards?.items[(indexPath.item )].buttons.count ?? 0 > 0{
            let SelectedCellDialogCardButton = self.aDisplayedDialogs?.dialog.cards?.items[(indexPath.item )].buttons[0]
            self.cellDelegate?.collectionView(dialogIndex: SelectedDialogIndex! ,selectedCardIndex: indexPath.item,selectedCellDialogCardButton: SelectedCellDialogCardButton, didTappedInTableview: self)
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if self.aDisplayedDialogs?.dialog.cards?.items.count == 1{
           let CellWidth = (UIScreen.main.bounds.width / 3) - 20
            return UIEdgeInsets(top: 5, left: 10 + ipadFactor*(ipadMargin - 20), bottom: 18, right: 10 + ipadFactor*(ipadMargin - 20))

        }else{
            return UIEdgeInsets(top: 5, left: 25 + ipadFactor*(ipadMargin - 20) , bottom: 18, right: 25 + ipadFactor*(ipadMargin - 20))

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isFirstReloading {
            cell.alpha = 0
            cell.transform = CGAffineTransform(translationX: -15, y: 0)
            UIView.animate(withDuration: 0.25, delay: 0.4 + Double(indexPath.row)*0.04, options: [], animations: {
                cell.alpha = 1
                cell.transform = .identity
            }, completion: nil)
        }
    }
}
