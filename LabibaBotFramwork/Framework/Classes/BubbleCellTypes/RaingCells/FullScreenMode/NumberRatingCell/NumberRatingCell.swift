//
//  NumberRatingCell.swift
//  LabibaBotFramwork
//
//  Created by Osama Hasan on 06/04/2025.
//  Copyright © 2025 Abdul Rahman. All rights reserved.
//

import UIKit

class NumberRatingCell: RatingCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var questionLabel: UILabel!
    
    var onSelected: ((Int) -> Void)?
    var selectedIndex = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setupUI()
        getQuestion()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setupUI(){
        questionLabel.textColor = LabibaThemes.ratingColor
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let currentBundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NumberItemCell", bundle: currentBundle)
        collectionView.register(nib, forCellWithReuseIdentifier: "NumberItemCell")
    }
    
    func getQuestion(){
        DataSource.shared.getActiveQuestion { [weak self] result in
            switch result{
            case .success(let data):
                DispatchQueue.main.async{
                   if data.header.isSuccess {
                        self?.questionLabel.text = data.data.question
                    }else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            self?.onSelected?(-1)
                        })
                    }
                }
            case .failure(let error):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self?.onSelected?(-1)
                })
                print(error)
            }
        }
    }
    
}


extension NumberRatingCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberItemCell", for: indexPath) as! NumberItemCell
        cell.numberLabel.text = "\(indexPath.row + 1)"
        cell.contanierView.backgroundColor = selectedIndex >= indexPath.row ?  LabibaThemes.ratingColor : .black.withAlphaComponent(0.2)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        onSelected?(indexPath.row)
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (UIScreen.main.bounds.width - 340) / 10
    }
}
