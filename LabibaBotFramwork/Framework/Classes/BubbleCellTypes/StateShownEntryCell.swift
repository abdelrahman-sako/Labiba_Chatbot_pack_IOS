//
//  StateShownEntryCell.swift
//  ImagineBot
//
//  Created by Suhayb Al-Absi on 10/21/16.
//  Copyright © 2016 Suhayb Al-Absi. All rights reserved.
//

import UIKit


class StateShownEntryCell: StateEntryCell
{
    let dateFormatter = DateFormatter()

    override func displayEntry(_ entryDisplay: EntryDisplay) -> Void
    {

        super.displayEntry(entryDisplay)

        let dialog = entryDisplay.dialog

        renderBotText()

        if entryDisplay.actionResponse != nil, let media = dialog.media
        {

            renderMediaActionResponse(media)

        }
        else if let photo = dialog.media?.image
        {

            renderAsPhoto(photo)

        }
        else if let media = dialog.media
        {

            renderMediaActionResponse(media)

        }
        else if let map = dialog.map
        {

            renderAsMap(map)

        }else if let attachment = dialog.attachment {
           renderAsAttachment(attachment)
        }
        else
        {

            self.currentDisplay.height = self.botBubbleMaxY
        }

        DispatchQueue.main.async
        {
            self.renderAvatar(animated: false)
        }
    }

    func renderAsPhoto(_ photo: UIImage) -> Void
    {

        DispatchQueue.main.async
        {

            let renderer = PhotoReponseRenderer()

            self.currentDisplay.height = 2
            renderer.renderPhoto(forDisplay: self.currentDisplay, onView: self)
            self.delegate?.finishedDisplayForDialog(dialog: self.currentDialog)
        }
    }

    func renderAsMap(_ map: DialogMap) -> Void
    {

        DispatchQueue.main.async
        {

            self.currentDisplay.height = self.botBubbleMaxY + 2

            let renderer = MapReponseRenderer()
            renderer.renderMap(display: self.currentDisplay, onView: self)

            self.delegate?.finishedDisplayForDialog(dialog: self.currentDialog)
        }
    }
    
    func renderAsAttachment(_ item: AttachmentCard) -> Void
       {

           DispatchQueue.main.async
           {

               self.currentDisplay.height = self.botBubbleMaxY + 2

               let renderer = AttachmentReponseRenderer()
                renderer.renderAttachment(display: self.currentDisplay, onView: self)
               self.delegate?.finishedDisplayForDialog(dialog: self.currentDialog)
           }
       }

    var botBubbleMaxY: CGFloat = 0

    func renderBotText() -> Void
    {

        if self.currentDialog.hasMessage
        {
            if currentDialog.party == .bot {
                currentDialog?.isFromAgent = Labiba.isHumanAgentStarted
            }
            self.bubble.posY = 5.0
            self.addSubview(self.bubble)

           // self.bubble.timeLabel.text = dateFormatter.string(from: self.currentDialog.timestamp)
            //

            self.bubble.currentDialog = self.currentDialog
            //
            self.bubble.doSetMessage = self.currentDialog.message!

            //set the bubble to the maimum y (thunder all conversation)
            self.botBubbleMaxY = self.bubble.frame.maxY

        }
        else
        {
            self.avatar.isHidden = true
            self.botBubbleMaxY = 0
        }
    }

    let reloadButton = UIButton(type: UIButton.ButtonType.system)

    func renderResendButton() -> Void
    {

        //reloadButton.setImage(#imageLiteral(resourceName: "ic_replay"), for: .normal)

        //if self.currentDisplay
    }

    func renderMediaActionResponse(_ media: DialogMedia) -> Void
    {

        self.currentDisplay.height = self.botBubbleMaxY

        let renderer: ResponseRenderer?

        switch media.type
        {
        case .Photo:
            renderer = PhotoReponseRenderer()
        default:
            renderer = MediaStreamResponseRenderer()
        }

        renderer?.renderResponse(display: self.currentDisplay, onView: self)
        self.delegate?.finishedDisplayForDialog(dialog: self.currentDialog)
    }
}


