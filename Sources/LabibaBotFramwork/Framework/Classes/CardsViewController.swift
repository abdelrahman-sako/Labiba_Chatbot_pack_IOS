//
//  CardsViewController.swift
//  LabibaBotClient_Example
//
//  Created by Suhayb Ahmad on 8/13/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
//import Alamofire
//import AlamofireImage
//import Kingfisher
protocol CardsViewControllerDelegate : class {
    
    func cardsViewController(_ cardsVC:CardsViewController, didSelectCard card:DialogCard, ofDialog dialog:ConversationDialog) -> Void
    func HideCardsView() -> Void

}
protocol CardsViewHideDelegate : class {
    
    func HideCardsView() -> Void
}
class CardsViewController: UIViewController {
    
    class func present(forDialog dialog:ConversationDialog, andDelegate delegate:CardsViewControllerDelegate) -> Bool
    {
        guard let cards = dialog.cards,
            cards.presentation == .menu,
            cards.items.contains(where: { $0.buttons.contains(where: { $0.payload != nil }) }) else {
            return false
        }
        
        if let topVC = getTheMostTopViewController(),
            let cardsVC = Labiba.storyboard.instantiateViewController(withIdentifier: "cardsVC") as? CardsViewController
        {
            
            cardsVC.currentDialog = dialog
            cardsVC.delegate = delegate
            topVC.present(cardsVC, animated: true, completion: nil)
            return true
        }
        
        return false
    }
    
    weak var delegate:CardsViewControllerDelegate?
    
    static let cellIdentifier:String = "cardCell"
    
    fileprivate var currentDialog:ConversationDialog!
    fileprivate var cardsItems:[DialogCard]!

    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cardsItems = self.currentDialog.cards?.items
        self.container.applyDarkShadow(opacity: 0.3, offsetY: -3)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let tm:CGFloat = 150
        let maxHeight = self.view.frame.height - tm
        let cHeight = self.collectionView.contentSize.height + 50
        
        if cHeight < maxHeight {
            let dh = maxHeight - cHeight
            self.topConst.constant = tm + dh
        } else {
            
            self.topConst.constant = tm
        }
    }
    
    @IBAction func backgroundWasTapped(_ sender: Any)
    {
        self.currentDialog = nil
        self.delegate?.HideCardsView()
        self.dismiss(animated: true, completion: nil)
    }
}

extension CardsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w:CGFloat = (self.collectionView.frame.width - 4 * 6) / 3.0
        let h:CGFloat = 140.0
        
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.cardsItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellId = CardsViewController.cellIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CardViewCell
        
        let card = self.cardsItems[indexPath.item]
        
        cell.titleLabel.text = card.title
        print("imageurl: \(card.imageUrl ?? "no image")")
        if let image = card.image {
            if cell.cellImageView != nil { // Make sure the view exists

            if cell.cellImageView.isDescendant(of: cell) {
            cell.cellImageView.image = image
            }
            }
        } else if let imgPath = card.imageUrl, let imgUrl = URL(string: imgPath) {
            if cell.cellImageView != nil { // Make sure the view exists
                
                if cell.cellImageView.isDescendant(of: cell) {
                    
                    var size = cell.cellImageView.frame.size
                    size.width -= 20
                    size.height -= 20
                    
                    let filter = AspectScaledToFitSizeFilter(size: size)
                    cell.cellImageView.af_setImage(withURL: imgUrl, filter: filter) { (res) in
                        card.image = res.result.value
                    }
                    //                    cell.cellImageView.kf.setImage(with: imgUrl,completionHandler: { result in
                    //                        switch result {
                    //                        case .success(let image):
                    //                            card.image = image.image
                    //                        case .failure(let err):
                    //                            print("Error loading image for place: \(err.localizedDescription)")
                    //                        }
                    //                    })
                }}
        }else{
            if cell.cellImageView != nil { // Make sure the view exists
            if cell.cellImageView.isDescendant(of: cell) {
           cell.cellImageView.removeFromSuperview()
            }
            }
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        let card = self.cardsItems[indexPath.item]
//        
//        self.delegate?.cardsViewController(self, didSelectCard: card, ofDialog: self.currentDialog)
//        self.dismiss(animated: true, completion: nil)
//    }
}

