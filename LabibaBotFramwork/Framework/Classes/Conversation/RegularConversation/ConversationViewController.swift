//
//  ConversationViewController.swift
//  ImagineBot
//
//  Created by Suhayb Al-Absi on 10/21/16.
//  Copyright © 2016 Suhayb Al-Absi. All rights reserved.
//

import UIKit
import CoreLocation
import ContactsUI
class ConversationViewController: BaseConversationVC, EntryDisplayTarget, CardsViewControllerDelegate, LabibaChatHeaderViewDelegate, CustomMapPickerDelegate
{
    
    
    override func collectionView(dialogIndex: Int,selectedCardIndex: Int, selectedCellDialogCardButton: DialogCardButton?, didTappedInTableview TableCell: CustomTableViewCell) {
        if let _ = selectedCellDialogCardButton?.payload
        {
            canLunchRating = true
            if Labiba.MenuCardView.clearNonSelectedItems{
                let SelectedDialogCard = self.displayedDialogs[dialogIndex].dialog.cards?.items[selectedCardIndex]
                self.displayedDialogs[dialogIndex].dialog.cards?.items.removeAll()
                self.displayedDialogs[dialogIndex].dialog.cards?.items.append(SelectedDialogCard!)
            }else{
                submitLocalUserText(self.displayedDialogs[dialogIndex].dialog.cards?.items[selectedCardIndex].title ?? "")
            }
            super.collectionView(dialogIndex: dialogIndex, selectedCardIndex: selectedCardIndex, selectedCellDialogCardButton: selectedCellDialogCardButton, didTappedInTableview: TableCell)
        }
    }
    
    override func collectionView(dialogIndex: Int, selectedCardIndex: Int, selectedCellDialogCardButton: DialogCardButton?, didTappedInTableview TableCell: VMenuTableCell) {
        if Labiba.MenuCardView.clearNonSelectedItems{
            let SelectedDialogCard = self.displayedDialogs[dialogIndex].dialog.cards?.items[selectedCardIndex]
            self.displayedDialogs[dialogIndex].dialog.cards?.items.removeAll()
            self.displayedDialogs[dialogIndex].dialog.cards?.items.append(SelectedDialogCard!)
        }else{
            submitLocalUserText(self.displayedDialogs[dialogIndex].dialog.cards?.items[selectedCardIndex].title ?? "")
        }
        super.collectionView(dialogIndex: dialogIndex, selectedCardIndex: selectedCardIndex, selectedCellDialogCardButton: selectedCellDialogCardButton, didTappedInTableview: TableCell)
        
    }
    
    
   
    
    @IBOutlet weak var tavleViewBottomConst: NSLayoutConstraint!
    let dateFormatter = DateFormatter()
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var bacgroundImage: UIImageView!
    @IBOutlet weak var headerHeightConst: NSLayoutConstraint!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var VedioCallButton: UIButton!
    @IBOutlet weak var botIconView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet public weak var headerView: UIView!
    
    
    @IBAction func viewDidTap(_ sender: Any)
    {
        self.view.endEditing(true)
    }
    
    
    
    // var botConnector:BotConnector = LabibaBotConnector() //MockBotConnector()  //BotDirectLineConnector()
    // var botConnector:BotConnector = LabibaRestfulBotConnector()//LabibaBotConnectorJC() // LabibaRestfulBotConnector()
    // var delegate:LabibaDelegate?
    var botFrame:CGRect!
    var gradientView:UIView?
    var isClosable:Bool = true
    // var closeHandler:Labiba.ConversationCloseHandler?
    //  var externalTaskCompletionHandler:Labiba.ِExternalTaskCompletionHandler?
    var showTyping:Bool = false
    var displayedDialogs:[EntryDisplay] = []
    var lastMessage:String = ""
    var currentChoiceToken:String?
    var stepsToBeDisplayed = [ConversationDialog]()
    var isFirstMessage:Bool = true
    var canLunchRating:Bool = false
    var isTTSMuted:Bool = false
    var tableViewBottomInset:CGFloat = 50
    
    lazy var keyboardTypeDialog = UserTextInputNoLocal.create()
    lazy var visualizerDialog = VisualizerVoiceAssistantView.create()
    lazy var voiceTypeDialog = VoiceAssistantView.create()
    lazy var dynamicGifView = DynamicGIF.create()
    var maskImage:UIImageView!
    
    // to remove
    @objc func tapaction(){
        if SpeechToTextManager.shared.isRecording {
            NotificationCenter.default.post(name: Constants.NotificationNames.StopSpeechToText,
                                            object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }else{
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationCenter.default.post(name: Constants.NotificationNames.StartSpeechToText,
                                                object: nil)
            }
            
        }
        
        
        
        
    }
    override  func accessibilityPerformMagicTap() -> Bool {
        tapaction()
        return true
    }
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        // to remove
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapaction))
        gesture.numberOfTapsRequired = 3
        self.view.addGestureRecognizer(gesture)
        
        print("did load")
        
        addTableMask()
        muteButton.isHidden = Labiba.isMuteButtonHidden
        VedioCallButton.isHidden = Labiba.isVedioButtonHidden
        self.view.applySemanticAccordingToBotLang()
        self.view.layoutIfNeeded()
        // let podBundle = Bundle(for: ConversationViewController.self)
        self.navigationController?.isNavigationBarHidden = true
        Constants.Keyboard_type = ""
        dateFormatter.dateFormat = "h:mm a"
        self.closeButton.tintColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.botIconView.image = Labiba._Logo // UIImage(named:"navLogo",in: podBundle, compatibleWith: nil)
        
        self.botConnector.delegate = self
        // self.botConnector.configureInternetReachability()
        self.backButton.tintColor = Labiba._HeaderTintColor
        self.backButton.isHidden = Labiba._OpenFromBubble
        self.backButton.setImage(Labiba.backButtonIcon, for: .normal)
        chatBackgroundColor()
        if let hview = Labiba._customHeaderView
        {
            let sviews = self.headerView.subviews
            sviews.forEach
            { (sv) in
                sv.removeFromSuperview()
            }
            
            hview.frame = self.headerView.bounds
            hview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            //hview.closeButton?.isHidden = !self.isClosable
            hview.delegate = self
            self.headerView.addSubview(hview)
            headerView.backgroundColor = .clear
            switch UIScreen.current {
            case .ipad,.iPad10_5,.iPad12_9,.iPad9_7:
                self.headerHeightConst.constant = (Labiba._customHeaderViewHeight  ?? 100) + 50
            default:
                self.headerHeightConst.constant = Labiba._customHeaderViewHeight ?? 90
            }
            
            
            
        }
        else if let grad = Labiba._headerBackgroundGradient
        {
            
            let gview = GradientView(frame: self.headerView.bounds)
            gview.setGradient(grad)
            gview.frame.size = CGSize(width: view.frame.width, height: headerView.frame.height)
            self.headerView.insertSubview(gview, at: 0)
            
            gview.leftAnchor.constraint(equalTo: self.headerView.leftAnchor, constant: 0).isActive = true
            gview.rightAnchor.constraint(equalTo: self.headerView.rightAnchor, constant: 0).isActive = true
            gview.topAnchor.constraint(equalTo: self.headerView.topAnchor, constant: 0).isActive = true
            gview.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 0).isActive = true
            if let backgroundColor = grad.viewBackgroundColor {
                self.headerView.backgroundColor = backgroundColor
            }
            headerView.applyHierarchicalSemantics(flipImage: true)
        }
        else if let bgColor = Labiba._headerBackgroundColor
        {
            self.headerView.backgroundColor = bgColor
            headerView.applyHierarchicalSemantics(flipImage: true)
        }
        headerView.applyHierarchicalSemantics(flipImage: true)
        //
        //
        //  addInterationDialog(currentBotType:Labiba.Bot_Type)
        //
        addNotificationCenterObservers()
        
        tableView.registerCell(type: VMenuTableCell.self,bundle: self.nibBundle)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 1044.0
        
        //self.fillEdgeSpace(withColor: self.view.backgroundColor ?? .white, edge: .bottom)
        // addHintsCell()
        self.startConversation() //it's now from [ self.botConnector.configureInternetReachability()]
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        print("did appear")
        addInterationDialog(currentBotType:Labiba.Bot_Type)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        botConnector.delegate = self
        UIApplication.shared.setStatusBarColor(color: Labiba._StatusBarColor )
        self.navigationController?.isNavigationBarHidden = true
        TextToSpeechManeger.Shared.setVolume(volume: isTTSMuted ? 0 : 1)
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("view Will Disappear")
        TextToSpeechManeger.Shared.setVolume(volume: 0)
        UIApplication.shared.setStatusBarColor(color: .clear)
    }
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        print("ConversationViewController viewDidDisappear")
        
        if Labiba.enableCaching{
            LocalCache.shared.displayedDialogs = displayedDialogs
        }
        //        voiceTypeDialog?.speechToTextManager.removerObservers()
        //voiceTypeDialog.removeFromSuperview()
        
        //           if self.isClosed
        //           {
        //               self.closeHandler?()
        //               self.closeHandler = nil
        //           }
    }
    deinit {
        print("ConversationViewController deinitialized")
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return Labiba._StatusBarStyle
    }
    
    public static func create() -> ConversationViewController
    {
        return Labiba.storyboard.instantiateViewController(withIdentifier: "conversationVC") as! ConversationViewController
    }
    
    func HideCardsView() {
    }
    
    func addTableMask()  {
        maskImage = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height)))
        
        maskImage.image = Image(named: ipadFactor == 0 ? "gradientMask-9":"gradientMask-7")
        tableView.mask = maskImage
    }
    
    func addHintsCell() {
        guard let array = Labiba.hintsArray else {
            return
        }
        var questions = array
        questions.shuffle()
        let dialog = ConversationDialog(by: .bot, time: Date())
        let guide = DialogGuide()
        guide.title = "TRY SAYING".localForChosnLangCodeMB
        guide.questions = questions[0..<4].map({$0.localForChosnLangCodeMB})
        dialog.guide = guide
        let renderedDialog = EntryDisplay(dialog: dialog)
        renderedDialog.height = 80
        renderedDialog.status = .guide
        displayedDialogs.append(renderedDialog)
        
    }
    
    func addInterationDialog(currentBotType:BotType)
    {
        keyboardTypeDialog.dismiss()
        voiceTypeDialog.dismiss()
        switch currentBotType {
        case .keyboardType,.keyboardWithTTS:
            keyboardTypeDialog.delegate = self
            keyboardTypeDialog.popUp(on: self.backgroundView)
            switch UIScreen.current {
            case .iPhone5_8 ,.iPhone6_1 , .iPhone6_5:
                tavleViewBottomConst.constant = UserTextInputNoLocal.HEIGHT + ipadFactor*10 + 50
                tableView.contentInset.bottom = UserTextInputNoLocal.HEIGHT + ipadFactor*10 + 70
            default:
                tavleViewBottomConst.constant = UserTextInputNoLocal.HEIGHT + 50 + ipadFactor*15
                tableView.contentInset.bottom = UserTextInputNoLocal.HEIGHT + 70 + ipadFactor*15
            }
            
        case .voiceAssistance ,.voiceAndKeyboard ,.voiceToVoice:
            voiceTypeDialog.delegate = self
            voiceTypeDialog.popUp(on: self.backgroundView)
            switch UIScreen.current {
            case .iPhone5_8 ,.iPhone6_1 , .iPhone6_5:
                tavleViewBottomConst.constant = 50
                tableView.contentInset.bottom  = 80
            case .iPhone5_5 :
                tavleViewBottomConst.constant = 90
                tableView.contentInset.bottom = 110
            default:
                tavleViewBottomConst.constant = 90
                tableView.contentInset.bottom = 110
            }
        case .visualizer:
            visualizerDialog.popUp(on: self.backgroundView)
            visualizerDialog.delegate = self
            switch UIScreen.current {
            case .iPhone5_8 ,.iPhone6_1 , .iPhone6_5:
                tavleViewBottomConst.constant = visualizerDialog.orginalBottomMargin + 30
                tableView.contentInset.bottom = visualizerDialog.orginalBottomMargin + 50
            default:
                tavleViewBottomConst.constant = visualizerDialog.orginalBottomMargin + 30
                tableView.contentInset.bottom = visualizerDialog.orginalBottomMargin + 50
            }
        }
        
        tableViewBottomInset = tavleViewBottomConst.constant
        tableView.contentInset.top = Labiba._OpenFromBubble ?  30 : 70
        tableTopConstraint.constant = -70
        
        
    }
    
    
    
    //MARK:-Add observer
    func addNotificationCenterObservers()  {
        /// this part is no more needed where the code put on media view it self and it's work fine
        //        NotificationCenter.default.addObserver(forName: Constants.NotificationNames.FullscreenVideoRequested,
        //                                               object: nil, queue: nil)
        //        { (notification) in
        //
        //            if let info = notification.userInfo, let videoUrl = info["videoUrl"] as? URL {
        //
        //                if let videoVC = self.storyboard?.instantiateViewController(withIdentifier: "videoVC") as? VideoPlayerViewController
        //                {
        //                    videoVC.videoUrl = videoUrl
        //                    self.present(videoVC, animated: true, completion: {})
        //                }
        //            }
        //        }
        
        NotificationCenter.default.addObserver(forName: Constants.NotificationNames.ChangeInputToTextViewType,
                                               object: nil, queue: nil)
        { (notification) in
            let char = notification.object as? String ?? ""
            // if Labiba.Bot_Type == .voiceAssistance {
            self.addInterationDialog(currentBotType: .keyboardType)
            Labiba.Temporary_Bot_Type = .keyboardType
            NotificationCenter.default.post(name: Constants.NotificationNames.ChangeTextViewKeyboardType,
                                            object: char)
            //  }
        }
        
        NotificationCenter.default.addObserver(forName: Constants.NotificationNames.ChangeInputToVoiceAssistantType,
                                               object: nil, queue: nil)
        { (notification) in
            let char = notification.object as? String ?? ""
            if Labiba.Bot_Type == .voiceAssistance {
                self.addInterationDialog(currentBotType: .voiceAssistance)
                Labiba.Temporary_Bot_Type = .voiceAssistance
            }
        }
        
        NotificationCenter.default.addObserver(forName: Constants.NotificationNames.ScoketDidOpen,
                                               object: nil, queue: nil)
        { (notification) in
            //self.addInterationDialog(currentBotType:Labiba.Bot_Type) // to handel first time, when using bubble, where backgroud view frame  not correct for the first time
        }
        
        NotificationCenter.default.addObserver(forName: Constants.NotificationNames.ShowHideDynamicGIF,
                                               object: nil, queue: nil)
        { (notification) in
            let obj = notification.object as? [String:Any]
            if obj?["show"] as? Bool ?? false {
                self.dynamicGifView.popUp(on: self.backgroundView)
                self.dynamicGifView.showGIF(url:  URL(string:obj?["url"] as! String)!  ,looping: obj?["isLooping"] as? Bool ?? false )
            }else{
                self.dynamicGifView.remove()
            }
        }
    }
    
    
    func chatBackgroundColor()  {
        switch Labiba.BackgroundView.background {
        case .solid(color: let color):
            self.backgroundView.backgroundColor = color
        case .gradient(gradientSpecs: let grad):
            backgroundView.applyGradient(colours: grad.colors, locations: nil)
            if let backgroundColor = grad.viewBackgroundColor {
                self.backgroundView.backgroundColor = backgroundColor
            }
        case .image(image: let image):
            self.bacgroundImage.image = image
        }
        //        if let bgImage = Labiba._ChatMainBackgroundImage {
        //            self.bacgroundImage.image = bgImage
        //        }else if let grad = Labiba._ChatMainBackgroundGradient{
        //            backgroundView.applyGradient(colours: grad.colors, locations: nil)
        //            if let backgroundColor = grad.viewBackgroundColor {
        //                self.backgroundView.backgroundColor = backgroundColor
        //            }
        //        }else if let bgColor = Labiba._ChatMainBackgroundColor {
        //            self.backgroundView.backgroundColor = bgColor
        //        }
    }
    //MARK:Back and Closing Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        backAction()
    }
    
    @IBAction func muteAtion(_ sender: UIButton) {
        labibaHeaderViewDidRequestMute()
        if sender.tag == 0 {
            sender.tag = 1
            TextToSpeechManeger.Shared.setVolume(volume: 0.0)
            muteButton.setImage(Image(named: "volume_off"), for: .normal)
        }else{
            sender.tag = 0
            TextToSpeechManeger.Shared.setVolume(volume: 1.0)
            muteButton.setImage(Image(named: "volume_up"), for: .normal)
        }
        
    }
    @IBAction func VedioCallAction(_ sender: UIButton) {
        labibaHeaderViewDidRequestVedioCallAction()
    }
    
    func labibaHeaderViewDidRequestBackAction() {
        backAction()
    }
    
    func labibaHeaderViewDidRequestMute() {
        isTTSMuted = !isTTSMuted
    }
    
    func backAction() {
        stopTTS_STT()
        shutDownBotChat()
    }
    
    func shutDownBotChat() -> Void {
        Labiba.dismiss()
        UIApplication.shared.setStatusBarColor(color: .clear)
    }
    
    func labibaHeaderViewDidRequestClosing()
    {
        
        if Labiba._WithRatingVC {
            if canLunchRating {
                self.view.endEditing(true)
                botConnector.delegate = nil //o ensure that the text to speech will not work if the response return after chat shut down
                self.isClosed = true
                stopTTS_STT()
                stopSTT()
                switch Labiba.RatingForm.style {
                case .fullScreen:
                    RatingVC.present(fromVC: self, delegate: self)
                case .sheet:
                    RatingSheetVC.present(fromVC: self, delegate: self)
                }
                
            }else{
                // kill(getpid(), SIGKILL)
                backAction()
                //exit(0)
            }
            return
        }
        // }
        backAction()
    }
    
    
    
    func labibaHeaderViewDidSubmitText(message: String) {
        stopTTS_STT()
        //self.botConnector.sendMessage(payload: message)
        self.submitUserText(message)
    }
    
    func labibaHeaderViewDidRequestVedioCallAction() {
        delegate?.createPost?(onView: self.view, ["startVideoCall":true], completionHandler: { (status, data) in})
    }
    
    
    
    
    private var isClosed:Bool = false
    @IBAction func dismissConversation(_ sender: AnyObject) {
        
        self.isClosed = true
        //         self.botConnector.close()
        DataSource.shared.close()
        self.shutDownBotChat()
    }
    
    var animatesClosing:Bool = true
    
    
    
    
    
    func clearSelectChoices(_ card: DialogCard) -> Void
    {
        let dialog = ConversationDialog(by: .user, time: Date())
        dialog.message = "Select \(card.title)"
        let renderedDialog = EntryDisplay(dialog: dialog)
        renderedDialog.target = self
        renderedDialog.status = .NotShown
        self.insertDisplay(renderedDialog)
        self.finishedDisplayForDialog(dialog: dialog)
    }
    
    func clearChoices() -> Void
    {
        if let display = self.displayedDialogs.last,
           display.dialog.choices != nil,
           display.status == .OnHold {
            
            display.status = .Shown
            self.reloadView(display: display)
            self.finishedDisplayForDialog(dialog: display.dialog)
        }
    }
    
    func clearDisplays() -> Void
    {
        for display in self.displayedDialogs
        {
            display.remove()
        }
        self.displayedDialogs.removeAll();
    }
    
    func startConversation() -> Void
    {
        if !Labiba.enableCaching || ((Labiba.enableCaching && LocalCache.shared.displayedDialogs.isEmpty) || SharedPreference.shared.currentUserId != LocalCache.shared.conversationId) {
            self.botConnector.startConversation()
        } else {
            displayedDialogs = LocalCache.shared.displayedDialogs
            stepsToBeDisplayed = LocalCache.shared.stepsToBeDisplayed
            scrollToBottom()
        }
    }
    
    override func displayDialog(_ dialog:ConversationDialog ) -> Void
    {
        stepsToBeDisplayed.insert(dialog, at: 0)
        if (stepsToBeDisplayed.count == 1)
        {
            
            renderStep(step: dialog)
        }
    }
    
    func renderStep(step:ConversationDialog, wait:Double = 0.0) -> Void
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + wait)
        {
            if(step.cards?.presentation == .menu ) //CardsViewController.present(forDialog: step, andDelegate: self)
            {
                self.insertCellIntoTable(step: step)
                //                CardsViewController.present(forDialog: step, andDelegate: self)
                //                self.showTyping = false
                //                self.tableView.reloadData()
                //return
            }else if (step.cards?.presentation == .vmnue){
                
                let renderedDialog = EntryDisplay(dialog: step)
                renderedDialog.target = self
                if let items = step.cards?.items {
                    renderedDialog.height = Double(items.count)  * (Labiba.vMenuTableTheme.estimatedRowHeight + 20)
                }
                
                self.showTyping = false
                self.displayedDialogs.append(renderedDialog)
                self.tableView.reloadData()
                let index = IndexPath(row: self.displayedDialogs.endIndex, section: 0)

                
                
               
//                let cell = self.tableView.cellForRow(at: index)
//                self.tableView.scrollToRow(at: IndexPath(row: self.displayedDialogs.endIndex, section: 0), at: ., animated: true)
                if renderedDialog.height < self.tableView.frame.height - 50 {
                    DispatchQueue.main.async {
                        let scrollPoint = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height  )
                        self.tableView.setContentOffset(scrollPoint, animated: true)
                    }
                }else {
                    DispatchQueue.main.async {
                        let scrollPoint = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height - 350  )
                        self.tableView.setContentOffset(scrollPoint, animated: true)
                    }
                }

                if step.hasMessage
                {
                    self.finishedDisplayForDialog(dialog: step)
                }
            }
            else
            {
                // let holderStepMessage = step.message
                step.message?.removeArabicDiacritic()
                let renderedDialog = EntryDisplay(dialog: step)
                renderedDialog.target = self
                self.clearChoices()
                self.showTyping = false
                //            if self.displayedDialogs.count == 0 {
                self.displayedDialogs.append(renderedDialog)
                
                self.tableView.reloadData()
//                if !self.isFirstMessage{
                    DispatchQueue.main.async {
                        let scrollPoint = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height)
                        self.tableView.setContentOffset(scrollPoint, animated: true)
                    }
//                }
               
                //self.insertDisplay(renderedDialog)
                
                //            }else {
                //                let index = IndexPath(row: self.displayedDialogs.endIndex, section: 0)
                //                self.displayedDialogs.append(renderedDialog)
                //                self.tableView.insertRows(at: [index], with: .automatic)
                //                self.tableView.scrollToRow(at: index, at: .top, animated: true)
                //
                //            }
                
                if step.hasMessage
                {
                    self.finishedDisplayForDialog(dialog: step)
                }
            }
        }
    }
    
    func insertCellIntoTable(step: ConversationDialog)
    {
        let renderedDialog = EntryDisplay(dialog: step)
        renderedDialog.target = self
        self.clearChoices()
        self.showTyping = false
        self.insertDisplay(renderedDialog)
        if step.hasMessage
        {
            self.finishedDisplayForDialog(dialog: step)
        }
        
        
        
    }
    override func finishedDisplayForDialog(dialog: ConversationDialog)
    {
        if(stepsToBeDisplayed.count > 0)
        {
            stepsToBeDisplayed.removeLast()
        }
        
        if let step =  stepsToBeDisplayed.last
        {
            renderStep(step: step, wait: 0.05)
        }
    }
    
    func cardsViewController(_ cardsVC: CardsViewController, didSelectCard card: DialogCard, ofDialog dialog: ConversationDialog)
    {
        stopTTS_STT()
        let btn = card.buttons.first(where: { $0.payload != nil })!
        self.cardButton(btn, ofCard: card, wasSelectedForDialog: dialog)
    }
    
    func insertDisplay(_ display:EntryDisplay ) -> Void
    {
        self.displayedDialogs.append(display)
        self.tableView.reloadData()
        DispatchQueue.main.async {
            let scrollPoint = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height)
            self.tableView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    
    //MARK:titi choice selected
    override func choiceWasSelectedFor(display: EntryDisplay, choice: DialogChoice)
    {
        //  let livechat = LiveChatHandler()
        //  livechat.present()
        //  LabibaBotConnectorJC().testFayvoSecurity { (result) in
        //      print(result.isSuccess)
        //    }
        super.choiceWasSelectedFor(display: display, choice: choice)
        if  choice.action == nil{
            self.submitUserText(choice.title)
        }
    }
    
    
    override func cardButton(_ button: DialogCardButton, ofCard card: DialogCard, wasSelectedForDialog dialog: ConversationDialog)
    {
        canLunchRating = true
        self.myClearChoices()
        super.cardButton(button, ofCard: card, wasSelectedForDialog: dialog)
        
    }
    
    // set the selected card as a conversation titi next tesk is here
    func renderSelectedCardEntry(_ card: DialogCard)
    {
        if let lastDisplay = self.displayedDialogs.last
        {
            lastDisplay.status = .OnHold
        }
        
        let dialog = ConversationDialog(by: .user, time: Date())
        dialog.message = card.title
        
        let renderedDialog = EntryDisplay(dialog: dialog)
        renderedDialog.target = self
        renderedDialog.status = .NotShown
        
        self.insertDisplay(renderedDialog)
        self.finishedDisplayForDialog(dialog: dialog)
    }
    
    override func actionFailedFor(dialog: ConversationDialog)
    {
        self.finishedDisplayForDialog(dialog: dialog)
        let failDialog = ConversationDialog(by: .bot, time: Date())
        failDialog.message = "Sorry, couldn't perform this request at the moment."
        self.displayDialog(failDialog)
        self.finishedDisplayForDialog(dialog: failDialog)
    }
    
    func reloadView(display: EntryDisplay)
    {
        let targetIndex = self.displayedDialogs.firstIndex(of: display)!
        if let indices = self.tableView.indexPathsForVisibleRows
        {
            let rIndices = indices.filter { (index) -> Bool in
                return index.row == targetIndex
            }
            
            
            let show = self.showTyping
            self.insureTypingShow()
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: rIndices, with: .fade)
            self.tableView.endUpdates()
            self.showTyping = show
        }
    }
    
    func insureTypingShow() -> Void
    {
        let rows = self.tableView.numberOfRows(inSection: 0)
        let count = self.displayedDialogs.count
        self.showTyping = rows > count
    }
    
    func scrollToBottom() -> Void
    {
        let lastIndex = self.showTyping ? self.displayedDialogs.count : self.displayedDialogs.count - 1
        if (lastIndex >= 0)
        {
            let index = IndexPath(row: lastIndex, section: 0)
            guard index.row == (self.displayedDialogs.count - 1) else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
            {
                if(self.displayedDialogs.count > lastIndex)
                {
                    let display = self.displayedDialogs[lastIndex]
                    if let cards = display.dialog.cards
                    {
                        //                        if(cards.presentation == .menu) // i comment this in order to scrol when the dialog is carousal
                        //                        {
                        self.tableView.scrollToRow(at: index, at: .top, animated: true)
                        //                        }
                    }
                    
                    else
                    {
                        self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                    }
                }
                else
                {
                    
                    self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                    
                    
                }
            }
        }
    }
    
    func reloadTable() -> Void
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
        //        DispatchQueue.main.async
        //            {
        //                self.tableView.reloadData()
        //        }
    }
    
    override func botConnectorDidRecieveTypingActivity(_ botConnector: BotConnector)
    {
        self.showTyping = true
        self.reloadTable()
    }
    override func botConnectorRemoveTypingActivity(_ botConnector: BotConnector)
    {
        self.showTyping = false
        self.reloadTable()
    }
    
    
    override func botConnector(_ botConnector: BotConnector, didRecieveActivity dialog: ConversationDialog)
    {
        stopSTT()
        if isFirstMessage {
            isFirstMessage = false
            addInterationDialog(currentBotType:Labiba.Bot_Type)
        }
        
        if dialog.requestLocation && Labiba.backgroundLocationUpdate{
            LocationService.shared.checkLocationAccess(from: self, authorized: {
                LocationService.shared.delegate = self
                LocationService.shared.updateLocation()
            }, cancelWithoutAuthorization: {
                self.displayDialog(dialog)
            })
            return
        }
        
        if let message = dialog.message {
            Labiba.setLastMessageLangCode(message)
            if Labiba.Bot_Type != .keyboardType {
                if dialog.enableTTS {
                    TextToSpeechManeger.Shared.append(dialog: dialog)
                }
            }
        }
        self.displayDialog(dialog)
        
    }
    
    override func datePickerController(_ datePickerVC: DatePickerViewController, didSelectDate selectedDate: Date){
        super.datePickerController(datePickerVC, didSelectDate: selectedDate)
        self.clearChoices()
    }
    
    // MARK: DateRangeViewControllerDelegate
    
    override func dateRangeController(_ dateRangeVC: DateRangeViewController, didSelectRange selectedRange: DateRange)
    {
        super.dateRangeController(dateRangeVC, didSelectRange: selectedRange)
        self.clearChoices()
    }
    
    // MARK: LocationSelectViewControllerDelegate
    
    override func locationSelectDidReceiveAddress(_ address: String, atCoordinates coordinates: CLLocationCoordinate2D)
    {
        super.locationSelectDidReceiveAddress(address, atCoordinates: coordinates)
        self.clearChoices()
    }
    
    // MARK:ImageSelectorDelegate
    override func imageSelectorDidSelectImage(_ image: UIImage, fromSource source: UIImagePickerController.SourceType)
    {
        super.botConnector.sendPhoto(image)
        self.currentChoiceToken = nil
        
        let dialog = ConversationDialog(by: .user, time: Date())
        dialog.media = DialogMedia(type: .Photo)
        dialog.media?.image = image
        
        self.displayDialog(dialog)
        self.clearChoices()
    }
    
    
    
}

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate
{
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let lastIndex = self.showTyping ? self.displayedDialogs.count : self.displayedDialogs.count - 1
        if indexPath.row == lastIndex
        {
            if displayedDialogs.count > 0 { // to ensure that table content will scroll only once when cell presented for the first time
                if displayedDialogs[displayedDialogs.count - 1].status == .NotShown || self.showTyping{
                    if displayedDialogs[displayedDialogs.count - 1].height < self.tableView.frame.height - 50 {
                        DispatchQueue.main.async {
                            let scrollPoint = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height  )
                            self.tableView.setContentOffset(scrollPoint, animated: true)
                        }
                    }else {
                        DispatchQueue.main.async {
                            let scrollPoint = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height - 350  )
                            self.tableView.setContentOffset(scrollPoint, animated: true)
                        }
                    }
                }
            }
        }
        
        var isMenu = false
        var isVMenu = false
        if indexPath.row <  self.displayedDialogs.count
        {
            let display = self.displayedDialogs[indexPath.row]
            if let cards = display.dialog.cards
            {
                if(cards.presentation == .menu)
                {
                    isMenu = true
                }
                if(cards.presentation == .vmnue)
                {
                    isVMenu = true
                }
            }
        }
        
        if (isMenu)
        {
            var itemsCount:CGFloat = CGFloat(self.displayedDialogs[indexPath.row].dialog.cards?.items.count ?? 0)
            itemsCount = itemsCount < 3 ? 3 : itemsCount
            let minimumLineSpacing = (2 + 15*ipadFactor)
            let CellTableHeight = (ceil(itemsCount / 3.0) * ((UIScreen.main.bounds.width / 3.0) - 20 )) + CGFloat(ceil((itemsCount / 3.0)) * (15 + minimumLineSpacing)) - (ipadMargin)
            return CellTableHeight
        }else if(isVMenu){
            let count = displayedDialogs[indexPath.row].dialog.cards?.items.count ?? 0
            let cellHeight = (CGFloat(count) * Labiba.vMenuTableTheme.estimatedRowHeight) + 20
            return  cellHeight
            
        }
        else
        {
            if indexPath.row <  self.displayedDialogs.count
            {
                let entry = self.displayedDialogs[indexPath.row]
                return entry.height
                
            }
            else
            {
                return 50
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.showTyping ? self.displayedDialogs.count + 1 : self.displayedDialogs.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        maskImage.frame.origin.y = scrollView.contentOffset.y
        //print(scrollView.contentOffset.y)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.row <  self.displayedDialogs.count
        {
            let display = self.displayedDialogs[indexPath.row]
            if let cards = display.dialog.cards
            {
                
                if(cards.presentation == .menu)
                {
                    var cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell
                    if cell == nil
                    {
                        cell = CustomTableViewCell.customCell
                    }
                    cell?.updateCellWith(selectedDialogIndex: indexPath.row, displayedDialogs: display)
                    cell?.cellDelegate = self
                    
                    //
                    
                    return cell!
                }else if cards.presentation == .vmnue {
                    let cell = tableView.dequeueCell(withType: VMenuTableCell.self, for: indexPath)!
                    
                    
                    cell.setDate(selectedDialogIndex: indexPath.row, model: display)
                    cell.delegate = self
                    return cell
                }
                else
                {
                    display.delegate = nil
                    let cellReuseID = display.status.rawValue
                    let cell = (tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as! StateEntryCell)
                    cell.delegate = self
                    cell.displayEntry(display)
                    
                    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ConversationViewController.handleLongPress))
                    cell.addGestureRecognizer(longPress)
                    //longPress.cancelsTouchesInView = true
                    
                    return cell
                }
            }
            else
            {
                
                display.delegate = nil
                let cellReuseID = display.status.rawValue
                let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID, for: indexPath) as! StateEntryCell
                cell.delegate = self
                cell.displayEntry(display)
                
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ConversationViewController.handleLongPress))
                cell.addGestureRecognizer(longPress)
                //longPress.cancelsTouchesInView = true
                return cell
            }
            
            
        }
        else
        {
            print("TrackSteps Table cellForRowAt index path ore than displayed dialogs")
            return tableView.dequeueReusableCell(withIdentifier: "indicatorCell", for: indexPath) as! TypingIndicatorCell
        }
    }
    
    //tableview finished loading
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is TypingIndicatorCell
        {
            (cell as! TypingIndicatorCell).showLoadingIndicator()
        }
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Constants.NotificationNames.CheckMediaEndDisplaying, object: nil)
        
        if cell is TypingIndicatorCell {
            (cell as! TypingIndicatorCell).hideLoadingIndicator()
        }
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        if let index = tableView.indexPathForSelectedRow
        {
            let SelectedCellText = displayedDialogs[index.row].dialog.message
            UIPasteboard.general.string = SelectedCellText
            showToast(message : SelectedCellText!)
        }
    }
    
    func showToast(message : String)
    {
        
        let toastLabel = UILabel(frame: CGRect(x: 5, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 10, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 8.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
}

extension ConversationViewController: UserTextInputNoLocalDelegate
{
    func changeFromKeybordToVoiceType() {
        Labiba.Temporary_Bot_Type = Labiba.Bot_Type
        addInterationDialog(currentBotType: Labiba.Bot_Type)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var addedValue:CGFloat = -5
            switch UIScreen.current{
            case .iPhone5_8 ,.iPhone6_1 ,.iPhone6_5:
                addedValue = 15
            default:
                break
            }
            self.tableView.contentInset.bottom = keyboardSize.height + UserTextInputNoLocal.HEIGHT - addedValue - 20
            self.tavleViewBottomConst.constant = keyboardSize.height + UserTextInputNoLocal.HEIGHT - addedValue
            if self.displayedDialogs.count > 0 {
                let lastIndex = IndexPath(row: self.displayedDialogs.count - 1, section: 0)
                self.tableView.scrollToRow(at: lastIndex, at: .none, animated: false)
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //        UIView.animate(withDuration: 0.3) {
        //            self.tableView.transform = CGAffineTransform.identity
        //        }
        
        tavleViewBottomConst.constant = tableViewBottomInset
    }
    
    
    
    func UserTextType(TextType: UITextView)
    {
        // TextType.endEditing
        if (Constants.content_type != "" && Constants.content_type != "text")
        {
            let validate = Constants.content_type
            let splits = validate.split(separator: ",")
            let index0 = splits[0]
            if (index0 == "CALENDAR")
            {
                DatePickerViewController.present(withDelegate: self, mode: .date)
            }
        }
    }
    
    
    func userTextInput(_ dialog: UserTextInputNoLocal, didSubmitText text: String) {
        //        if Labiba.Bot_Type == .voiceAssistance {
        //            addInterationDialog(currentBotType: .voiceAssistance)
        //            Labiba.Temporary_Bot_Type = .voiceAssistance
        //        }
        self.submitUserText(text)
    }
    func userTextInput(_ dialog: UserTextInputNoLocal, didSubmitFile Url: URL) {
        self.botConnector.sendFile(Url)
    }
    func userTextInput(_ dialog: UserTextInputNoLocal, didSubmitVoice voice: String) {
        
        print("Local voice: " +  voice)
        
        let dialog = ConversationDialog(by: .user, time: Date())
        dialog.media = DialogMedia(type: .Audio)
        dialog.media?.localUrl = URL(fileURLWithPath: voice)
        
        let renderedDialog = EntryDisplay(dialog: dialog)
        renderedDialog.target = self
        renderedDialog.status = .OnHold
        renderedDialog.loadingStatus = .loading
        
        self.clearChoices()
        
        self.showTyping = false
        self.insertDisplay(renderedDialog)
        self.finishedDisplayForDialog(dialog: dialog)
        self.scrollToBottom()
        
        self.botConnector.sendVoice(voice) { (remotePath) in
            
            renderedDialog.loadingStatus = remotePath != nil ? .success : .failed
            renderedDialog.status = .Shown
        }
    }
    
    func userTextInput(_ dialog: UserTextInputNoLocal, didSubmitImage image: UIImage) {
        
        self.botConnector.sendPhoto(image)
        
        let dialog = ConversationDialog(by: .user, time: Date())
        dialog.media = DialogMedia(type: .Photo)
        dialog.media?.image = image
        
        self.displayDialog(dialog)
        self.clearChoices()
    }
    
    func userTextInput(_ dialog: UserTextInputNoLocal, didSubmitLocation location: CLLocationCoordinate2D) {
        
        self.botConnector.sendLocation(location)
        
        let dialog = ConversationDialog(by: .user, time: Date())
        dialog.map = DialogMap(coordinate: location, address: "",distance: "")
        
        self.displayDialog(dialog)
        self.clearChoices()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.scrollToBottom()
        }
    }
    
    func userTextInputRequiresBottomSize(_ dialog: UserTextInputNoLocal, withHeight height: CGFloat) {
        //  self.bottomConstraint.constant = height + 15.0
    }
    
    func submitLocalUserText(_ text:String) {
        let dialog = ConversationDialog(by: .user, time: Date())
        dialog.message = text
        self.displayDialog(dialog)
    }
    
    func submitUserText(_ text:String) -> Void
    {
        
        canLunchRating = true
        stopTTS_STT()
        let goodText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if (Constants.content_type != "" && Constants.content_type != "text"){
            if Constants.content_type.contains(",") {
                let validate = Constants.content_type
                let splits = validate.split(separator: ",")
                let index0 = splits[0]
                let index1 = splits[1]
                let index2 = splits[2]
                let chracters = String(index1)
                let counter = String(index2)
                let count = Int(counter)
                guard chracters != "" else {return}
                guard counter != "" else {return}
                if (!goodText.isvalidinput(vaalidation: chracters) && goodText.count <= count ?? 0)
                {
                    self.botConnector.sendMessage(goodText)
                    let dialog = ConversationDialog(by: .user, time: Date())
                    dialog.message = goodText
                    self.clearChoices()
                    self.displayDialog(dialog)
                }
                else
                {
                    if (index0 == "N")
                    {
                        showErrorMessage("You Should Enter A Valid Number & Must be At not more than ".local + "\(count ?? 0)" + "Character".local)
                    }
                    else if (index0 == "N_CHAR")
                    {
                        showErrorMessage("You Should Enter A Valid Characters and Numbers & Must be At not more than ".local + "\(count ?? 0)" + "Character".local)
                    }
                    else if (index0 == "N_CHAR_AR")
                    {
                        showErrorMessage("You Should Enter A Valid Characters and Numbers & Must be At not more than ".local + "\(count ?? 0)" + "Character".local)
                    }
                    else if (index0 == "CHAR_AR")
                    {
                        showErrorMessage("You Should Enter A Valid Arabic Characters  & Must be At not more than ".local + "\(count ?? 0))" + "Character".local)
                    }
                    else if (index0 == "CHAR")
                    {
                        showErrorMessage("You Should Enter A Valid Characters & Must be At not more than ".local + "\(count ?? 0)" + "Character".local)
                    }
                    else if (index0 == "CALENDAR")
                    {
                        showErrorMessage("You Should Enter A Valid Date & Must be At not more than ".local + "\(count ?? 0)" + "Character".local)
                    }
                    else if (index0 == "user_phone_number")
                    {
                        showErrorMessage("You Should Enter A Valid Numbers & Must be At not more than ".local + "\(count ?? 0)" + "Character".local)
                    }
                    else if (index0 == "user_email")
                    {
                        showErrorMessage("You Should Enter A Valid Mail & Must be At not more than ".local + "\(count ?? 0)" + "Character".local)
                    }
                    else
                    {
                        showErrorMessage("You Should Enter A Valid Text".local)
                    }
                }
            }
            else
            {
                //                self.botConnector.sendMessage(goodText)
                //                let dialog = ConversationDialog(by: .user, time: Date())
                //                dialog.message = goodText
                //                self.clearChoices()
                //                self.displayDialog(dialog)
                displayUserInput(text: goodText)
            }
        }
        else
        {
            displayUserInput(text: goodText)
        }
        
    }
    
    func displayUserInput(text:String)  {
        self.myClearChoices()
        //self.clearChoices()
        let dialog = ConversationDialog(by: .user, time: Date())
        dialog.message = text
        //self.displayDialog(dialog)
        self.displayMyDialog(dialog)
        self.botConnector.sendMessage(text)
    }
    ////////////////////////////////////////////////////////////////////
    
    
    func displayMyDialog(_ dialog:ConversationDialog ) -> Void
    {
        stepsToBeDisplayed.insert(dialog, at: 0)
        if (stepsToBeDisplayed.count == 1)
        {
            let renderedDialog = EntryDisplay(dialog: dialog)
            renderedDialog.target = self
            //self.clearChoices()
            self.showTyping = false
            self.insertDisplay(renderedDialog)
            if dialog.hasMessage
            {
                self.finishedDisplayForDialog(dialog: dialog)
            }
        }
    }
    
    
    
    
    func myClearChoices()
    {
        if let display = self.displayedDialogs.last,
           display.dialog.choices != nil
        {
            // if display.status == .OnHold {
            display.status = .Shown
            // }
            self.MyReloadView(display: display)
        }
        
    }
    
    func MyReloadView(display: EntryDisplay)
    {
        // comment to remove wired behaviour after select button from choices
        
        //        let targetIndex = self.displayedDialogs.firstIndex(of: display)!
        //        if let indices = self.tableView.indexPathsForVisibleRows
        //        {
        
        //            let rIndices = indices.filter { (index) -> Bool in
        //                return index.row == targetIndex - 1
        //            }
        
        let show = self.showTyping
        self.insureTypingShow()
        //            self.tableView.beginUpdates()
        //            self.tableView.reloadRows(at: rIndices, with: .fade)
        //            self.tableView.endUpdates()
        self.showTyping = show
        //        }
    }
    
    
    ////////////////////////////////////////////////////////////////////
    
}

extension ConversationViewController: VoiceAssistantKeyboardDelegate
{
    func voiceAssistantKeyboard(_ dialog: UIView, didSubmitText text: String) {
        self.submitUserText(text)
    }
    
    func voiceAssistantKeyboard(_ dialog: UIView, didSubmitFile url: URL) {
        //        let dialog = ConversationDialog(by: .user, time: Date())
        //        dialog.attachment = AttachmentCard(link: url.absoluteString)
        //       let display = EntryDisplay(dialog: dialog)
        //       // display.status = .Shown
        //        insertDisplay(display)
        //        // self.displayDialog(dialog)
        self.botConnector.sendFile(url)
    }
    
    func voiceAssistantKeyboardWillShow(keyboardHight: CGFloat) {
        var addedValue:CGFloat = -5
        switch UIScreen.current{
        case .iPhone5_8 ,.iPhone6_1 ,.iPhone6_5:
            addedValue = 15
        default:
            break
        }
        self.tavleViewBottomConst.constant = keyboardHight + VisualizerVoiceAssistantView.INPUT_HEIGHT - addedValue - 20
        self.tableView.contentInset.bottom = keyboardHight + VisualizerVoiceAssistantView.INPUT_HEIGHT - addedValue
        if self.displayedDialogs.count > 0 {
            let lastIndex = IndexPath(row: self.displayedDialogs.count - 1, section: 0)
            self.tableView.scrollToRow(at: lastIndex, at: .none, animated: false)
        }
    }
    
    func voiceAssistantKeyboardWillHide() {
        self.tavleViewBottomConst.constant = visualizerDialog.orginalBottomMargin + 30
        tableView.contentInset.bottom = visualizerDialog.orginalBottomMargin + 50
    }
}

extension ConversationViewController : RadiusViewControllerDelegate {
    
    func submitChoiceToken(_ value:String) -> Void
    {
        guard let token = self.currentChoiceToken else
        {
            return
        }
        self.botConnector.sendMessage(token + value)
        self.currentChoiceToken = nil
    }
    
    
    func radiusController(_ radiusVC: RadiusViewController, didSelectLocation location: CLLocationCoordinate2D, withDistance distance: Double)
    {
        let text = "\(location.latitude),\(location.longitude),\(distance)"
        self.submitChoiceToken(text)
        
        let dialog = ConversationDialog(by: .user, time: Date())
        dialog.map = DialogMap(coordinate: location, address: text,distance:"")
        
        self.displayDialog(dialog)
        self.clearChoices()
    }
    
    
    
    func CustomMapPickerIsSelected(_ address: String, atCoordinates coordinates: CLLocationCoordinate2D, Radius: String)
    {
        //titi   //تعديل
        let text = "\(coordinates.latitude),\(coordinates.longitude),\(address)"
        self.submitChoiceToken(text)
        
        let dialog = ConversationDialog(by: .user, time: Date())
        dialog.map = DialogMap(coordinate: coordinates, address: address,distance:Radius)
        
        self.displayDialog(dialog)
        self.clearChoices()
    }
    
    
}

extension ConversationViewController : VoiceRecognitionProtocol {
    func finishRecognitionWithText(text: String) {
        //        let regex = try! NSRegularExpression(pattern: "[\\u00a0]", options: NSRegularExpression.Options.caseInsensitive)
        //        let range = NSMakeRange(0, text.unicodeScalars.count)
        //        let modString = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
        //        let t = modString
        self.submitUserText(text)
    }
    func didRecognizeText(text: String) {}
    func didStartSpeechToText() {}
    func didStopRecording() {}
    func changeFromVoiceToKeyboardType() {
        Labiba.Temporary_Bot_Type = .keyboardType
        addInterationDialog(currentBotType: .keyboardType)
    }
    
}

extension UIImage
{
    enum JPEGQuality: CGFloat
    {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data?
    {
        // return UIImageJPEGRepresentation(self, quality.rawValue)
        return self.jpegData(compressionQuality: quality.rawValue)
    }
}


extension ConversationViewController: SubViewControllerDelegate {
    func SubViewDidAppear() {
        TextToSpeechManeger.Shared.setVolume(volume: 0)
        Labiba.EnableAutoListening
    }
    func subViewDidDisappear(){
        botConnector.delegate = self
        TextToSpeechManeger.Shared.setVolume(volume: isTTSMuted ? 0 : 1)
    }
    
}



//extension ConversationViewController: CNContactViewControllerDelegate{
//    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
//        self.dismiss(animated: true, completion: nil)
//    }
//}
