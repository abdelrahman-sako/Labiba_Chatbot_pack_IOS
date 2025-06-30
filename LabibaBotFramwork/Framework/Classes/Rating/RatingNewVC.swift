//
//  RatingNewVC.swift
//  LabibaBotFramwork
//
//  Created by Mohammad Khalil on 10/04/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//

import UIKit

class RatingNewVC:UIViewController {
    @IBOutlet weak var RatingsTableView: ContentSizedTableView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    
    var selectedScore = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        setupUI()
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
        submitButton.backgroundColor = LabibaThemes.ratingColor
        buttons.forEach({$0.layer.cornerRadius = 25})
    }
    func submitRate(){

    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        DataSource.shared.submitNPSScore(String(selectedScore)) { result in
            
        }
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension RatingNewVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NumberRatingCell", for: indexPath) as! NumberRatingCell
        cell.onSelected = { index in
            self.selectedScore = index
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
