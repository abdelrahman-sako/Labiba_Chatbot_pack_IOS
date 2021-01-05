//
//  VoiceAssistant.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 7/5/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import Foundation

protocol VoiceRecognitionProtocol {
    func didStartSpeechToText()
    func finishRecognitionWithText(text:String)
    func didRecognizeText(text:String)
    func didStopRecording()
    func changeFromVoiceToKeyboardType()
}


protocol VoiceAssistantKeyboardDelegate:VoiceRecognitionProtocol
{
    func voiceAssistantKeyboard(_ dialog: UIView, didSubmitText text: String)
    func voiceAssistantKeyboard(_ dialog: UIView, didSubmitFile url: URL)
    func voiceAssistantKeyboardWillShow(keyboardHight:CGFloat)
    func voiceAssistantKeyboardWillHide()
}

extension VoiceAssistantKeyboardDelegate {
    func voiceAssistantKeyboard(_ dialog: UIView, didSubmitFile url: URL){}
}
