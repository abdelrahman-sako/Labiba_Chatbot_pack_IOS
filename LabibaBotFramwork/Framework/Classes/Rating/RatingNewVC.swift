//
//  RatingNewVC.swift
//  LabibaBotFramwork
//
//  Created by Ahamd Sbeih on 20/04/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//

import UIKit

class RatingNewVC:UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var RatingsTableView: ContentSizedTableView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    
    var selectedScore:Int?
    var vcDismissed:((_ status:String)-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        setupUI()
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        Labiba.showBackOnNPS = false
        Labiba.isNpsPresentingNow = false
        dismiss(animated: true)
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        guard let selectedScore else {
            showErrorMessage("Please Select a Score")
            return
        }
            DataSource.shared.closeConversation { result in}
        DataSource.shared.submitNPSScore(String(selectedScore)) { result in
            switch result{
            case .success(let result):
                DispatchQueue.main.async{
                    self.dismiss(animated: true,completion: {
                        self.vcDismissed?(result ?? "error")
                    })
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async{
                    self.dismiss(animated: true,completion: {
                        self.vcDismissed?(error.localizedDescription)
                    })
                }
            }
            
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true,completion: {
            self.vcDismissed?("rate later")
        })
    }
    
    
    func tableViewSetup()  {
        RatingsTableView.delegate = self
        RatingsTableView.dataSource = self
        RatingsTableView.reloadData()
        
        let nib6 = UINib(nibName: "NumberRatingCell", bundle: self.nibBundle)
        RatingsTableView.register(nib6, forCellReuseIdentifier: "NumberRatingCell")
        RatingsTableView.reloadData()
    }
    
    func setupUI(){
        submitButton.backgroundColor = LabibaThemes.npsRatingColor
        buttons.forEach({$0.layer.cornerRadius = 25})
        
        welcomeLabel.text = "Share Your Rating!".localForChosnLangCodeBB
        buttons[0].setTitle("Submit".localForChosnLangCodeBB, for: .normal)
        buttons[1].setTitle("Later".localForChosnLangCodeBB, for: .normal)
        
        RatingsTableView.semanticContentAttribute = .forceLeftToRight
        
        backButton.isHidden = !Labiba.showBackOnNPS
        backButton.setTitle("Back".localForChosnLangCodeBB, for: .normal)
        backButton.titleLabel?.textColor = .black
    }
    
    func submitRate(){
        
    }
    
}

extension RatingNewVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NumberRatingCell", for: indexPath) as! NumberRatingCell
        cell.onSelected = { index in
            if index == -1 {
                DispatchQueue.main.async{
                    self.dismiss(animated: true,completion: {
                        self.vcDismissed?("Question not loaded")
                    })
                }

            }
            self.selectedScore = index + 1
        }
        cell.selectionStyle = .none
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
//    }
}
