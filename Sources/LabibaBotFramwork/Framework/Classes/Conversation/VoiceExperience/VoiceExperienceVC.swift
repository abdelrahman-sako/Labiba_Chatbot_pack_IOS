//
//  VoiceExperienceVC.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 4/23/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit

class VoiceExperienceVC: BaseConversationVC {
    
    public static func create() -> VoiceExperienceVC
    {
        return Labiba.voiceExperienceStoryboard.instantiateViewController(withIdentifier: "VoiceExperienceVC") as! VoiceExperienceVC
    }
    
    // MARK: -IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var reusableView: UIView!
    @IBOutlet weak var reusableStackView: UIStackView!
    
  
//    var closeHandler:Labiba.ConversationCloseHandler?
    var stepsToBeDisplayed = [ConversationDialog]()
    var isDialogCurrentlyDisplayed:Bool = false
//    override var displayDialog2: (ConversationDialog) -> Void = {conversation in
//
//    }
    // MARK: -SubViews
    
    var lastMessageView:MessageView?
    
    lazy var voiceAssistantView = VoiceExperienceView.create()
    lazy var reusableItemsView = StateNotShownEntryCell()
    lazy var menuCardsContainerView = UIView()
    lazy var menuCardsView =  UINib(nibName: "CustomTableViewCell", bundle: Labiba.bundle).instantiate(withOwner: nil, options: nil).first as! CustomTableViewCell
     var testImageView = UIImageView()
    var dispalyEntry:EntryDisplay?
    
    var reusableItemsViewHightCons:NSLayoutConstraint?
    var menuCardsViewHightCons:NSLayoutConstraint?
    
    // MARK: -View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.botConnector.delegate = self
        voiceAssistantView.delegate = self
        reusableItemsView.delegate = self
        UIConfiguration()
        addObservers()
        self.navigationController?.isNavigationBarHidden = true
        startConversation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        voiceAssistantView.popUp(on: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addArrangedSubviews()
    }
    
    // MARK:- UI Configuration
    func UIConfiguration()  {
        scrollView.contentInset.top = 30
        scrollView.contentInset.bottom = voiceAssistantView.totalHight
      
        applayChatBackgroundColor()
    }
    
    func applayChatBackgroundColor()  {
        switch Labiba.BackgroundView.background {
        case .solid(color: let color):
            self.view.backgroundColor = color
        case .gradient(gradientSpecs: let grad):
            self.view.applyDynamicGradient(colors: grad.colors, locations: grad.locations as [NSNumber], startPoint: CGPoint(x: 0, y: 0), endPoint:  CGPoint(x: 0, y: 1))
        case .image(image: _):
            break
        }
//        if let grad = Labiba._ChatMainBackgroundGradient
//        {
//            self.view.applyDynamicGradient(colors: grad.colors, locations: grad.locations as [NSNumber], startPoint: CGPoint(x: 0, y: 0), endPoint:  CGPoint(x: 0, y: 1))
//        }
//        else if let bgColor = Labiba._ChatMainBackgroundColor
//        {
//            self.view.backgroundColor = bgColor
//        }
    }
    
    func addArrangedSubviews()  {
        
        self.reusableStackView.insertArrangedSubview(reusableItemsView, at:0)
        reusableItemsViewHightCons =  reusableItemsView.heightAnchor.constraint(equalToConstant: 1)
        self.view.addConstraint(reusableItemsViewHightCons!)
        
       // important note : we must add menuCardsView inside a container because menuCardsView is tableViewCell which contentView width will be zero inside the stack
        menuCardsContainerView.backgroundColor = .clear
        menuCardsView.backgroundColor = .clear
        self.reusableStackView.insertArrangedSubview(menuCardsContainerView, at:1)
        menuCardsContainerView.addSubview(menuCardsView)
        menuCardsView.frame = menuCardsContainerView.bounds
        menuCardsView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        menuCardsViewHightCons =  menuCardsContainerView.heightAnchor.constraint(equalToConstant: 1)
        self.view.addConstraint(menuCardsViewHightCons!)
        
    }
    
    func setReusableItemConst(constant:CGFloat,withAnimation animation:Bool = true){
        reusableItemsViewHightCons?.constant = constant
       // reusableItemsView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
               // self.reusableItemsView.alpha = 1
            }, completion: nil)
        }
    }
    
    func setMenuViewConst(constant:CGFloat,withAnimation animation:Bool = true){
        menuCardsViewHightCons?.constant = constant
        UIView.animate(withDuration: 0.4) {
             self.view.layoutIfNeeded()
        }
    }
    
    func hideReusableItemsView()  {
        UIView.animate(withDuration: 0.2) {
            self.reusableItemsView.alpha = 0
        }
        reusableItemsView.isUserInteractionEnabled = false
    }
    
    func showReusableItemsView()  {
        UIView.animate(withDuration: 0.2) {
            self.reusableItemsView.alpha = 1
        }
        reusableItemsView.isUserInteractionEnabled = true
        
    }
    
    func hideMenuView()  {
        UIView.animate(withDuration: 0.2) {
            self.menuCardsContainerView.alpha = 0
        }
        menuCardsContainerView.isUserInteractionEnabled = false
    }
    
    func showMenuView()  {
        UIView.animate(withDuration: 0.2) {
            self.menuCardsContainerView.alpha = 1
        }
        menuCardsContainerView.isUserInteractionEnabled = true
        
    }
    
    
    // MARK:- Start Conversation
    func startConversation(){
        self.botConnector.startConversation()
    }
    
    override func displayDialog(_ dialog: ConversationDialog) {
        //        reusableItemsView.isHidden = true
        if dialog.party == .bot {
            stepsToBeDisplayed.append(dialog)
            if dialog.choices?.count  ?? 0 > 0 {
                let choicesDialog = ConversationDialog(by: .bot, time: Date())
                choicesDialog.choices = dialog.choices
                stepsToBeDisplayed.append(choicesDialog)
                dialog.choices = nil
            }
            addCardAnimation(dialog: dialog)
            renderStep(withDialog: dialog)
        }
    }
    
    func addCardAnimation( dialog: ConversationDialog)  {
        if dialog.cards != nil {
            let labelSpringAnimationIn = CASpringAnimation(keyPath: "position.x")
            labelSpringAnimationIn.fromValue =  -(50.0 )
            labelSpringAnimationIn.duration = 5.0
            labelSpringAnimationIn.initialVelocity = 1.0
            labelSpringAnimationIn.damping = 15
            dialog.inAnimations = [labelSpringAnimationIn]
        }
    }
    
    func renderStep(withDialog dialog:ConversationDialog)  {
        if  let message = dialog.message {
           // Labiba.setLastMessageLangCode(message)
            if !isDialogCurrentlyDisplayed {
                displayNextDialog()
            }
        }else if stepsToBeDisplayed.count == 1 && !isDialogCurrentlyDisplayed  {
            displayNextDialog()
                }
//        else if stepsToBeDisplayed.count <= 2  {
//            if !isDialogCurrentlyDisplayed || stepsToBeDisplayed.count == 1  {
//                          // displayNextDialog()
//            }
//        }
    }
    
    
    
    func displayNextDialog()  {
        if stepsToBeDisplayed.count > 0, let message = stepsToBeDisplayed[0].message , message.isEmpty {
            // to handel empty messages , ut there must not any empty message :(
            stepsToBeDisplayed.remove(at: 0)
            isDialogCurrentlyDisplayed =  false
        }
        if stepsToBeDisplayed.count > 0 {
            isDialogCurrentlyDisplayed =  stepsToBeDisplayed[0].party == .bot
            if stepsToBeDisplayed.count > 0, let message = stepsToBeDisplayed[0].message{
                if stepsToBeDisplayed.count > 0, stepsToBeDisplayed[0].enableTTS {
                    TextToSpeechManeger.Shared.append(dialog: stepsToBeDisplayed[0])
                }
                
                self.insertMessageView(role: .bot, message: message)
                setReusableItemConst(constant: 0)
                if stepsToBeDisplayed.count > 0, let _ = stepsToBeDisplayed[0].choices {
                    displayChoices(inDialog: stepsToBeDisplayed[0])
                }
                stepsToBeDisplayed.remove(at: 0)
                    if stepsToBeDisplayed.count > 0, stepsToBeDisplayed[0].message?.isEmpty ?? true {
                        if stepsToBeDisplayed[0].cards?.presentation == .menu{
                          // displayMenu(inDialog: stepsToBeDisplayed[0])
                            return
                        }
                      //  displayCard(inDialog: stepsToBeDisplayed[0])
                    }
            }else{
                if stepsToBeDisplayed.count > 0, stepsToBeDisplayed[0].cards?.presentation == .menu{
                   displayMenu(inDialog: stepsToBeDisplayed[0])
                    return
                }
                if stepsToBeDisplayed.count > 0, let _ = stepsToBeDisplayed[0].choices {
                    displayChoices(inDialog: stepsToBeDisplayed[0])
                    return
                }
                if let media = stepsToBeDisplayed[0].media {
                    displayMedia(inDialog: stepsToBeDisplayed[0])
                    return
                }
                displayCard(inDialog: stepsToBeDisplayed[0])
            }
        }else{
            isDialogCurrentlyDisplayed =  false
        }
        
    }
    
    func displayCard(inDialog dialog:ConversationDialog) {
        dispalyEntry = EntryDisplay(dialog: dialog)
        reusableItemsView.displayEntry(dispalyEntry!)
        //reusableItemsView.isHidden = false
     //   showReusableItemsView()
        stepsToBeDisplayed.remove(at: 0)
    }
    func displayChoices(inDialog dialog:ConversationDialog) {
        dispalyEntry = EntryDisplay(dialog: dialog)
        dispalyEntry?.dialog.message = nil
        reusableItemsView.displayEntry(dispalyEntry!)
       // reusableItemsView.isHidden = false
        showReusableItemsView()
        stepsToBeDisplayed.remove(at: 0)
        setReusableItemConst(constant: dispalyEntry?.height ?? 0)
    }
    
    func displayMenu(inDialog dialog:ConversationDialog)  {
        menuCardsView.isFirstReloading = true
        dispalyEntry = EntryDisplay(dialog: dialog)
        menuCardsView.cellDelegate = self
        menuCardsView.backgroundColor = .red
       // menuCardsContainerView.isHidden = false
        self.menuCardsView.updateCellWith(selectedDialogIndex: 0, displayedDialogs: self.dispalyEntry!)
    }
    
    func displayMedia(inDialog dialog:ConversationDialog)  {
        
        if let path = dialog.media?.url , let url = URL(string: path)  {
            let width = self.view.frame.width
            let mediaView = VedioPlayerView( size: CGSize(width: width , height: width*0.8), url: url)
            mediaView.bounds = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width)
            self.reusableStackView.addArrangedSubview(mediaView)


        }
      // displayMapPreview(inDialog: dialog)
    }
    
    func displayMapPreview(inDialog dialog:ConversationDialog)  {
        let mapView = MapPerviewView.create()
        self.reusableStackView.addArrangedSubview(mapView)
        
        let model = MapPreviewModel(latitude: 32.020231, longitude: 35.859971, title: "Imagine", subtitle: "Khalda un alsommaq sdkjhf skdfjskjf sfkjsfjk shjdfgjhsf fshfsfsfs fjhs fjhs fshf sjhfd sjhf shjdf shjdf sjhdf sjhdf sjhdf jshd sjhfd sjhd shjdf ")
        mapView.updateWithLocation(model: model)
    }
    
    
    func insertMessageView(role:MessageView.Role , message:String)  {
        let messageView = MessageView.create()
        messageView.currentRole = role
        messageView.message = message
        if let lastMessageView = lastMessageView {
            var lastIndex = reusableStackView.subviews.lastIndex(of: lastMessageView) ?? 0
            lastIndex = lastIndex > 0 ? lastIndex - 1 : lastIndex
            print("lastIndex   " , lastIndex)
            self.reusableStackView.insertArrangedSubview(messageView, at: lastIndex)
        }else{
            self.reusableStackView.insertArrangedSubview(messageView, at: 0)
        }
        
        
        lastMessageView = messageView
    }
    
    func deleteFirstMessageView()  {
        var messageViewsCount = 0
        var topArrangedSubview:UIView?
        for (index,subview) in reusableStackView.subviews.enumerated() {
            if subview is MessageView {
                if topArrangedSubview == nil {
                    topArrangedSubview = subview
                }
                messageViewsCount += 1
            }
            if subview is StateNotShownEntryCell {
                print("StateNotShownEntryCell  " , index)
            }
        }
        if messageViewsCount >= 3 {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: [], animations: {
                topArrangedSubview?.transform = CGAffineTransform(translationX: 0, y: -40)
                topArrangedSubview?.isHidden = true
                topArrangedSubview?.alpha = 0
                self.reusableStackView.layoutIfNeeded()
            }) { (_) in
                topArrangedSubview?.removeFromSuperview()
            }
        }else {
            var lastRole:MessageView.Role?
            var sameTypeMessageDuplicated:Bool = false
            for subview in reusableStackView.subviews {
                if subview is MessageView {
                    if lastRole == (subview as! MessageView).currentRole {
                        sameTypeMessageDuplicated = true
                    }
                    lastRole =  (subview as! MessageView).currentRole
                }
            }
            if sameTypeMessageDuplicated {
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: [], animations: {
                    topArrangedSubview?.transform = CGAffineTransform(translationX: 0, y: -50)
                    topArrangedSubview?.isHidden = true
                    topArrangedSubview?.alpha = 0
                    self.reusableStackView.layoutIfNeeded()
                }) { (_) in
                    topArrangedSubview?.removeFromSuperview()
                }
            }
        }
    }
    func resetChat()  {
        for subview in reusableStackView.subviews {
            if let view = subview as? VoiceExperienceBaseView    {
                view.removeWithAnimation()
            }else{
              hideReusableItemsView()
            }
            
        }
       // lastMessageView?.removeFromSuperview()
        stepsToBeDisplayed.removeAll()
    }
    func submitUserText(_ text:String) -> Void {
      //  reusableItemsView.isHidden = true
        setMenuViewConst(constant: 0)
        let goodText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.botConnector.sendMessage(goodText)
    }
    
    
    
    
    
    
     // MARK:- Observers
    func addObservers() {
        NotificationCenter.default.addObserver(forName: Constants.NotificationNames.FinishCurrentTextToSpeechPhrase, object: nil, queue: OperationQueue.main) { (notification) in
             self.isDialogCurrentlyDisplayed =  false
            self.lastMessageView?.transitionToOrigin { (_) in
                
                           self.displayNextDialog()
            }
            
            self.deleteFirstMessageView()
           
        }
    }
    
    //MARK:-  override EntryTableViewCellDelegate methods
    
    override func choiceWasSelectedFor(display: EntryDisplay, choice: DialogChoice) {
        isDialogCurrentlyDisplayed = false
       // hideReusableItemsView()
        resetChat()
        super.choiceWasSelectedFor(display: display, choice: choice)
        if  choice.action == nil{
            self.botConnector.sendMessage(choice.title)
        }
    }
    
    override func cardButton(_ button: DialogCardButton, ofCard card: DialogCard, wasSelectedForDialog dialog: ConversationDialog) {
        if stepsToBeDisplayed.count > 0 {
            stepsToBeDisplayed.remove(at: 0)
        }
        if  (button.url != nil &&  URL(string: button.url ?? "") != nil) || button.type == .phoneNumber || button.type == .email || button.type == .createPost   {
            super.cardButton(button, ofCard:card, wasSelectedForDialog :dialog)
            return
        }
        isDialogCurrentlyDisplayed = false
        UIView.animate(withDuration: 0.2, animations: {
            self.reusableItemsView.alpha = 0
        }) { (_) in
            //self.hideReusableItemsView()
            self.resetChat()
        }
        //  reusableItemsView.isHidden = true
        super.cardButton(button, ofCard:card, wasSelectedForDialog :dialog)
    }
    
    override func actionFailedFor(dialog: ConversationDialog) {
        super.actionFailedFor(dialog: dialog)
    }
    
    override func finishedDisplayForDialog(dialog: ConversationDialog) {
        super.finishedDisplayForDialog(dialog: dialog)
        if dialog.choices != nil || (dialog.cards != nil && dialog.cards?.presentation != .menu) {
                 // reusableItemsView.isHidden = false
            showReusableItemsView()
                setReusableItemConst(constant: dispalyEntry?.height ?? 0)
          
                reusableItemsView.layoutSubviews()
          
                      print("dispalyEntry?.height ==========================   " ,dispalyEntry?.height)
        }else if dialog.cards?.presentation == .menu {
            var itemsCount:CGFloat = CGFloat(dialog.cards?.items.count ?? 0)
            itemsCount = itemsCount < 3 ? 3 : itemsCount
            let minimumLineSpacing = (2 + 15*ipadFactor)
            let menuHight = (ceil(itemsCount / 3.0) * ((UIScreen.main.bounds.width / 3.0) - 20 )) + CGFloat(ceil((itemsCount / 3.0)) * (15 + minimumLineSpacing)) - (ipadMargin) + 100
            showMenuView()
            setReusableItemConst(constant: 0)
            setMenuViewConst(constant: menuHight)
        }
        
    }
     // MARK:- override CustomCollectionCellDelegate methods
    override func collectionView(dialogIndex: Int, selectedCardIndex: Int, selectedCellDialogCardButton: DialogCardButton?, didTappedInTableview TableCell: CustomTableViewCell) {
        if stepsToBeDisplayed.count > 0 {
            stepsToBeDisplayed.remove(at: 0)
        }
        isDialogCurrentlyDisplayed = false
        hideMenuView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.setMenuViewConst(constant: 0)

        }
        super.collectionView(dialogIndex: dialogIndex, selectedCardIndex: selectedCardIndex, selectedCellDialogCardButton: selectedCellDialogCardButton, didTappedInTableview: TableCell)
    }
    
    // MARK:- Actions
    @IBAction func viewDidTap(_ sender: Any)
      {
        print("viewDidTap")
          self.view.endEditing(true)
      }
    
    
//}
 


//MARK:-   BotConnectorDelegate implementation

//extension VoiceExperienceVC: BotConnectorDelegate{
    override func botConnector(_ botConnector: BotConnector, didRecieveActivity activity: ConversationDialog) {
        if let message =  activity.message , !message.isEmpty {
            if lastMessageView?.currentRole == .user ,!(lastMessageView?.didComplete ?? true) {
                lastMessageView?.removeFromSuperview()
                for subview in reusableStackView.subviews {
                    if subview is MessageView {
                        lastMessageView = subview as? MessageView
                    }
                }
            }
        }
        displayDialog(activity)
    }
    
    override func botConnectorDidRecieveTypingActivity(_ botConnector: BotConnector) {
        
    }
}

//MARK:-   VoiceRecognitionProtocol implementation

extension VoiceExperienceVC: VoiceAssistantKeyboardDelegate{
    func voiceAssistantKeyboard(_ dialog: UIView, didSubmitText text: String) {
        let delay =  0.5
        resetChat()
        stopTTS_STT()
        stepsToBeDisplayed.removeAll()
        isDialogCurrentlyDisplayed =  false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.insertMessageView(role: .user, message: text)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                 self?.submitUserText(text)
                self?.lastMessageView?.transitionToOrigin { (_) in
                }
            }
            
            
           
        }
        
        deleteFirstMessageView()
    }
    
    func voiceAssistantKeyboardWillShow(keyboardHight: CGFloat) {
        var addedValue:CGFloat = -5
        switch UIScreen.current{
        case .iPhone5_8 ,.iPhone6_1 ,.iPhone6_5:
            addedValue = 15
        default:
            break
        }
        self.scrollView.contentInset.bottom = keyboardHight + VoiceExperienceView.INPUT_HEIGHT - addedValue //- 80
        let lastView:UIView = scrollView.subviews.last!
        
        self.scrollView.scrollRectToVisible(lastView.frame, animated: true)
    }
    
    func voiceAssistantKeyboardWillHide() {
        scrollView.contentInset.bottom = voiceAssistantView.totalHight
    }
    
    func finishRecognitionWithText(text: String) {
        submitUserText(text)
        lastMessageView?.transitionToOrigin { (_) in
        }
        deleteFirstMessageView()
    }
    
    func didStartSpeechToText() {
        stepsToBeDisplayed.removeAll()
        isDialogCurrentlyDisplayed =  false
        resetChat()
        insertMessageView(role: .user, message: "")
    }
    
    func didRecognizeText(text: String) {
        if lastMessageView?.currentRole == .user {
            lastMessageView?.setMessage(message: text)
        }
    }
    
    func didStopRecording() {
        
    }
    func changeFromVoiceToKeyboardType() {}
    
    
}

//extension VoiceExperienceVC: EntryTableViewCellDelegate {
//    func choiceWasSelectedFor(display: EntryDisplay, choice: DialogChoice) {
//        print(choice.title)
//    }
//
//    func cardButton(_ button: DialogCardButton, ofCard card: DialogCard, wasSelectedForDialog dialog: ConversationDialog) {
//        print(card.title)
//    }
//
//    func actionFailedFor(dialog: ConversationDialog) {
//        print("falie")
//    }
//
//    func finishedDisplayForDialog(dialog: ConversationDialog) {
//         print("finish")
//    }
//}
