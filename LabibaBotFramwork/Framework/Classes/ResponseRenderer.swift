//
//  ResponseRenderer.swift
//  ImagineBot
//
//  Created by Suhayb Al-Absi on 10/22/16.
//  Copyright © 2016 Suhayb Al-Absi. All rights reserved.
//

import UIKit

class ResponseRenderer: NSObject
{

    weak var view: EntryViewCell!
    weak var display: EntryDisplay!

    func renderResponse(display: EntryDisplay, onView view: EntryViewCell) -> Void
    {
        self.view = view
        self.display = display
    }
}

class MediaStreamResponseRenderer: ResponseRenderer
{

    override func renderResponse(display: EntryDisplay, onView view: EntryViewCell)
    {

        super.renderResponse(display: display, onView: view)

        if let urlPath = display.dialog.media?.url,
           let url = URL(string: urlPath),
           let type = display.dialog.media?.type
        {

            self.buildStreamDisplay(forType: type, andURL: url)

        }
        else if let url = display.dialog.media?.localUrl, let type = display.dialog.media?.type
        {

            self.buildStreamDisplay(forType: type, andURL: url)
        }
    }

    func buildStreamDisplay(forType type: MediaType, andURL url: URL) -> Void
    {
       // let avatarWidth = Labiba._botAvatar == nil ? 0 : AvatarWidth + 5
        let avatarWidth = Labiba.BotChatBubble.avatar == nil ? 0 : AvatarWidth + 5
        let ty = display.height + 4
        let w = (type == .Audio) ? 200 : view.frame.width - avatarWidth - 10//view.frame.width - BubbleMargin - AvatarWidth - 10 + 20
        let h = (type == .Audio) ? 60 : 0.60 * w//0.75 * w

        let px: CGFloat
        if display.dialog.party == .user
        {
            px = LbLanguage.isArabic ? AvatarWidth + 5 : view.frame.width - w - AvatarWidth - 5
        }
        else
        {
            px = LbLanguage.isArabic ? view.frame.width - w - avatarWidth - 5 :  avatarWidth + 5
        }

        let crect = CGRect(x: px, y: ty, width: w, height: h)

        var mediaView: MediaStreamer

        if type == .Video
        {

            let video: MediaView = display.dequeueReusableComponent(frame: crect)
            mediaView = video

        }
        else
        {

            let audio: AudioView = display.dequeueReusableComponent(frame: crect)
            if !audio.created {                                                      ///////test performance
                audio.party = display.dialog.party
                let dateFormatter = DateFormatter()
                audio.dateLabel.text = dateFormatter.string(from: display.dialog.timestamp)
            }
            mediaView = audio
        }

        mediaView.frame = crect
        mediaView.setMedia(ofURL: url)
        view.addSubview(mediaView)

        display.height = crect.maxY + 2
    }

}

class PhotoReponseRenderer: ResponseRenderer
{

    override func renderResponse(display: EntryDisplay, onView view: EntryViewCell)
    {

        super.renderResponse(display: display, onView: view)

        if let photo = display.parseActionResponseAsPhoto()
        {

            self.buildPhotoDisplay(photo, byUser: false)
        }
    }

    func renderPhoto(forDisplay display: EntryDisplay, onView view: EntryViewCell) -> Void
    {

        super.renderResponse(display: display, onView: view)

        if let image = display.dialog.media?.image
        {

            self.buildPhotoDisplay(image, byUser: true)
        }
    }

    let margin = max(Labiba._Margin.left, Labiba._Margin.right)
    func buildPhotoDisplay(_ photo: UIImage, byUser: Bool) -> Void
    {
        let totalMargin = margin + ipadMargin
       // let avatarWidth = Labiba._botAvatar == nil ? 0 : AvatarWidth + 5
        let avatarWidth = Labiba.BotChatBubble.avatar == nil ? 0 : AvatarWidth + 5
        let ty = display.height + 4
        let w =  view.frame.width - avatarWidth - 10 - 2*totalMargin//view.frame.width - BubbleMargin - AvatarWidth - 10 + 20
        let h =  0.60 * w//0.75 * w
        
        let px: CGFloat
        if display.dialog.party == .user
        {
            px = LbLanguage.isArabic ? avatarWidth + 5 + totalMargin : view.frame.width - w - avatarWidth - 5 - totalMargin
        }
        else
        {
            px = LbLanguage.isArabic ? view.frame.width - w - avatarWidth - 5 - totalMargin :  avatarWidth + 5 + totalMargin
        }
        
        let crect = CGRect(x: px, y: ty, width: w, height: h)

        let photoView: PhotoView = view.dequeueReusableComponent(frame: crect)
        
        if !photoView.created{
            photoView.frame = crect
            photoView.showPhoto(image: photo)
        }
        view.addSubview(photoView)

        display.height = crect.maxY + 4
    }
}


class MapReponseRenderer: ResponseRenderer
{

    func renderMap(display: EntryDisplay, onView view: EntryViewCell)
    {

        super.renderResponse(display: display, onView: view)

        if let map = display.dialog.map
        {
            self.buildMapDisplay(map)
        }
    }
    
    let margin = max(Labiba._Margin.left, Labiba._Margin.right)

    func buildMapDisplay(_ map: DialogMap) -> Void
    {
        let totalMargin = margin + ipadMargin
        let ty = display.height + 4
        //let w = view.frame.width - BubbleMargin - AvatarWidth - 10 + 20
        let w = view.frame.width - 20 - 2*totalMargin
        let h = 0.6 * w

        let px: CGFloat
        if self.display.dialog.party == .user
        {
            px = LbLanguage.isArabic ?  10 + totalMargin : view.frame.width - w  - 10 - totalMargin
            //px = 10 + ipadFactor*(totalMargin - 10)//Language.isArabic ? 5 + AvatarWidth + 5 : view.frame.width - w - 5 - AvatarWidth - 5
        }
        else
        {
            px = LbLanguage.isArabic ? view.frame.width - w  - 10 - totalMargin :  10 + totalMargin
           // px = 10 + ipadFactor*(totalMargin - 10)//Language.isArabic ? view.frame.width - w - 5 - AvatarWidth - 5 : 5 + AvatarWidth + 5
        }

        let crect = CGRect(x: px, y: ty, width: w, height: h)

        let mapView: MapView = view.dequeueReusableComponent(frame: crect)
        if !mapView.created {
            mapView.frame = crect
            mapView.showMap(map)
        }

        view.addSubview(mapView)

        display.height = crect.maxY + 4
    }
}

class AttachmentReponseRenderer: ResponseRenderer
{

    func renderAttachment(display: EntryDisplay, onView view: EntryViewCell)
    {

        super.renderResponse(display: display, onView: view)

        if let attachment = display.dialog.attachment
        {
            self.buildAttachmentDisplay(attachment)
        }
    }
    
    let margin = max(Labiba._Margin.left, Labiba._Margin.right)

    func buildAttachmentDisplay(_ attachment: AttachmentCard) -> Void
    {
        let totalMargin = margin + ipadMargin
        let ty = display.height + 10
        //let w = view.frame.width - BubbleMargin - AvatarWidth - 10 + 20
        let w = (view.frame.width - 2*totalMargin)*0.8
        let h:CGFloat = 70.0

        let px: CGFloat
        if self.display.dialog.party == .user
        {
            px = LbLanguage.isArabic ?  10 + totalMargin : view.frame.width - w  - 10 - totalMargin
            //px = 10 + ipadFactor*(totalMargin - 10)//Language.isArabic ? 5 + AvatarWidth + 5 : view.frame.width - w - 5 - AvatarWidth - 5
        }
        else
        {
            px = LbLanguage.isArabic ? view.frame.width - w  - 10 - totalMargin :  10 + totalMargin
           // px = 10 + ipadFactor*(totalMargin - 10)//Language.isArabic ? view.frame.width - w - 5 - AvatarWidth - 5 : 5 + AvatarWidth + 5
        }

        let crect = CGRect(x: px, y: ty, width: w, height: h)

        let attachmentView: AttachmentView = view.dequeueReusableComponent(frame: crect)
        if !attachmentView.created {
            attachmentView.frame = crect
            attachmentView.startAnimation()
            attachmentView.created = true
            //attachmentView.showMap(map)
            
        }
        attachmentView.update(with: display.dialog.attachment?.link ?? "")
        view.addSubview(attachmentView)

        display.height = crect.maxY + 4
    }
}


class CardsReponseRenderer: ResponseRenderer
{

    override func renderResponse(display: EntryDisplay, onView view: EntryViewCell)
    {

        super.renderResponse(display: display, onView: view)

        if let photo = display.parseActionResponseAsPhoto()
        {

            self.buildPhotoDisplay(photo, byUser: false)
        }
    }

    func renderCollection(forDisplay display: EntryDisplay, onView view: EntryViewCell) -> Void
    {

        super.renderResponse(display: display, onView: view)

        if let image = display.dialog.media?.image
        {

            self.buildPhotoDisplay(image, byUser: true)
        }
    }

    func buildPhotoDisplay(_ photo: UIImage, byUser: Bool) -> Void
    {

        let ty = display.height + 4
        let w = view.frame.width - BubbleMargin - AvatarWidth - 10 + 20
        let h = w * 0.75

        let px: CGFloat
        if byUser
        {
            px = LbLanguage.isArabic ? 5 + AvatarWidth + 5 : view.frame.width - w - 5 - AvatarWidth - 5
        }
        else
        {
            px = LbLanguage.isArabic ? view.frame.width - w - 5 - AvatarWidth - 5 : 5 + AvatarWidth + 5
        }

        let crect = CGRect(x: px, y: ty, width: w, height: h)

        let photoView: PhotoView = view.dequeueReusableComponent(frame: crect)
        if !photoView.created {
            photoView.frame = crect
            photoView.showPhoto(image: photo)
        }
        view.addSubview(photoView)

        display.height = crect.maxY + 4
    }
}
