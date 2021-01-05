//
//  StateEntryCell.swift
//  ImagineBot
//
//  Created by AhmeDroid on 1/12/17.
//  Copyright © 2017 Imagine Technologies. All rights reserved.
//

import UIKit

protocol EntryTableViewCellDelegate: class
{

    func choiceWasSelectedFor(display: EntryDisplay, choice: DialogChoice)
    func hintWasSelectedFor(hint: String)
    func cardButton(_ button: DialogCardButton, ofCard card: DialogCard, wasSelectedForDialog dialog: ConversationDialog)

    func actionFailedFor(dialog: ConversationDialog)
    func finishedDisplayForDialog(dialog: ConversationDialog)
}

class StateEntryCell: EntryViewCell
{

    weak var delegate: EntryTableViewCellDelegate?
    weak var currentDialog: ConversationDialog!

    override var conversationParty: ConversationParty
    {

        return self.currentDialog.party
    }

    override func displayEntry(_ entryDisplay: EntryDisplay)
    {
        self.currentDialog = entryDisplay.dialog
        super.displayEntry(entryDisplay)
    }

    private lazy var userBubble: BubbleView = {
        return UserBubble.createBubble(withWidth: self.frame.size.width)
    }()

    private lazy var botBubble: BubbleView = {
        return BotBubble.createBubble(withWidth: self.frame.size.width)
    }()

    var bubble: BubbleView
    {

        return self.conversationParty == .bot ? self.botBubble : self.userBubble
    }
}
