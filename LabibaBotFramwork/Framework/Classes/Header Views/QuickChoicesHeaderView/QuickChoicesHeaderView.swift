//
//  QuickChoicesHeaderView.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman Qasem on 9/3/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//

import UIKit

class QuickChoicesHeaderView: LabibaChatHeaderView {
    public static func create(centerImageURL:String? = nil ,centerImage:UIImage? = nil  ,backgroundImgURL:String? = nil) -> QuickChoicesHeaderView
       {
           let view = UIView.loadFromNibNamedFromDefaultBundle("QuickChoicesHeaderView") as! QuickChoicesHeaderView
           if let imageURL = centerImageURL ,let url = URL(string: imageURL) {
               view.centerImageView.af_setImage(withURL: url)
           }else if let image = centerImage{
               view.centerImageView.image = image
           }
           view.resetUIs()
           view.applySemanticAccordingToBotLang()
           if let url = URL(string: backgroundImgURL ?? "")  {
               view.backgroundImage.isHidden = false
               view.backgroundImage.backgroundColor = .darkGray
               view.backgroundImage.af_setImage(withURL: url)
           }else{
               view.backGroundView.applyDynamicGradient(colors: Labiba._headerBackgroundGradient?.colors ?? [] , locations: Labiba._headerBackgroundGradient?.locations as [NSNumber]?, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
           }
         
           view.muteButton.isHidden = Labiba.isMuteButtonHidden
           return view
       }

     
       
       

       
       @IBOutlet public weak var centerImageView: UIImageView!
       @IBOutlet public weak var centerImageTopCons: NSLayoutConstraint!
       @IBOutlet public weak var centerImageWidthCons: NSLayoutConstraint!
       @IBOutlet weak var backGroundView: UIView!
       @IBOutlet public weak var homeButton: UIButton!
       @IBOutlet public weak var settingButton: UIButton!
       @IBOutlet public weak var vedioCallButton: UIButton!
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
       
     @IBOutlet weak var choicesCollectionView: UICollectionView!
    
       var choices:[String] = []
       public var volumUpImage:UIImage? {
           didSet {
              muteButton.setImage(volumUpImage , for: .normal)
           }
       }
       public var volumOffImage:UIImage?
      
       private var IsViewFliped:Bool = false
      
       
       public override func awakeFromNib() {
        
        collectionViewConfeguration()
        
           homeButton.tintColor = Labiba._HeaderTintColor
           settingButton.tintColor = Labiba._HeaderTintColor
           closeButton.tintColor = Labiba._HeaderTintColor
           muteButton.tintColor =  Labiba._HeaderTintColor
            vedioCallButton.tintColor =  Labiba._HeaderTintColor
           vedioCallButton.imageView?.contentMode = .scaleAspectFit
       }
      
    func collectionViewConfeguration()  {
        choicesCollectionView.delegate = self
        choicesCollectionView.dataSource = self
        choicesCollectionView.isUserInteractionEnabled = true
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        
        layout.sectionInset =  UIEdgeInsets(top: 0, left:  10 , bottom: 0, right:  10)
        choicesCollectionView.collectionViewLayout = layout
        let nib = UINib(nibName: "HeaderQuickChoiceCell", bundle: Labiba.bundle)
        choicesCollectionView.register(nib, forCellWithReuseIdentifier: "HeaderQuickChoiceCell")
    }
       
       override func  restartApplication(){
           super.restartApplication()
        resetUIs()
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
        guard let array = Labiba.hintsArray else {
            return
        }
        var questions = array
        let firstItem = questions[0]
        questions.remove(at: 0)
        questions.shuffle()
        questions.insert(firstItem, at: 0)
        choices = questions[0..<4].map({$0.localForChosnLangCodeMB})
        
        choicesCollectionView.transform = SharedPreference.shared.botLangCode == .ar ? CGAffineTransform(scaleX: -1, y: 1) : .identity
        DispatchQueue.main.async {
            self.choicesCollectionView.reloadData()
        }
        
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

extension QuickChoicesHeaderView:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return choices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderQuickChoiceCell", for: indexPath) as! HeaderQuickChoiceCell
     if indexPath.row == 0 {
            cell.imageContainer.isHidden = false
            cell.iconImage.image = Image(named: "heart")
            cell.tintColor = .white
        }else{
            cell.imageContainer.isHidden = true
        }
        cell.titleLbl.text = choices[indexPath.row]
        cell.titleLbl.font = applyBotFont(size: 15)
        cell.selectItemBtn.tag = indexPath.row
        cell.selectItemBtn.addTarget(self, action: #selector(didSelectItem), for: .touchUpInside)
        DispatchQueue.main.async{
            let transform:CGAffineTransform = SharedPreference.shared.botLangCode == .ar ? CGAffineTransform(scaleX: -1, y: 1) : .identity
            cell.transform = transform
            cell.stackView.applyReversedSemanticAccordingToBotLang()
        }
       
        return cell
    }
    @objc func didSelectItem(_ sender: UIButton){
        self.delegate?.labibaHeaderViewDidSubmitText?(message: choices[sender.tag])
    }
    
  


    
    
    
}


