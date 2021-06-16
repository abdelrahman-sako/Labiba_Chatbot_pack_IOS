//
//  BaseConversationVC.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 4/28/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import Foundation
import CoreLocation
import ContactsUI
class BaseConversationVC:UIViewController ,BotConnectorDelegate, EntryTableViewCellDelegate ,CustomCollectionCellDelegate, DatePickerViewControllerDelegate, DateRangeViewControllerDelegate, LocationSelectViewControllerDelegate , ImageSelectorDelegate {
   
   
    override func viewDidLoad() {
        //OCR or LIVENESS
        //AR or EN
//        delegate?.createPost?(onView: self.view, ["post":"{\"Role\":\"LIVENESS\",\"BotSessionID\": \"botSessionID\",\"PhoneNumber\": \"07788663666\",\"BotID\":\"0aa6d142-1ec1-497a-9915-4aefb42f7e51\",\"Language\": \"AR\"}"], completionHandler: { (status, data) in
//            if status {
//                var object:[String:Any] = ["status":"success"] // "status":"success" added for BOJ
//                if let data = data {
//                    data.forEach({object[$0.key] = $0.value})
//                }
//                Labiba.createCustomReferral(object: object)
//
//            }else{
//                Labiba.createCustomReferral(object: ["status":"fail"])
//            }
//            self.botConnector.sendMessage("get started")
//        })
//        return
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIScene.willEnterForegroundNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    @objc func willResignActive(_ notification: Notification) {
        botConnector.resumeConnection()
    }
    
    var botConnector:BotConnector = LabibaRestfulBotConnector.shared
    var delegate:LabibaDelegate?
    
    func displayDialog(_ dialog:ConversationDialog ) -> Void {}
    
    // MARK:- CustomCollectionCellDelegate
    func collectionView(dialogIndex: Int,selectedCardIndex: Int, selectedCellDialogCardButton: DialogCardButton?, didTappedInTableview TableCell: CustomTableViewCell) {
        if let payload = selectedCellDialogCardButton?.payload
        {
            stopTTS_STT()
            self.botConnector.sendMessage(payload: payload)
        }
    }
    
     //MARK:-  EntryTableViewCellDelegate methods
    
    func choiceWasSelectedFor(display: EntryDisplay, choice: DialogChoice) {
//    b
        stopTTS_STT()
        print("TrackSteps Choice selected: \(choice.title)")
        if let action = choice.action
        {
            self.view.endEditing(true)
            switch action
            {
            case .date:
                DatePickerViewController.present(withDelegate: self)
            case .time:
                DatePickerViewController.present(withDelegate: self, mode: .time)
            case .dateRange:
                DateRangeViewController.present(withDelegate: self)
            case .distance:
                LocationSelectViewController.present(withDelegate: self)
                // CustomMapPicker.present(withDelegate:self)
                
                //                let customMapPicker = CustomMapPicker()
                //                customMapPicker.customMapPickerDelegate = self
            //                self.present(customMapPicker, animated: true, completion: nil)
            case .location:
                //CustomMapPicker.present(withDelegate:self)
                LocationSelectViewController.present(withDelegate: self)
                //                let customMapPicker = CustomMapPicker()
                //                customMapPicker.customMapPickerDelegate = self
            //                self.present(customMapPicker, animated: true, completion: nil)
            case .calendar:
                DatePickerViewController.present(withDelegate: self, mode: .date)
            case .camera:
               ImageSelector.shared.launch(onView: self, source: .camera, allowEditing: true)
            case .gallery:
                ImageSelector.shared.launch(onView: self, source: .photoLibrary, allowEditing: true)
            case .menu:
                self.botConnector.ShowDialog()
            case .QRCode:
                //                break
                let vc = ScannerVC()
                vc.modalPresentationStyle = .fullScreen
                vc.setupScanner(localString("scanTitle"), .gray, .grid , success: { (code) in
                    print(code)
                    var returnString = String()
                    
                    for myChar in code {
                        let tmpString: String = String(myChar)
                        for myChar in tmpString.unicodeScalars {
                            if myChar.value != UInt32(29) {
                                returnString += "\(myChar)"
                            }
                        }
                    }
                    self.dismiss(animated: true, completion: nil)
                    self.botConnector.sendMessage(code.QRcodeToArray())
                   // self.clearChoices()
                }) { (err) in
                    self.dismiss(animated: true) {
                        switch err{
                        case .error(let value):
                            showErrorMessage(value)
                        }
                    }
                }
                //                vc.setupScanner(localString("scanTitle"), .gray, .grid ) { (code) in
                //                    print(code)
                //                    var returnString = String()
                //
                //                    for myChar in code {
                //                        let tmpString: String = String(myChar)
                //                        for myChar in tmpString.unicodeScalars {
                //                            if myChar.value != UInt32(29) {
                //                                returnString += "\(myChar)"
                //                            }
                //                        }
                //                    }
                //                    self.dismiss(animated: true, completion: nil)
                //                    self.botConnector.sendMessage(code.QRcodeToArray())
                //                    self.clearChoices()
                //                }
                
                present(vc, animated: true, completion: nil)
            }
            
        }
    }
    func hintWasSelectedFor( hint: String) {
        stopTTS_STT()
        self.botConnector.sendMessage(hint)
        // following code added as malak sayes for IA
        let dialog = ConversationDialog(by: .user, time: Date())
        dialog.message = hint
        self.displayDialog(dialog)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.botConnectorDidRecieveTypingActivity(self.botConnector)
        }
    }
    
    func cardButton(_ button: DialogCardButton, ofCard card: DialogCard, wasSelectedForDialog dialog: ConversationDialog) {
//        delegate?.createPost?(onView: self.view, ["post":"56696281-9b74-4978-bdde-8774f64ce440","senderId":Labiba._senderId], completionHandler: { (status, data) in
//            if status {
//                var object:[String:Any] = ["status":"success"] // "status":"success" added for BOJ
//                if let data = data {
//                    data.forEach({object[$0.key] = $0.value})
//                }
//                Labiba.createCustomReferral(object: object)
//
//            }else{
//                Labiba.createCustomReferral(object: ["status":"fail"])
//            }
//            self.botConnector.sendMessage("get started")
//        })
//        return
        stopTTS_STT()
     
        if let urlStr = button.url,let url = URL(string: urlStr)
        {
            if UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }
        else if let payload = button.payload
        {
            if button.type == .phoneNumber{
                if let url = URL(string: "tel://\(payload)"),
                    UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    // UIApplication.shared.openURL(url)
                }else{
                    showErrorMessage("لا يتوفر رقم هاتف")
                }
//                 let contact = CNMutableContact()
//                  let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue :payload))
//                  contact.phoneNumbers = [homePhone]
//                  //contact.namePrefix = "Abdallah"
//                  contact.givenName = "Abdallah"
//                  contact.familyName = "Hamdan"
//
//                 // contact.imageData = data // Set image data here
//                  let vc = CNContactViewController(forNewContact: contact)
//                  vc.delegate = self
//                  let nav = UINavigationController(rootViewController: vc)
//                  UIApplication.shared.setStatusBarColor(color: .clear)
//                  self.present(nav, animated: true, completion: nil)
                
            }else if button.type == .email{
                let subject = "Email"
                let email = payload
                if let url = URL(string: "mailto:\(email)?cc=&subject=\(subject)"),
                    UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }else if  button.type  == .createPost {
                delegate?.createPost?(onView: self.view, ["post":payload,"senderId":Labiba._senderId], completionHandler: { (status, data) in
                    if status {
                        var object:[String:Any] = ["status":"success"] // "status":"success" added for BOJ
                        if let data = data {
                            data.forEach({object[$0.key] = $0.value})
                        }
                        Labiba.createCustomReferral(object: object)
                    }else{
                        Labiba.createCustomReferral(object: ["status":"fail"])
            
                    }
                    self.botConnector.sendMessage("get started")
                })
            }else{
                self.botConnector.sendMessage(payload: payload)
                // following code added as malak sayes for IA
                let dialog = ConversationDialog(by: .user, time: Date())
                dialog.message = button.title
                self.displayDialog(dialog)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.botConnectorDidRecieveTypingActivity(self.botConnector)
                }
            }
            //
        }
    }
    
    func actionFailedFor(dialog: ConversationDialog) {
        print("falie")
    }
    
    func finishedDisplayForDialog(dialog: ConversationDialog) {
        print("finish")
    }
    
    // MARK:- DatePickerViewControllerDelegate
    
    func datePickerController(_ datePickerVC: DatePickerViewController, didSelectDate selectedDate: Date) {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateFormat =  "dd MMMM yyyy HH:mm a"
        
        let dff = DateFormatter()
        dff.locale = Locale(identifier: "en_US")
        dff.dateFormat = "dd MMMM yyyy"
        
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "en_US")
        dt.dateFormat = "hh:mm a"
        
        var displayedtext = ""
        var botText = ""
        switch datePickerVC.selectedMode {
        case .time:
            displayedtext = dt.string(from: selectedDate)
            botText = dt.string(from: selectedDate)
        case .date:
            displayedtext = dff.string(from: selectedDate)
            dff.dateFormat = "dd/M/yyyy"
            botText = dff.string(from: selectedDate)
        case .dateAndTime:
            displayedtext = df.string(from: selectedDate)
            df.dateFormat =  "dd/M/yyyy HH:mm a"
            botText = df.string(from: selectedDate)
        case .countDownTimer:
            break
            
        }
        
        self.botConnector.sendMessage(botText)
        let dialog = ConversationDialog(by: .user, time: Date())
        dialog.message = displayedtext
        
        self.displayDialog(dialog)
  
    }
    
    func datePickerControllerDidClearSelection(_ datePickerVC: DatePickerViewController) {}
    
      // MARK:- DateRangeViewControllerDelegate
    
    func dateRangeController(_ dateRangeVC: DateRangeViewController, didSelectRange selectedRange: DateRange) {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateFormat = "dd MMMM yyyy"
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "en_US")
        dt.dateFormat = "hh:mm a"
        let text = "Between " + df.string(from: selectedRange.start) + " at " +  dt.string(from: selectedRange.start) + " and " + df.string(from: selectedRange.end) + " at " +  dt.string(from: selectedRange.end)
        self.botConnector.sendMessage( text)
        let dialog = ConversationDialog(by: .user, time: Date())
        dialog.message = text
        
        self.displayDialog(dialog)
    }
    
     func dateRangeControllerDidClearSelection(_ dateRangeVC: DateRangeViewController) {}
     
      // MARK:- LocationSelectViewControllerDelegate
    func locationSelectDidReceiveAddress(_ address: String, atCoordinates coordinates: CLLocationCoordinate2D) {
        self.botConnector.sendLocation(coordinates)
        let dialog = ConversationDialog(by: .user, time: Date())
        dialog.map = DialogMap(coordinate: coordinates, address: address,distance:"")
        
        displayDialog(dialog)
    }
    
    // MARK:- ImageSelectorDelegate
    
    func imageSelectorDidSelectImage(_ image: UIImage, fromSource source: UIImagePickerController.SourceType) {
        
    }
    
    
     // MARK:- Speech to Texe and Text to Speech
    func stopTTS_STT(){
           NotificationCenter.default.post(name: Constants.NotificationNames.StopTextToSpeech,
                                           object: nil)
           stopSTT()
           
       }
       
       func stopSTT() {
          NotificationCenter.default.post(name: Constants.NotificationNames.StopSpeechToText,object: nil)
       }

    //MARK:-   BotConnectorDelegate implementation

    func botConnector(_ botConnector: BotConnector, didRecieveActivity activity: ConversationDialog) {}
    func botConnector(_ botConnector: BotConnector, didRequestLiveChatTransferWithMessage message: String) {
        delegate?.liveChatTransfer?(onView: self.view, transferMessage: message)
    }
    func botConnectorDidRecieveTypingActivity(_ botConnector: BotConnector) {}
    func botConnectorRemoveTypingActivity(_ botConnector: BotConnector) {}
}



extension BaseConversationVC: CNContactViewControllerDelegate{
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BaseConversationVC : LocationServiceDelegate {
    func locationService(_ service: LocationService, didReceiveLocation location: CLLocationCoordinate2D) {
        botConnector.sendLocation(location)
        LocationService.shared.delegate = nil
    }
}
