//
//  SplashScreenVC.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 8/8/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import UIKit

public class SplashVC :UIViewController{
    public class func create() -> UIViewController{return UIViewController()}
}

public class SplashScreenVC: SplashVC {

    @IBOutlet var startButtons: [UIButton]!
    @IBOutlet weak var idContainerView: UIView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var arRateLbl: UILabel!
    @IBOutlet weak var arSlider: UISlider!
    @IBOutlet weak var enRateLbl: UILabel!
     @IBOutlet weak var enSlider: UISlider!
    
    public override static func create() -> SplashScreenVC
    {
        return Labiba.splashStoryboard.instantiateViewController(withIdentifier: "SplashScreenVC") as! SplashScreenVC
    }
    
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.isNavigationBarHidden = true
        drawItineraryGradientOverlay(self.view, colors: Labiba.labibaThemes.default_Gradient_Animation_Colors)
        idContainerView.layer.cornerRadius = idContainerView.frame.height/2
        idContainerView.layer.borderWidth = 1.5
        idContainerView.layer.borderColor = UIColor.white.cgColor
        startButtons.forEach { (button) in
            button.layer.cornerRadius = button.frame.height/2
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor.white.cgColor
        }
        
       
        //idTextField.text = "9157be5d-7e1f-4a17-a3a6-78900d03daa8" 
         //idTextField.text = "72ac7d95-6a55-4d57-aaed-326c9fe42927" // voice assistant
        //idTextField.text = "d1a1fd87-4459-46a9-a34b-aa6546bb6a15" // email ,map
       // idTextField.text = "6872d977-47de-4d49-a6b6-146e828ea56d" // vedio and gif
       // idTextField.text = "af12d6b2-1bc1-4daa-8fe4-147a5bab1efa" // Looping and non looping dynamic GIF
       // idTextField.text = "3cc0cf66-16d4-4ca6-8751-55040e86d5ff" // test user params
       //  idTextField.text = "b474192c-a618-4c49-a5ee-663414fd75e5"
       //idTextField.text = "22b06f22-2077-44d6-9dbe-e45b9791e11f"
       //idTextField.text = "9d1b0690-a651-49c4-b5dc-a27a97725325" // BSF
      // idTextField.text = "d0b8e34a-26ba-4ed6-a2af-4412b55ef442" // natHealth
       // idTextField.text = "9ccaab56-12c1-401c-a3df-beddf3845349"  // IA
      //  idTextField.text = "e5f08da0-a645-4ff5-b01f-091e3a1df7ea"
        // idTextField.text =  "ef29c433-ce70-44f5-a9ae-9bbf025d2a4f"
//    idTextField.text = "07d02955-061e-4298-85a2-19689c6b7a0e"
  //  idTextField.text =  "18993db8-3776-4af1-9fd6-68cf8a9687aa" // absher
      // idTextField.text = "39d7cb60-c072-45ad-b21e-6530c2104e9f" // solidarty
        // idTextField.text = "837ecc70-a39e-4553-9fd1-3fc3a5544e6e" // solidarty
        
     //  idTextField.text = "b0fa08bc-224a-4775-81d0-86b14bd126fd"  // noon
       // idTextField.text = "ffa85efe-10e3-4bfc-9d20-e665ce6a1b81"
       // idTextField.text = "9769aa9c-ddf3-43b9-a330-112e57a429e9" 
        
        
        
        
        
    }
    override public func viewWillAppear(_ animated: Bool) {
          Labiba.setStatusBarColor(color: .clear )
        NotificationCenter.default.post(name: Constants.NotificationNames.StopTextToSpeech,
                                        object: nil)
    }
//    override func viewDidAppear(_ animated: Bool) {
//        let id =  idTextField.text ?? ""
//        Labiba.initialize(RecipientIdAR: id,RecipientIdEng: id,SelectedLanguage: 1, botName: "DUBAI POLICE".local)
//        LabibaThemes.setLabibaTheme()
//
//    }
    
    @IBAction func arSliderAction(_ sender: UISlider) {
        arRateLbl.text = "\(sender.value)"
        
    }
    @IBAction func enSliderAction(_ sender: UISlider) {
         enRateLbl.text = "\(sender.value)"
    }
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func start(_ sender: UIButton) {
        let id =  idTextField.text ?? ""
        Labiba.initialize(RecipientIdAR: id,RecipientIdEng: id )
//        Labiba.setRefreshToken(refreshtoken: "resfresh")// this must call befor setUserParams untile pushViewController
        Labiba.setUserParams(first_name: "Abed", last_name: "Qasem", profile_pic: "test", gender: "male", location: "3.33343344,39.444322211", country: "jordan", username: "abed", email: "aaa@gmail.com", token: "wdwdwdw3893389hc83uchbc8kocjncj990")
        LabibaThemes.setLabibaTheme()
        Labiba.setBotLanguage(LangCode: sender.tag == 0 ? .ar : .en)
    Labiba.setVoiceAssistanteRate(ARrate: arSlider.value, ENRate: enSlider.value)
        Labiba.startConversation(onView: self)
       // self.navigationController?.pushViewController(Labiba.createConversation(), animated: true)
    }
    
    @IBAction func showBubble(_ sender: Any) {
          Labiba.showMovableAlias(corner: .bottomRight, animated: true)
    }
    

}
