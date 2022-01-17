//
//  PresentationVC.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 01/11/2021.
//  Copyright © 2021 Abdul Rahman. All rights reserved.
//

import UIKit

class PresentationVC:  BaseConversationVC{
    
    
    
    public static func create() -> PresentationVC
    {
        return Labiba.voiceExperienceStoryboard.instantiateViewController(withIdentifier: "PresentationVC") as! PresentationVC
    }
    
  //  var closeHandler:Labiba.ConversationCloseHandler?
    var voiceAssistantView = VoiceAssistantView.create()
    private var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.botConnector.delegate = self
        voiceAssistantView.delegate = self
        TextToSpeechManeger.Shared.delegate = self
        UIConfiguration()
        startConversation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        voiceAssistantView.popUp(on: self.view)
    }
    
    // MARK: Start Conversation
    func startConversation(){
        self.botConnector.startConversation()
    }
    
    // MARK: UI Configuration
    func UIConfiguration()  {
        addLottieAnimation()
        self.navigationController?.isNavigationBarHidden = true
    }
    

    func addLottieAnimation() {
        animationView = .init(name:"robot",bundle:Labiba.bundle )
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 1
        view.addSubview(animationView!)
       // animationView!.play()
        view.sendSubviewToBack(animationView!)
    }
    func submitUserText(_ text:String) -> Void {
        let goodText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.botConnector.sendMessage(goodText)
    }
    
    //MARK:-   BotConnectorDelegate implementation

    //extension VoiceExperienceVC: BotConnectorDelegate{
    override func botConnector(_ botConnector: BotConnector, didRecieveActivity activity: ConversationDialog) {
        
        if let message = activity.message {
            Labiba.setLastMessageLangCode(message)
            if Labiba.Bot_Type != .keyboardType {
                if activity.enableTTS {
                    TextToSpeechManeger.Shared.append(dialog: activity)
                
                }
            }
        }
    }
    
    override func botConnectorDidRecieveTypingActivity(_ botConnector: BotConnector) {
        
    }
    }

    //MARK:-   VoiceRecognitionProtocol implementation
extension PresentationVC: VoiceAssistantKeyboardDelegate {
    func voiceAssistantKeyboard(_ dialog: UIView, didSubmitText text: String) {}
    
    func voiceAssistantKeyboardWillShow(keyboardHight: CGFloat) {}
    
    func voiceAssistantKeyboardWillHide() {}
    
    func finishRecognitionWithText(text: String) {
        submitUserText(text)
    }
    
    func didStartSpeechToText() {
        if animationView?.isAnimationPlaying  ?? false {
            animationView?.animationSpeed = 2
            animationView?.play(fromFrame:  animationView?.realtimeAnimationFrame  ,toFrame: 0, loopMode: .playOnce,completion: { _ in
                self.animationView?.animationSpeed = 1
            })
        }
    }
    
    func didRecognizeText(text: String) {
    }
    
    func didStopRecording() {
        
    }
    func changeFromVoiceToKeyboardType() {}
}

extension PresentationVC: TextToSpeechDelegate{
    func TextToSpeechDidStart() {
        DispatchQueue.main.async { [weak self] in
            self?.animationView?.play(toFrame: .infinity, loopMode: .loop)
        }
       
    }
    
    func TextToSpeechDidStop() {
        DispatchQueue.main.async { [weak self] in
            if self?.animationView?.isAnimationPlaying  ?? false {
                self?.animationView?.animationSpeed = 2
                self?.animationView?.play(fromFrame: self?.animationView?.realtimeAnimationFrame ,toFrame: 0, loopMode: .playOnce,completion: { _ in
                    self?.animationView?.animationSpeed = 1
                })
            }
        }
       
    }
}
