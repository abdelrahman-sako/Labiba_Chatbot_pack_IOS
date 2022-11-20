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
       // topVC?.present(vc, animated: true, completion: nil)
        Labiba.navigationController?.pushViewController(vc, animated: true)
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
       
        getData() 

    }
    
    override func viewDidAppear(_ animated: Bool) {
        delegate?.SubViewDidAppear()
    }
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.subViewDidDisappear()
    }
    
    
    func UIConfiguration()  {
        // rest
        descTitleLbl.text = ""
        descLbl.text = "."
        
        discreptionContainerView.layer.cornerRadius = 20
        descTitleLbl.font = applyBotFont( bold: true, size: 20)
        descLbl.font = applyBotFont( size: 14)
        scrollView.delegate = self
        addScrollViewMask()
        scrollView.contentInset.top = 30
        DispatchQueue.main.async {
            self.view.applyHierarchicalSemantics()
        }
       
        
    }
    
    func getData()  {
        DataSource.shared.getHelpPageData { result in
            switch result {
            case .success(let model):
                self.descTitleLbl.text = model.Title ?? ""
                self.descLbl.attributedText = model.Description?.htmlAttributedString(regularFont: applyBotFont(size: 14), boldFont: applyBotFont(bold:true,size: 14), color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.7))
                self.descLbl.applyAlignmentAccordingToOnboardingLang()
                self.addItems(items: model.ExpandableItems ?? [])
            case .failure(let err):
                self.dismiss(animated: true) {
                    showErrorMessage(err.localizedDescription)
                }
            }
        }
//        LabibaRestfulBotConnector.shared.getHelpPageData { (result) in
//            switch result {
//            case .success(let model):
//                self.descTitleLbl.text = model.Title ?? ""
//                self.descLbl.attributedText = model.Description?.htmlAttributedString(regularFont: applyBotFont(size: 14), boldFont: applyBotFont(bold:true,size: 14), color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.7))
//                self.descLbl.applyAlignmentAccordingToOnboardingLang()
//                self.addItems(items: model.ExpandableItems ?? [])
//            case .failure(let err):
//                self.dismiss(animated: true) {
//                    showErrorMessage(err.localizedDescription)
//                }
//            }
//        }
    }
    
    func addScrollViewMask()  {
        maskImage = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 100)))
        
        maskImage.image = Image(named: ipadFactor == 0 ? "gradientMask-10":"gradientMask-7")
        scrollView.mask = maskImage
    }
    
    func addItems(items:[HelpPageModel.ExpandableItem])  {
        ItemViews.removeAll()
        for (index,item) in items.enumerated(){
            let view = HelpExpandableView.create()
            view.delegate = self
            view.tag = index
            let title = item.Title ?? ""
             let desc =  item.Description ?? ""
            view.titleLbl.attributedText = title.htmlAttributedString(regularFont: applyBotFont(size: 17), boldFont: applyBotFont(bold:true,size: 17), color: .white)
            descriptions.append(desc.htmlAttributedString(regularFont: applyBotFont(size: 14), boldFont: applyBotFont(bold:true,size: 14), color: UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)))
            if index == 0 {
                view.descLbl.attributedText = descriptions[0]
            }else{
                view.descLbl.text = ""
            }
            
            view.resetIcone()
            ItemViews.append(view)
            stackView.addArrangedSubview(view)
            view.applyHierarchicalSemantics()
        }
    }

    @IBAction func dismissAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
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
        ItemViews[index].descLbl.applyAlignmentAccordingToOnboardingLang()
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

