//
//  HintsView.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 9/8/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import UIKit

class HintsView: UIView ,ReusableComponent{
     var created: Bool = false
    
    static var reuseId = "HintsView"
    weak var view: EntryViewCell!
    weak var display: EntryDisplay!
    var delegate:EntryTableViewCellDelegate?
    static func create<T>(frame: CGRect) -> T where T: UIView, T: ReusableComponent
    {
        
        let view = UIView.loadFromNibNamedFromDefaultBundle("HintsView") as! HintsView
        view.created = false
        view.frame = frame
        return view as! T
    }
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    func renderHintsView(display: EntryDisplay?, onView view: StateEntryCell) {
        self.view = view
        
        self.display = display
        let rect = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let hintsView:HintsView = view.dequeueReusableComponent(frame: rect)
        if !hintsView.created{
            hintsView.titleLabel.text = display?.dialog.guide?.title
            hintsView.titleLabel.font = applyBotFont(size: 15)
            var hight:CGFloat = 55 + ipadFactor*10
            for hint in display?.dialog.guide?.questions ?? []{
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: rect.width - 30, height: 20))
                label.textAlignment = .center
                label.textColor = .white
                label.numberOfLines = 0
                label.text = hint
                label.font = applyBotFont(size: 16)
                let bu = UIButton(frame: CGRect(x: 0, y: 0, width: rect.width - 30, height: 25))
                bu.titleLabel?.text = hint
                bu.autoresizingMask = [.flexibleWidth,.flexibleHeight]
                label.addSubview(bu)
                bu.addTarget(self, action: #selector(lableClicked), for: .touchUpInside)
                label.isUserInteractionEnabled = true
                label.sizeToFit()
                label.layoutIfNeeded()
                hight += label.frame.height
                hintsView.stackView.addArrangedSubview(label)
            }
            hight += CGFloat(hintsView.stackView.subviews.count - 1) * hintsView.stackView.spacing
            display?.height = hight
        }
        view.addSubview(hintsView)
        hintsView.created = true
    }
    
    
    @objc func lableClicked(_ sender:UIButton){
        let message = sender.titleLabel?.text?.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "")
        delegate?.hintWasSelectedFor(hint: message ?? "")
        
    }
    
}
