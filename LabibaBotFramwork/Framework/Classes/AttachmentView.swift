//
//  AttachmentView.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 9/21/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit

class AttachmentView: UIView, ReusableComponent {
    static var reuseId: String = "AttachmentView"
    
    var created: Bool = false
    
    static func create<T>(frame: CGRect) -> T where T : UIView, T : ReusableComponent {
        let view = UIView.loadFromNibNamedFromDefaultBundle("AttachmentView") as! AttachmentView
        view.created = false
        view.frame = frame
        return view as! T
    }
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    var url:String = ""
    override  func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOpacity = 3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        titleLbl.font = applyBotFont(size: 12)
        containerView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        imageView.tintColor = Labiba.attachmentThemeModel.card.tint
    }
    func startAnimation()  {
        DispatchQueue.main.async { [weak self] in
            self?.containerView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            UIView.animate(withDuration: 0.3) {
                self?.containerView.transform  = .identity
            }
        }
    }
   
    func update(with url:String) {
        self.url = url
         if let url = URL(string: url){
        self.titleLbl.text = url.lastPathComponent
        }
    }
    @IBAction func didClickCell(_ sender: UIButton) {
      if let url = URL(string: url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
