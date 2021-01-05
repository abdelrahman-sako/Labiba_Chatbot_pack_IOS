//
//  UsageGuideCell.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 9/8/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import UIKit

class UsageGuideCell: StateEntryCell {
    let renderer = HintsView()
    override func displayEntry(_ entryDisplay: EntryDisplay) -> Void
    {
        
        super.displayEntry(entryDisplay)
        let dialog = entryDisplay.dialog
        if let guide = dialog.guide{
            renderAsHintsView(guide: guide)
        }
        
    }
    
    func renderAsHintsView(guide:DialogGuide){
        DispatchQueue.main.async{
        //    self.currentDisplay.height = 300
            self.renderer.delegate = self.delegate
            self.renderer.renderHintsView(display: self.currentDisplay, onView: self)
            self.delegate?.finishedDisplayForDialog(dialog: self.currentDialog)
        }
    }
    
    
}
