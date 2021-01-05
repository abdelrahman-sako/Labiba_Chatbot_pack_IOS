//
//  BubbbleGestureHandler.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 8/21/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import Foundation
import UIKit
class BubbbleGestureHandler {
    
    var recycleBinView : DeleteView {
        if let topView = getTheMostTopView()  {
            for subview in topView.subviews{
                if subview is DeleteView{
                    return subview as! DeleteView
                }
            }
        }
        return DeleteView(frame: CGRect(x: SettingVariabels.screenBounds.width/2 ,
                                        y: SettingVariabels.screenBounds.height + 10, width: 50, height: 50))
    }
    
    weak var bubbleView:UIView?
    var delegate:BubbleDeletionDelegate?
    func bubbleDidMove(_ gesture:UIPanGestureRecognizer){
        
        guard let topView = getTheMostTopViewController().view ,let bubble = bubbleView else {
            return
        }
        let location = gesture.location(in: topView)
        
        switch gesture.state {
        case .began:
            SettingVariabels.reset()
                self.recycleBinApearenceAnimation()
            SettingVariabels.velocityArray = []
            topView.addSubview(recycleBinView)
//            recycleBinView.isHidden = true
        case .changed:
            recycleBinView.center.x = (SettingVariabels.screenBounds.width/2) + ((location.x - SettingVariabels.screenBounds.width/2)/10)
            if location.y >= SettingVariabels.screenBounds.height/2{
                recycleBinView.center.y = SettingVariabels.screenBounds.height - 80 + (location.y - SettingVariabels.screenBounds.height/2)/10
            }else{
                UIView.animate(withDuration: 0.2) {
                    self.recycleBinView.center.y  =  SettingVariabels.screenBounds.height  - 80
                }
            }
            if distance(location, recycleBinView.center) <= 110 {
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1,
                                                               delay: 0,
                                                               options: [],
                                                               animations: {
                                                                let widthRatio = self.recycleBinView.bounds.width/bubble.bounds.width
                                                                let HeightRatio = widthRatio
//                                                                self.bubbleView?.transform  = CGAffineTransform(scaleX: widthRatio,
//                                                                                                            y: HeightRatio)
                                                                self.bubbleView?.center  = CGPoint(x: self.recycleBinView.center.x + SettingVariabels.xBounceConstant,
                                                                                               y: self.recycleBinView.center.y + SettingVariabels.yBounceConstant)
                }) { (position) in
                    SettingVariabels.xBounceConstant = 0
                    SettingVariabels.yBounceConstant = 0
                }
                if !SettingVariabels.isSwallowed{
                    recycleBinView.swallowCircleAnimation()
                    topView.bringSubviewToFront(recycleBinView) //recycleBinView.layer.zPosition = 1
                    SettingVariabels.isItemDeleted = true
                    SettingVariabels.isSwallowed = true
                }
            }else{
                SettingVariabels.xBounceConstant =  ( SettingVariabels.screenBounds.width/2 - location.x)/40
                SettingVariabels.yBounceConstant = 10
                if SettingVariabels.isSwallowed{
                    self.recycleBinView.releaseCircleAnimation()
                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1,
                                                                   delay: 0,
                                                                   options: [],
                                                                   animations: {
                                                                    self.bubbleView?.center = location
                                                                    //self.bubbleView?.transform  = CGAffineTransform.identity
                    }) { (position) in
                        SettingVariabels.isSwallowed = false
                        SettingVariabels.isItemDeleted = false
                    }
                }else{
                    self.recycleBinView.releaseCircleAnimation()
                    self.bubbleView?.center = location
                }
            }
            
            
            SettingVariabels.yVelocity = location.y - SettingVariabels.yOldLocation
            SettingVariabels.yOldLocation = location.y
            if SettingVariabels.velocityArray.count > 4{
                SettingVariabels.velocityArray.insert(SettingVariabels.yVelocity, at: 0)
                SettingVariabels.velocityArray.removeLast()
            }else{
                SettingVariabels.velocityArray.append(SettingVariabels.yVelocity)
            }
            
        case .ended :
            var velocity :Int{
                var summation = 0
                
                var zeroItemsCount = 0
                if SettingVariabels.velocityArray.count > 9{
                    for index in SettingVariabels.velocityArray.indices{
                        let velocityItem = Int(SettingVariabels.velocityArray[index])
                        if velocityItem == 0{
                            zeroItemsCount += 1
                        }
                        summation += velocityItem
                    }
                    if zeroItemsCount > 6{
                        return 0
                    }
                    return summation/SettingVariabels.velocityArray.count
                }else{
                    return 0
                }
            }
            print("velocity" , velocity)
            SettingVariabels.animationDuration = 0.1
            if !SettingVariabels.isItemDeleted && velocity < 15 || SettingVariabels.yOldLocation < SettingVariabels.screenBounds.width/2  {
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3,
                                                               delay: 0,
                                                               options: [],
                                                               animations: {
                                                               
                                                                self.delegate?.reopenBubble()
                                                                   /// here excute reOpen chatBot
                                                                
                } , completion: nil)
            }
            if velocity >= 15{
                SettingVariabels.animationDuration =  0.35 - Double(velocity)/250
            }
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: SettingVariabels.animationDuration ,
                                                           delay: 0,
                                                           options: [],
                                                           animations: {
                                                            let hidePoint = CGPoint(x: SettingVariabels.screenBounds.width/2 , y: SettingVariabels.screenBounds.height + 40 )
                                                            self.recycleBinView.center  = hidePoint
                                                            if SettingVariabels.isItemDeleted || velocity >= 15 {
                                                                self.bubbleView?.center = hidePoint
//                                                                self.bubbleView?.transform  = CGAffineTransform(scaleX: self.recycleBinView.bounds.width/bubble.bounds.width,
//                                                                                                            y: self.recycleBinView.bounds.height/bubble.bounds.height)
                                                            }
                                                            
            }) { (postion) in
                self.recycleBinView.isHidden = true
                self.recycleBinView.removeFromSuperview()
                if SettingVariabels.isItemDeleted || velocity >= 15{
                self.delegate?.deleteBubble()
                /////////////////////////// excute delete bubble and terminate chatBot
                }
            }
        default:
            break
        }
    }
    
    
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    
    func recycleBinApearenceAnimation()  {
        self.recycleBinView.isHidden = false
        recycleBinView.center  = CGPoint(x: SettingVariabels.screenBounds.width/2 ,
                                         y: SettingVariabels.screenBounds.height)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1 ,
                                                       delay: 0,
                                                       options: [],
                                                       animations: {
                                                        self.recycleBinView.center  = CGPoint(x: SettingVariabels.screenBounds.width/2 ,
                                                                                              y: SettingVariabels.screenBounds.height  - 80)
        })
    }
    
}


protocol BubbleDeletionDelegate{
    func deleteBubble()
    func reopenBubble()
    
}
