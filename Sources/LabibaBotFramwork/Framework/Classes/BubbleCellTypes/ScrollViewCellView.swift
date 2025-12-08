//
//  ScrollViewCellView.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 9/30/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import UIKit

class ScrollViewCellView: UIView  , ReusableComponent{
    static var reuseId: String = "scrollView"
    
    var created: Bool = false
    //weak var display: EntryDisplay!
   // var cardsViews = [SelectableCardView]()
    var buttonsContainer: UIScrollView!
    
    static func create<T>(frame: CGRect) -> T where T : UIView, T : ReusableComponent {
        let view = UIView.loadFromNibNamedFromDefaultBundle("ScrollViewCellView") as! ScrollViewCellView
        view.created = false
        view.frame = frame
        return view as! T
    }
    
 
    
    
  
//    @IBOutlet weak var scrollContainer: UIView!
    
//    func renderScrollViewCell(delegate:SelectableCardViewDelegate,display: EntryDisplay, onView view: EntryViewCell , cards: [DialogCard] ,firstTime:Bool = false, complitionHandler:(()->Void)? = nil)  {
//
//        let avatarWidth = Labiba._botAvatar == nil ? -5 : AvatarWidth
//        //let ty = self.botBubbleMaxY + 10
//        let dx = avatarWidth + 10
//
//        let cf = view.frame
//        let bcf = CGRect(x: LbLanguage.isArabic ? 0 : dx, y:3, width: cf.size.width - dx, height: 10)
//        //ScrollViewCellView.reuseId = display.id
//        let cell:ScrollViewCellView  = view.dequeueReusableComponent(frame: bcf)
//
//        if !cell.created {
//            cell.buttonsContainer = UIScrollView(frame: bcf)
//            cell.buttonsContainer.showsHorizontalScrollIndicator = false
//            cell.buttonsContainer.showsVerticalScrollIndicator = false
//            display.height = cell.buttonsContainer.frame.maxY
//
//            //
//            let (cardsViews, bcw) = createCardsViews(display: display, cards: cards)
//            /////
//            cell.cardsViews = cardsViews
//            /////
//            var bf = cell.buttonsContainer.frame
//            for card in cell.cardsViews{
//                if bf.size.height < card.frame.height{
//                    bf.size.height = card.frame.height + 15
//                }
//
//            }
//            cell.buttonsContainer.frame.size.height = bf.maxY
//            display.height = bf.maxY
//            cell.frame.size.height = bf.maxY
//            cell.buttonsContainer.contentSize = CGSize(width: bcw , height: bf.height)
//
//          //  var i: Double = 0
//            for cardView in cell.cardsViews
//            {
//                cell.buttonsContainer.addSubview(cardView)
//                cardView.delegate = delegate
////               // if firstTime {
////                    let p = LbLanguage.isArabic ? Double(cardsViews.count) - i - 1 : i
////                    let doRenderAvatars = (i == 0)
////
////                    cardView.transform = CGAffineTransform(translationX: 0, y: -10)
////                    UIView.animate(withDuration: 0.35, delay: 0.4 + 0.15 * p,
////                                   options: .curveEaseOut, animations: {
////
////                                    // cardView.alpha = 1
////                                    cardView.transform = CGAffineTransform.identity
////                    }, completion: { (finish) in
////
////                        if doRenderAvatars
////                        {
////                            view.renderAvatar()
////                        }
////                    })
////
////                    i += 1.0
////               // }
//            }
//
//            let w = cell.buttonsContainer.frame.width
//            let point = LbLanguage.isArabic ? CGPoint(x: bcw - w + ipadMargin, y: 0) : CGPoint(x: -ipadMargin, y: 0)
//            cell.buttonsContainer.setContentOffset(point, animated: false)
//            cell.buttonsContainer.contentInset = LbLanguage.isArabic ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: ipadMargin) : UIEdgeInsets(top: 0, left: ipadMargin, bottom: 0, right: 0)
//
//            cell.buttonsContainer.frame = cell.frame
//            cell.scrollContainer.addSubview(cell.buttonsContainer)
//            cell.created = true
//        }
//        //cell.buttonsContainer.layoutIfNeeded()
//
//        cell.frame.size.height = display.height
//        cell.layoutIfNeeded()
//        view.addSubview(cell)
//        complitionHandler?()
//    }
//
    
//    @discardableResult func createCardsViews(display: EntryDisplay, cards: [DialogCard]) -> ([SelectableCardView], CGFloat)
//    {
//
//        var tw: CGFloat = 10
//        var cardsViews = [SelectableCardView]()
//
//        for i in 0..<cards.count
//        {
//
//            let p = LbLanguage.isArabic ? cards.count - i - 1 : i
//            let cframe = CGRect(x: tw, y: 5.0, width: 180 +  ipadFactor*150, height: 245) // 245 doesn't mean anything
//
//            let cardView = SelectableCardView.create(frame: cframe)
//            cardView.displayCard(cards[p])
//
//            tw += cframe.width + 10
//            cardsViews.append(cardView)
//        }
//
//        return (cardsViews, tw)
//    }

}
