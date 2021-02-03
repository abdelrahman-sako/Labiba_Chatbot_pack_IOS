//
//  HelpExpandableView.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 2/1/21.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import UIKit
protocol HelpExpandableViewDelegate {
    func didSelectItem(atIndex index:Int)
}
class HelpExpandableView: UIView {

    
    static func create() -> HelpExpandableView{
        let view = Labiba.bundle.loadNibNamed("HelpExpandableView", owner: nil, options: nil)?.first as! HelpExpandableView
        return view
    }
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var collapseIcone: UIImageView!
    @IBOutlet weak var seperatorView: UIView!
    
    var delegate:HelpExpandableViewDelegate?
    override func awakeFromNib() {
        titleLbl.font = applyBotFont(size: 18)
        descLbl.font = applyBotFont(size: 15)
    }
    
    func resetIcone()  {
        if descLbl.text?.isEmpty ?? true {
            collapseIcone.image = Image(named: "ic_add")
        }else{
            collapseIcone.image = Image(named: "minus-sign")
        }
    }
    @IBAction func itemDidTap(_ sender: UIButton) {
        delegate?.didSelectItem(atIndex: self.tag)
    }
}
