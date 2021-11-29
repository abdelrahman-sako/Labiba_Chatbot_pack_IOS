//
//  TextToSpeechManeger.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 8/5/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import Foundation
import AVFoundation

protocol TextToSpeechDelegate {
    func TextToSpeechDidStart()
    func TextToSpeechDidStop()
}
class TextToSpeechManeger:NSObject{
    private var audioEngine = AVAudioEngine()
    private var player:AVAudioPlayer?
    private var playerItem:AVPlayerItem?
    private var TTS_Models_Array:[TTSMessageModel] = []
    private var isPlaying:Bool = false
    private var voiceRate:Float = 1.3
    private var volume:Float = 1.0
    private let audioSession =  AVAudioSession.sharedInstance()
    var delegate:TextToSpeechDelegate?
    static let Shared = TextToSpeechManeger()
    var botConnector:BotConnector = LabibaRestfulBotConnector.shared
    
    private var ToDeletDialogs:[ConversationDialog] = []
    private override init(){
        super.init()
        addStopTTSObserver()
    }
    
    func getURL(for model:TTSMessageModel) {//-> URL? {
        let message = model.message.replacingOccurrences(of: "\"", with: "")
        let TTS_Model = TextToSpeechModel(text: message, googleVoice: GoogleVoice(voiceLang: LabibaLanguage(rawValue:model.langCode) ?? .ar), clientid: "0",isSSML: model.isSSML)
        botConnector.textToSpeech(model: TTS_Model) { (result) in
            switch result{
            case .success(let url):
                if let url = URL(string: url){
                    self.ToDeletDialogs.first?.voiceUrl = url.absoluteString
                    self.ToDeletDialogs.removeFirst()
                    self.downloadFileFromURL(url: url)
                }
            case .failure(_):
                self.isPlaying = false
                if self.TTS_Models_Array.count > 0 {
                    self.TTS_Models_Array.remove(at: 0)
                }
                self.playNextAudio()
            }
        }
        
        //        let url  = URL(string: "https://translate.google.com/translate_tts?ie=UTF-8&tl=\( model.langCode)&client=tw-ob&q=\(model.message)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        //self.downloadFileFromURL(url: url)
        //        return URL(string: "https://translate.google.com/translate_tts?ie=UTF-8&tl=\( model.langCode)&client=tw-ob&q=\(model.message)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        
    }
    
    
    func append(dialog:ConversationDialog)  {
        ToDeletDialogs.append(dialog)
        guard let message = dialog.message, !message.isEmpty, Labiba.EnableTextToSpeech   else {
            return
        }
        //if !Labiba.EnableTextToSpeech   { return }
        
        var filteredText = message//dialog.message ?? " "
        //        filteredText = filteredText.withoutHtmlTags
        filteredText.removeHtmlTags()
      
        let langCode = filteredText.detectedLangauge() ?? "ar"
        var rate:Float = 1
        switch langCode {
        case "ar":
            //langCode = "ar-JO"
            rate = Labiba.ARVoiceRate
        default:
            // langCode = "en-US"
            rate = Labiba.ENVoiceRate
        }
        if let linkRange = filteredText.detectedHyperLinkRange(){
            filteredText.removeSubrange(linkRange)
        }
        // TTS_Models_Array += longMessageDivider(text: filteredText, langCode: langCode, rate: rate)
        var  messageModel:TTSMessageModel!
        if let ssml = dialog.SSML {
            messageModel = TTSMessageModel(message: ssml, langCode: langCode, rate: rate,isSSML: true)
        }else{
            messageModel = TTSMessageModel(message: filteredText, langCode: langCode, rate: rate)
        }
        TTS_Models_Array.append(messageModel)
        playNextAudio()
        
        
    }
    
    func longMessageDivider(text:String , langCode:String ,rate:Float) -> [TTSMessageModel] {
        if text.count > 180 {
            var segmentArray:[TTSMessageModel] = []
            let segmentCount = text.count/180
            let reminder = text.count % 180
            var customString = text
            for i in 1...segmentCount {
                let startIndex = customString.startIndex
                var endIndex = customString.index(startIndex, offsetBy: 180)
                if customString[endIndex] != " " {
                    let stringForSpace = String(customString[endIndex...])
                    let firstSpaceIndex = stringForSpace.firstIndex(of: " ") ?? stringForSpace.startIndex
                    let addedValue = stringForSpace[stringForSpace.startIndex...firstSpaceIndex].count
                    endIndex = customString.index(startIndex, offsetBy: 180 + addedValue)
                }
                segmentArray.append( TTSMessageModel(message: String(customString[..<endIndex]), langCode: langCode, rate: rate) )
                customString = String(customString[endIndex...])
            }
            if reminder > 0 {
                segmentArray.append(TTSMessageModel(message: String(customString[customString.startIndex..<customString.endIndex]), langCode: langCode, rate: rate))
            }
            return segmentArray
        }else{
            return [TTSMessageModel(message: text, langCode: langCode, rate: rate)]
        }
    }
    
    //var data:Data?
    func downloadFileFromURL(url:URL){
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url  , completionHandler: {[weak self](url, response, err) in
            guard let url = url else{return}
          //  self?.data = try! Data(contentsOf: url)
            self?.play(url: url)
        })
        
        downloadTask.resume()
    }
    
    
    func play(url:URL) {
        NotificationCenter.default.post(name: Constants.NotificationNames.StopSpeechToText,
                                        object: nil)
        print("playing \(url)")
        //        do {
        //            let url = URL(fileURLWithPath: url.path)
        //            let isReachable = try url.checkResourceIsReachable()
        //            // ... you can set breaking points after that line, and if you stopped at them it means file exist.
        //        } catch let e {
        //            print("couldnt load file \(e.localizedDescription)")
        //        }
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
            self.player = try AVAudioPlayer(contentsOf: url)
            //self.player = try AVAudioPlayer(data: data!)
            delegate?.TextToSpeechDidStart()
            player?.prepareToPlay()
            player?.volume = volume
            player?.enableRate = true
            player?.rate = voiceRate
            player?.delegate = self
            DispatchQueue.global(qos: .background).async { [weak self] in
                self?.player?.play()
            }
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }
    
    func setVolume(volume:Float)  {
        self.volume = volume
        player?.volume = volume
    }
    
    
    private func playNextAudio() {
        if TTS_Models_Array.count > 0 && !isPlaying{
            isPlaying = true
            getURL(for: TTS_Models_Array[0])
            voiceRate = TTS_Models_Array[0].rate
        }
    }
    
    func addStopTTSObserver()  {
        NotificationCenter.default.addObserver(forName: Constants.NotificationNames.StopTextToSpeech, object: nil, queue: OperationQueue.main) { [weak self](notification) in
            self?.stop()
        }
    }
    
    
    
    //    func checkCurrentRout()  {
    //        let currentRoute = AVAudioSession.sharedInstance().currentRoute
    //            for description in currentRoute.outputs {
    //                if description.portType == AVAudioSession.Port.headphones {
    //                    print("headphone plugged in")
    //                } else {
    //                    print("headphone pulled out")
    //                }
    //            }
    //        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChangeListener(_:)), name: AVAudioSession.routeChangeNotification, object: nil)
    //    }
    //    @objc func audioRouteChangeListener(_ notification:Notification) {
    //         guard let userInfo = notification.userInfo,
    //            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
    //            let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
    //                return
    //        }
    //        switch reason {
    //        case .unknown:
    //            print("unknown")
    //        case .newDeviceAvailable:
    //             print("headphone plugged in")
    //        case .oldDeviceUnavailable:
    //            print("headphone pulled out")
    //        case .categoryChange:
    //            print("categoryChange")
    //        case .override:
    //            print("override")
    //        case .wakeFromSleep:
    //            print("wakeFromSleep")
    //        case .noSuitableRouteForCategory:
    //            print("noSuitableRouteForCategory")
    //        case .routeConfigurationChange:
    //            print("routeConfigurationChange")
    //        @unknown default:
    //            print("break")
    //        }
    //    }
    
    
    
    
    
    
    
    func stop() {
        setSessionCategoryForSpeechToText()
        player?.pause()
        player = nil
        isPlaying = false
        if TTS_Models_Array.count > 0 {
            TTS_Models_Array.removeAll()
        }
        delegate?.TextToSpeechDidStop()
    }
    
    func setSessionCategoryForSpeechToText()  {
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        }catch let err {
            print(err)
        }
    }
    
    @objc func playerFailed(_ note: Notification) {
        isPlaying = false
        player?.pause()
    }
    
    
}



class TTSMessageModel{
    var message:String
    var langCode:String
    var rate:Float
    var isSSML:Bool
    init(message:String ,langCode:String ,rate:Float ,isSSML:Bool = false) {
        self.message = message
        self.langCode = langCode
        self.rate = rate
        self.isSSML = isSSML
    }
}




extension TextToSpeechManeger: AVAudioPlayerDelegate{
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        if TTS_Models_Array.count > 0 {
            TTS_Models_Array.remove(at: 0)
        }
        NotificationCenter.default.post(name: Constants.NotificationNames.FinishCurrentTextToSpeechPhrase,object: nil)
        if  TTS_Models_Array.count == 0 { // comment for nathealth
             delegate?.TextToSpeechDidStop()
            if Labiba.Temporary_Bot_Type != .keyboardType  {
                setSessionCategoryForSpeechToText()
                if Labiba.EnableAutoListening {
                    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.2) {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: Constants.NotificationNames.StartSpeechToText,
                            object: nil)
                        }
                        
                    }
                    
                }
            }
            
        }
        
        playNextAudio()
    }
}
