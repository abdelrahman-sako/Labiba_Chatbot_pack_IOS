//
//  GreetingHeaderView.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 9/9/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import UIKit
//import Kingfisher

public class GreetingHeaderView: LabibaChatHeaderView {

    public static func create(withAction:Bool = true,appLogoImgURl:String? = nil ,centerImageURL:String? = nil ,centerImage:UIImage? = nil  ,backgroundImgURL:String? = nil,backgroundImg:UIImage? = nil , bodyAndTitle:[String:String]) -> GreetingHeaderView
    {
        let view = UIView.loadFromNibNamedFromDefaultBundle("GreetingHeaderView") as! GreetingHeaderView
        if let imageURL = centerImageURL ,let url = URL(string: imageURL) {
            //view.centerImageView.kf.setImage(with: url)
            view.centerImageView.af_setImage(withURL: url)
        }else if let image = centerImage{
            view.centerImageView.image = image
        }
        view.labels = bodyAndTitle
        view.resetUIs()
        view.applySemanticAccordingToBotLang()
        if let url = URL(string: backgroundImgURL ?? "")  {
            view.backgroundImage.isHidden = false
            view.backgroundImage.backgroundColor = .darkGray
            //view.backgroundImage.kf.setImage(with: url)
            view.backgroundImage.af_setImage(withURL: url)
        }else if let image = backgroundImg{
            view.backgroundImage.isHidden = false
            view.backgroundImage.backgroundColor = .white
            view.backgroundImage.contentMode = .scaleAspectFill
            //view.backgroundImage.kf.setImage(with: url)
            view.backgroundImage.image = image
        }else
        {
            view.backGroundView.applyDynamicGradient(colors: Labiba._headerBackgroundGradient?.colors ?? [] , locations: Labiba._headerBackgroundGradient?.locations as [NSNumber]?, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
        }
        if withAction {
          view.appLogoContainer.isHidden = true
          view.closeBtContainer.isHidden = false
        }else{
            view.closeBtContainer.isHidden = true
            if let url = URL(string: appLogoImgURl ?? "") {
                //view.appLogo.kf.setImage(with: url)
                view.appLogo.af_setImage(withURL: url)
            }
        }
        view.muteButton.isHidden = Labiba.isMuteButtonHidden
        return view
    }

  
    
    

    
    @IBOutlet public weak var centerImageView: UIImageView!
    @IBOutlet public weak var centerImageTopCons: NSLayoutConstraint!
    @IBOutlet public weak var centerImageWidthCons: NSLayoutConstraint!
    @IBOutlet public weak var titleLbl: UILabel!
    @IBOutlet weak var bodyLbl: UILabel!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet public weak var homeButton: UIButton!
    @IBOutlet public weak var settingButton: UIButton!
    @IBOutlet public weak var vedioCallButton: UIButton!
    @IBOutlet weak var appLogoContainer: UIView!
    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet public weak var leftStack: UIStackView!
    @IBOutlet public weak var leftStackLeadingCons: NSLayoutConstraint!
    @IBOutlet public weak var leftStackTopCons: NSLayoutConstraint!
    @IBOutlet public weak var leftStackHightCons: NSLayoutConstraint!
    
    @IBOutlet public weak var rightStack: UIStackView!
    @IBOutlet public weak var righStackTrailingCons: NSLayoutConstraint!
    @IBOutlet public weak var righStackTopCons: NSLayoutConstraint!
    @IBOutlet public weak var righStackHightCons: NSLayoutConstraint!
    @IBOutlet weak var closeBtContainer: UIView!
    @IBOutlet public weak var muteButton: UIButton!
    
    var labels:[String:String] = [:]
    public var volumUpImage:UIImage? {
        didSet {
           muteButton.setImage(volumUpImage , for: .normal)
        }
    }
    public var volumOffImage:UIImage?
    public var titleColor:UIColor = .white{
        didSet{titleLbl.textColor = titleColor}
    }
    public var bodyColor:UIColor = .white{
           didSet{bodyLbl.textColor = bodyColor}
       }
    private var IsViewFliped:Bool = false
   
    
    public override func awakeFromNib() {
        homeButton.tintColor = Labiba._HeaderTintColor
        settingButton.tintColor = Labiba._HeaderTintColor
        closeButton.tintColor = Labiba._HeaderTintColor
        muteButton.tintColor =  Labiba._HeaderTintColor
         vedioCallButton.tintColor =  Labiba._HeaderTintColor
        vedioCallButton.imageView?.contentMode = .scaleAspectFit
    }
   
    
    override func  restartApplication(){
        resetUIs()
        super.restartApplication()
    }
    
    
    func resetUIs() {
        if IsViewFliped {
            self.backGroundView.applyReversedSemanticAccordingToBotLang()
            self.leftStack.applyReversedSemanticAccordingToBotLang()
            self.rightStack.applyReversedSemanticAccordingToBotLang()
        }else{
            self.backGroundView.applySemanticAccordingToBotLang()
            self.leftStack.applySemanticAccordingToBotLang()
            self.rightStack.applySemanticAccordingToBotLang()
        }
        
        switch SharedPreference.shared.botLangCode {
        case .ar:
            titleLbl.text = labels["ar_title"] ?? ""
            bodyLbl.text = labels["ar_body"] ?? ""
        case .en:
            titleLbl.text = labels["en_title"] ?? ""
            bodyLbl.text = labels["en_body"] ?? ""
        case .de:
            titleLbl.text = labels["de_title"] ?? ""
            bodyLbl.text = labels["de_body"] ?? ""
        case .ru:
            titleLbl.text = labels["ru_title"] ?? ""
            bodyLbl.text = labels["ru_body"] ?? ""
        case .zh:
            titleLbl.text = labels["zh_title"] ?? ""
            bodyLbl.text = labels["zh_body"] ?? ""
        }
        titleLbl.font = applyBotFont(bold: true ,size: 17)
        bodyLbl.font = applyBotFont( size: 15)
        layoutIfNeeded()
    }
    
    public func flibView()  {
        self.backGroundView.applyReversedSemanticAccordingToBotLang()
        self.leftStack.applyReversedSemanticAccordingToBotLang()
        self.rightStack.applyReversedSemanticAccordingToBotLang()
        self.IsViewFliped = true
    }
    
    public func setTintColor()  {
          self.backGroundView.applyReversedSemanticAccordingToBotLang()
    }
    
    
    public override func updateConstraints() {
        super.updateConstraints()
        self.applySemanticAccordingToBotLang()
    }

    @IBAction func muteAction(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            TextToSpeechManeger.Shared.setVolume(volume: 0.0)
            muteButton.setImage(volumOffImage ?? Image(named: "volume_off"), for: .normal)
        }else{
            sender.tag = 0
            TextToSpeechManeger.Shared.setVolume(volume: 1.0)
            muteButton.setImage(volumUpImage ?? Image(named: "volume_up"), for: .normal)
        }
        
    }
    @IBAction func homeAction(_ sender: Any) {
        homeButton.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {[weak self] (timer) in
            self?.homeButton.isEnabled = true
        }
        let message = "main menu".localForChosnLangCodeBB
        self.delegate?.labibaHeaderViewDidSubmitText?(message: message)
    }
    
    @IBAction func vedioCallAction(_ sender: Any) {
           vedioCallButton.isEnabled = false
           Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {[weak self] (timer) in
               self?.vedioCallButton.isEnabled = true
           }
           self.delegate?.labibaHeaderViewDidRequestVedioCallAction?()
       }
    
  
}
