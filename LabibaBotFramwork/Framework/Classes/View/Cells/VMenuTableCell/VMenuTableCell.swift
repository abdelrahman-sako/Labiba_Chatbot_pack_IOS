//
//  VMenuTableCell.swift
//  LabibaBotFramwork
//
//  Created by Osama Hasan on 10/05/2023.
//  Copyright © 2023 Abdul Rahman. All rights reserved.
//

import UIKit

class VMenuTableCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView!
   
    weak var delegate:VMenuTableCellDelegate?

    var aDisplayedDialogs:EntryDisplay?
    var isFirstReloading:Bool = true
    var SelectedDialogIndex:Int?
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableView.registerCell(type: VMenuCell.self,bundle: Constants.mainBundle)
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
    }
    
    func setupUI(){
        tableView.estimatedRowHeight = Labiba.vMenuTableTheme.estimatedRowHeight
        tableView.rowHeight = Labiba.vMenuTableTheme.rowHeight
        tableView.separatorStyle = Labiba.vMenuTableTheme.separatorStyle
        tableView.backgroundColor = Labiba.vMenuTableTheme.backgroundColor
        tableView.showsVerticalScrollIndicator = Labiba.vMenuTableTheme.showVerticalIndicator
        tableView.showsHorizontalScrollIndicator = Labiba.vMenuTableTheme.showHorizontalIndicator
        tableView.contentInset = Labiba.vMenuTableTheme.edgeInsets
    }
    
    func setDate(selectedDialogIndex:Int,model:EntryDisplay){
        self.SelectedDialogIndex = selectedDialogIndex
        self.aDisplayedDialogs = model
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        guard let dialog = aDisplayedDialogs?.dialog else {
            return
        }
        self.delegate?.finishedDisplayForDialog(dialog: dialog)
        isFirstReloading = false
    }
    
    @objc func actionTap(_ sender: UIButton){
        //isAnItemSelected = true
     
        if self.aDisplayedDialogs?.dialog.cards?.items[sender.tag].buttons.count ?? 0 > 0{
            let SelectedCellDialogCardButton = self.aDisplayedDialogs?.dialog.cards?.items[sender.tag].buttons[0]
            self.delegate?.collectionView(dialogIndex: SelectedDialogIndex! ,selectedCardIndex: sender.tag,selectedCellDialogCardButton: SelectedCellDialogCardButton, didTappedInTableview: self)
        }
    }
    
}

extension VMenuTableCell : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categoryItems = self.aDisplayedDialogs?.dialog.cards?.items
        {
            return categoryItems.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueCell(withType: VMenuCell.self, for: indexPath){
            if let model = aDisplayedDialogs?.dialog.cards?.items[indexPath.item] {
                 cell.actionButton.tag = indexPath.row
                 
                 cell.actionButton.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
                cell.setData(model: model)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isFirstReloading {
            cell.alpha = 0
            cell.transform = CGAffineTransform(translationX: -15, y: 0)
            UIView.animate(withDuration: 0.25, delay: 0.4 + Double(indexPath.row)*0.04, options: [], animations: {
                cell.alpha = 1
                cell.transform = .identity
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if self.aDisplayedDialogs?.dialog.cards?.items[(indexPath.item )].buttons.count ?? 0 > 0{
            let SelectedCellDialogCardButton = self.aDisplayedDialogs?.dialog.cards?.items[(indexPath.item )].buttons[0]
            self.delegate?.collectionView(dialogIndex: SelectedDialogIndex! ,selectedCardIndex: indexPath.item,selectedCellDialogCardButton: SelectedCellDialogCardButton, didTappedInTableview: self)
        }
    }
    
    
}

protocol VMenuTableCellDelegate:AnyObject {
    func collectionView(dialogIndex: Int,selectedCardIndex: Int,selectedCellDialogCardButton:DialogCardButton?, didTappedInTableview TableCell:VMenuTableCell)
    func finishedDisplayForDialog(dialog: ConversationDialog)
    //other delegate methods that you can define to perform action in viewcontroller
}
