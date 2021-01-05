//
//  LabibaChatHeaderView.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 9/6/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import Foundation
import UIKit

@objc protocol LabibaChatHeaderViewDelegate: class
{
    
    func labibaHeaderViewDidRequestClosing()
    func labibaHeaderViewDidRequestMute()
    func labibaHeaderViewDidRequestBackAction()
    @objc optional func labibaHeaderViewDidSubmitText(message:String)
    @objc optional func labibaHeaderViewDidRequestVedioCallAction()
}

open class LabibaChatHeaderView: UIView
{
    
    @IBOutlet public weak var closeButton: UIButton!
    @IBOutlet public weak var backButton: UIButton!
    
    weak var delegate: LabibaChatHeaderViewDelegate?
    
    func restartApplication () {
        NotificationCenter.default.post(name: Constants.NotificationNames.StopTextToSpeech,
                                        object: nil)
        NotificationCenter.default.post(name: Constants.NotificationNames.StopSpeechToText,
                                        object: nil)
        NotificationCenter.default.post(name: Constants.NotificationNames.languageChanged,
                                        object: nil)
        
        
        Labiba.initialize(RecipientIdAR: SharedPreference.shared.getUserIDs().ar,RecipientIdEng: SharedPreference.shared.getUserIDs().en ,language: SharedPreference.shared.botLangCode) // initialize requered to resend the prefferals each time the languge changed
        let  vc = Labiba.createConversation()
        
        
        guard
            let window = UIApplication.shared.keyWindow,
            let rootViewController = window.rootViewController
            else {
                return
        }
        var navCtrl = UINavigationController()
        if let viewControllers = UIApplication.shared.topMostViewController?.navigationController?.viewControllers , let _ = viewControllers.last as? ConversationViewController{
            var newVCs = viewControllers // this is neccessary for back action
            newVCs.removeLast()
            newVCs.append(vc)
            navCtrl.setViewControllers(newVCs, animated: false)
        }else{
            UIApplication.shared.topMostViewController?.dismiss(animated: true, completion: {
                vc.modalPresentationStyle = .fullScreen
                
                UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
            })
            return
            //navCtrl = UINavigationController(rootViewController: vc)
        }
        navCtrl.view.frame = rootViewController.view.frame
        navCtrl.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            window.rootViewController = navCtrl
        },completion: { complete in
            Labiba.setStatusBarColor(color: Labiba._StatusBarColor)
        })
        
    }
    
    @IBAction func langAction(_ sender: Any) {
          
          let alert = UIAlertController(title: "",
                                        message: "chang_language".localForChosnLangCodeBB, preferredStyle: .alert)
          let arAction = UIAlertAction(title: "العربية", style: .default, handler: { _ in
              let currentLang = SharedPreference.shared.botLangCode
              if currentLang != .ar{
                  Labiba.setBotLanguage(LangCode: .ar)
                  self.restartApplication ()
              }
          })
          
          let enAction = UIAlertAction(title: "English", style: .default, handler: { _ in
              let currentLang = SharedPreference.shared.botLangCode
              if currentLang != .en{
                  Labiba.setBotLanguage(LangCode: .en)
                  self.restartApplication ()
              }
              
          })
          alert.addAction(enAction)
          alert.addAction(arAction)
          let ruAction = UIAlertAction(title: "русский", style: .default, handler: { _ in
              let currentLang = SharedPreference.shared.botLangCode
              if currentLang != .ru{
                  Labiba.setBotLanguage(LangCode: .ru)
                  self.restartApplication ()
              }
              
          })
          let deAction = UIAlertAction(title: "Deutsch", style: .default, handler: { _ in
              let currentLang = SharedPreference.shared.botLangCode
              if currentLang != .de{
                  Labiba.setBotLanguage(LangCode: .de)
                  self.restartApplication ()
              }
              
          })
          let znAction = UIAlertAction(title: "俄文", style: .default, handler: { _ in
              let currentLang = SharedPreference.shared.botLangCode
              if currentLang != .zh{
                  Labiba.setBotLanguage(LangCode: .zh)
                  self.restartApplication ()
              }
              
          })
          let ids = SharedPreference.shared.getUserIDs()
          if !ids.ru.isEmpty { alert.addAction(ruAction)}
          if !ids.zn.isEmpty { alert.addAction(znAction) }
          if !ids.de.isEmpty { alert.addAction(deAction) }
          
          getTheMostTopViewController().present(alert, animated: true, completion: {})
          
      }
    
   
    @IBAction func backAction(_ sender: Any) {
        self.delegate?.labibaHeaderViewDidRequestBackAction()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        closeChat()
    }
   
    
    func mute()  {
        self.delegate?.labibaHeaderViewDidRequestMute()
    }
    
    public func closeChat() -> Void
    {
        self.delegate?.labibaHeaderViewDidRequestClosing()
    }
}
