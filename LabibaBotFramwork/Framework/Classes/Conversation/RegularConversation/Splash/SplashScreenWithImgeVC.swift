//
//  SplashScreenWithImgeVC.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 9/9/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import UIKit
//import Gifu
//import Alamofire
//import Kingfisher
public class SplashScreenWithImgeVC: SplashVC {
 
    
    @IBOutlet weak var gifContainerView: UIView!
    @IBOutlet  var startButtons: [UIButton]!
    @IBOutlet weak var imageLeadingCons: NSLayoutConstraint!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var footerImage: UIImageView!
    
    var animatedGIF:GIFImageView = GIFImageView(frame: .zero)
    var animatedGIFView:GifView = GifView(frame: .zero)
    var id:String = ""
    //
    var langCode:Language = SharedPreference.shared.botLangCode // this for nathealth untill arabic designe become available
    //
    public override static func create() -> SplashScreenWithImgeVC
    {
        return Labiba.splashStoryboard.instantiateViewController(withIdentifier: "SplashScreenWithImgeVC") as! SplashScreenWithImgeVC
    }
    
    //https://botbuilder.labiba.ai/maker/files/bd7dfb5a-1512-4821-bdf6-c7b397309cb2.png // header
    //https://botbuilder.labiba.ai/maker/files/9aea174c-6eb0-4e92-aba7-3ab313cac1f5.png // footer
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.isNavigationBarHidden = true
        Labiba.setFont(regAR: "TheSans-Plain", boldAR: "TheSans-Bold", regEN: "AvantGarde-Medium", boldEN: "AvantGarde-Bold")
        let gTColor2 = UIColor(argb: 0xff5488B8)
        let gEColor2 = UIColor(argb: 0xff6FC1EB)
        self.view.applyGradient(colours: [gTColor2,gEColor2 ], locations: nil)
        startButtons.forEach { (button) in
            button.layer.cornerRadius = button.frame.height/2
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor.white.cgColor
            if button.tag == 0 {
                button.titleLabel?.font = applyBotFont(textLang: .ar, size: 15)
            }else{
                button.titleLabel?.font = applyBotFont(textLang: .en, size: 14)
            }
        }
        
 
        headerImage.image = UIImage(named: "Header")
        footerImage.image = UIImage(named: "footer")
        
        
        switch UIScreen.current {
        case .iPhone5_5: // +
            imageLeadingCons.constant = 120
        case .iPhone4_0: //5,5s,
            imageLeadingCons.constant = 85
        case .iPhone5_8 ,.iPhone6_1  : //x
            imageLeadingCons.constant = 100
        case .iPhone6_5:
            imageLeadingCons.constant = 110
        case .ipad ,.iPad12_9:
            imageLeadingCons.constant = 215
        case .iPad10_5:
            imageLeadingCons.constant = 190
        case .iPad9_7  :
            imageLeadingCons.constant = 170
        default:
            break
        }
        self.view.applySemanticAccordingToBotLang()
        let currentLang = SharedPreference.shared.botLangCode
      
            let urlString = currentLang == .en ? "https://botbuilder.labiba.ai/maker/files/a8e04078-79ca-4fd3-8d51-0c37a10b6852.gif":"https://botbuilder.labiba.ai/maker/files/ee3b85d1-9692-427f-b8e0-ce977041b6c6.gif"
        self.gifContainerView.addSubview(animatedGIFView)
        animatedGIFView.frame = gifContainerView.bounds
        animatedGIFView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        animatedGIFView.contentMode = .scaleAspectFit
            if let url = URL(string: urlString) {
                FileManager.default.pathOnDocumentDirectory(lastPathComponent: url.lastPathComponent, success: { (localPath) in
                 //   self.imageView.animate(withGIFURL: localPath)
                    self.animatedGIFView.initGifWithURL(localPath.absoluteString)
                    
                }, fauiler: {})
                
                _  =  request(url).responseData(completionHandler: { (response) in
                    if let error = response.result.error
                    {
                        print("Error  while loading dynamic gif , error (\(error.localizedDescription))")
                        
                    }else if let data = response.result.value
                    {
                        _ =  data.saveToDocumentDirectory(lastPathComponent: url.lastPathComponent)
                        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                            return
                        }
                       // self.animatedGIF.animate(withGIFURL: URL(string: directory.absoluteString! + url.lastPathComponent)!)
                        self.animatedGIFView.initGifWithURL(directory.absoluteString! + url.lastPathComponent)
                        
                    }
                    
                })
            }
      //  }
       //
      //  SharedPreference.shared.botLangCode = langCode // this for nathealth untill arabic designe become available
        //
        if  SharedPreference.shared.currentUserId != "" {
            buttonsStackView.isHidden = true
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {[weak self] (t) in
                self?.startConversation(langCode: SharedPreference.shared.botLangCode )
            }
           
        }
    }
    
 
        
       //id  = "d0b8e34a-26ba-4ed6-a2af-4412b55ef442" // natHealth
        
        
        
   
    

    
    override public func viewWillAppear(_ animated: Bool) {
      //  UIApplication.statusBarBackgroundColor = .clear
        NotificationCenter.default.post(name: Constants.NotificationNames.StopTextToSpeech,
                                        object: nil)
     
    }
    override public func viewDidAppear(_ animated: Bool) {
       LabibaThemes.setNatHealth_Theme()
       // Labiba.initialize(RecipientIdAR: id,RecipientIdEng: id)
        
        
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    
    func startConversation( langCode:Language)  {
        //Labiba.initialize(RecipientIdAR: "d0b8e34a-26ba-4ed6-a2af-4412b55ef442",RecipientIdEng: "f52d9469-df4b-4e8b-adaa-e46047636b48" ,language:langCode )
        Labiba.initialize(RecipientIdAR: "73b2c037-a112-460f-975b-c2d7412c0b7f",RecipientIdEng: "69bda09a-b448-4866-b327-2bbd0f3ac5e6" ,language:langCode )//test
        LabibaThemes.setNatHealth_Theme()
        self.navigationController?.pushViewController(ConversationViewController.create(), animated: true )
      // self.navigationController?.pushViewController(Labiba.createVoiceExperienceConversation(), animated: true )
    }
    
    
    @IBAction func start(_ sender: UIButton) {
        let langCode:Language = sender.tag == 0 ? .ar : .en
        startConversation( langCode:langCode)
    }
    
    @IBAction func pop(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
