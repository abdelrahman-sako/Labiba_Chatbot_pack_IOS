//
//  HelpPopupVC.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 1/19/21.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import UIKit

class HelpPopupVC: UIViewController {

    class func present(){
        let vc = HelpPopupVC(nibName: "HelpPopupVC", bundle: Labiba.bundle)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        let topVC = getTheMostTopViewController() as? ConversationViewController
        vc.delegate = topVC
        topVC?.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var discreptionContainerView: UIView!
    @IBOutlet weak var descTitleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    var delegate:SubViewControllerDelegate?
    var maskImage:UIImageView!
    
    var ItemViews:[HelpExpandableView] = []
    var descriptions:[NSAttributedString] = []
    var selectedItemIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIConfiguration()
        addItems(items: ["d","","","","d","","",""])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delegate?.SubViewDidAppear()
    }
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.subViewDidDisappear()
    }
    func UIConfiguration()  {
        discreptionContainerView.layer.cornerRadius = 20
        descTitleLbl.font = applyBotFont( bold: true, size: 20)
        descLbl.font = applyBotFont( size: 14)
        scrollView.delegate = self
        addScrollViewMask()
        scrollView.contentInset.top = 30
        self.view.applyHierarchicalSemantics()
    }
    
    func addScrollViewMask()  {
        maskImage = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 100)))
        
        maskImage.image = Image(named: ipadFactor == 0 ? "gradientMask-10":"gradientMask-7")
        scrollView.mask = maskImage
    }
    
    func addItems(items:[String])  {
        ItemViews.removeAll()
        for i in items.indices{
            let view = HelpExpandableView.create()
            view.delegate = self
            view.tag = i
            let title = "Expandable title "
             let desc = "<h2>Expandable title</h2><br><p>Description here <i><ins>dfkjghdjghdksjfghksdfgjhkdjfhgddfkjgdfghsdkjgh</ins></i> d  ghjdfgkjsdh <mark>gdsgdg</mark> dgd ghdf gd ghjdjfghdjkfghdkj g h ghdkf ghdkjghdk gdkj g jkd <sub>gjkdhgk</sub> jdhgkjdhfgkjd fgkdj gkjd fgkd fgk dfg dkghdfkj </p> <dl> <dt>Flavio</dt> <dd>The name</dd> <dt>Copes</dt> <dd>The surname</dd></dl>"
            view.titleLbl.attributedText = title.htmlAttributedString(regularFont: applyBotFont(size: 17), boldFont: applyBotFont(bold:true,size: 17), color: .white)
            descriptions.append(desc.htmlAttributedString(regularFont: applyBotFont(size: 15), boldFont: applyBotFont(bold:true,size: 15), color: .white))
            if i == 0 {
                view.descLbl.attributedText = descriptions[0]
            }else{
                view.descLbl.text = ""
            }
            
            view.resetIcone()
            ItemViews.append(view)
            stackView.addArrangedSubview(view)
        }
    }

    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension HelpPopupVC:HelpExpandableViewDelegate {
    func didSelectItem(atIndex index: Int) {
        if index != selectedItemIndex {
            ItemViews[index].descLbl.attributedText = descriptions[index]
            ItemViews[selectedItemIndex].descLbl.text = ""
            
        }else {
            if  ItemViews[index].descLbl.text?.isEmpty ?? true {
                ItemViews[index].descLbl.attributedText = descriptions[index]
            }else{
                ItemViews[index].descLbl.text = ""
            }
        }
        ItemViews[index].resetIcone()
        ItemViews[selectedItemIndex].resetIcone()
        selectedItemIndex = index
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    
}
extension HelpPopupVC:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        maskImage.frame.origin.y = scrollView.contentOffset.y
    }
}

