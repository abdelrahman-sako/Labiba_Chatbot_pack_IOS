//
//  Gradient.swift
//  GradientAnimation
//
//  Created by Abdulrahman on 8/7/19.
//  Copyright © 2019 Imagine Technologies. All rights reserved.
//

import Foundation
import UIKit
func drawItineraryGradientOverlay(_ view:UIView ,colors:[[CGColor]]) -> Void {
    
    let alpha:CGFloat = 1.0
    
    
    
    // good
    // test 2
    let gradient: CAGradientLayer = CAGradientLayer()
    gradient.frame = view.bounds
    gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
    gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
    if colors.count > 2 {
          gradient.colors = colors[1]
    }else{
        return
    }
    //gradient.colors = colors1
    var animations:[CABasicAnimation] = []
    var startingTime:Double = -1
    for (index ,colorArr) in colors.enumerated(){
        var nextIndex = index + 1
        if index == (colors.count - 1){
            nextIndex = 0
        }
        startingTime += 1
        animations.append(createTwoEndsAnimation(initColors: colorArr, finalColors: colors[nextIndex], beginAt: startingTime, duration: 2.0))
        startingTime += 2
        animations.append(createTwoEndsAnimation(initColors: colors[nextIndex], finalColors: colors[nextIndex], beginAt: startingTime , duration: 1.0))
    }
    
    let gradientView = UIView(frame: view.frame)
    gradientView.layer.insertSublayer(gradient, at: 0)
    view.insertSubview(gradientView, at: 0)
    
//    let animation0  = createTwoEndsAnimation(initColors: colors0, finalColors: colors1, beginAt: 0, duration: 2.0)
//    let animation0_ = createTwoEndsAnimation(initColors: colors1, finalColors: colors1, beginAt: 2, duration: 1.0)
//
//    let animation1  = createTwoEndsAnimation(initColors: colors1, finalColors: colors2, beginAt: 3, duration: 2.0)
//    let animation1_ = createTwoEndsAnimation(initColors: colors2, finalColors: colors2, beginAt: 5, duration: 1.0)
//
//    let animation2  = createTwoEndsAnimation(initColors: colors2, finalColors: colors3, beginAt: 6, duration: 2.0)
//    let animation2_ = createTwoEndsAnimation(initColors: colors3, finalColors: colors3, beginAt: 8, duration: 1.0)
//
//    let animation3  = createTwoEndsAnimation(initColors: colors3, finalColors: colors4, beginAt: 9, duration: 2.0)
//    let animation3_ = createTwoEndsAnimation(initColors: colors4, finalColors: colors4, beginAt: 11, duration: 1.0)
//
//    let animation4  = createTwoEndsAnimation(initColors: colors4, finalColors: colors5, beginAt: 12, duration: 2.0)
//    let animation4_ = createTwoEndsAnimation(initColors: colors5, finalColors: colors5, beginAt: 14, duration: 1.0)
//
//    let animation5  = createTwoEndsAnimation(initColors: colors5, finalColors: colors0, beginAt: 15, duration: 2.0)
//    let animation5_ = createTwoEndsAnimation(initColors: colors0, finalColors: colors0, beginAt: 17, duration: 1.0)
//
    
    let animationGroup = CAAnimationGroup()
    animationGroup.isRemovedOnCompletion = false
    animationGroup.fillMode = CAMediaTimingFillMode.forwards
    animationGroup.repeatCount = Float.infinity
    animationGroup.duration = 21
//    animationGroup.animations = [animation0, animation0_,
//                                 animation1, animation1_,
//                                 animation2, animation2_,
//                                 animation3, animation3_,
//                                 animation4, animation4_,
//                                 animation5, animation5_]
    animationGroup.animations = animations
    
    gradient.add(animationGroup, forKey: nil)
}

@discardableResult func drawGradientOverlay(_ view:UIView) -> UIView? {
    
    let alpha:CGFloat = 1.0
    
    //rgba(211, 173, 103, 1), rgba(245, 126, 97, 1)
    let colors0 = [
        UIColor(red: 211 / 255.0, green:  173 / 255.0, blue:  103 / 255.0, alpha: alpha).cgColor,
        UIColor(red: 245 / 255.0, green:  126 / 255.0, blue:   97 / 255.0, alpha: alpha).cgColor,
        UIColor(red: 211 / 255.0, green:  173 / 255.0, blue:  103 / 255.0, alpha: alpha).cgColor
    ]
    
    //R: 193 G: 7 B: 94 - R: 240 G: 140 B: 0
    let colors1 = [
        UIColor(red: 240 / 255.0, green:  140 / 255.0, blue:  0 / 255.0, alpha: alpha).cgColor,
        UIColor(red: 193 / 255.0, green:    7 / 255.0, blue: 94 / 255.0, alpha: alpha).cgColor,
        UIColor(red: 240 / 255.0, green:  140 / 255.0, blue:  0 / 255.0, alpha: alpha).cgColor
    ]
    
    //rgba(136, 79, 27, 1), rgba(170, 25, 18, 1)
    let colors2 = [
        UIColor(red: 136 / 255.0, green: 79 / 255.0, blue: 27 / 255.0, alpha: alpha).cgColor,
        UIColor(red: 170 / 255.0, green: 25 / 255.0, blue: 18 / 255.0, alpha: alpha).cgColor,
        UIColor(red: 136 / 255.0, green: 79 / 255.0, blue: 27 / 255.0, alpha: alpha).cgColor
    ]
    //rgba(157, 208, 229, 1), rgba(153, 164, 195, 1)
    let colors3 = [
        UIColor(red: 157 / 255.0, green: 208 / 255.0, blue: 229 / 255.0, alpha: alpha).cgColor,
        UIColor(red: 153 / 255.0, green: 164 / 255.0, blue: 195 / 255.0, alpha: alpha).cgColor,
        UIColor(red: 157 / 255.0, green: 208 / 255.0, blue: 229 / 255.0, alpha: alpha).cgColor,
    ]
    //rgba(72, 139, 170, 1), rgba(68, 203, 186, 1)
    let colors4 = [
        UIColor(red: 72 / 255.0, green: 139 / 255.0, blue: 170 / 255.0, alpha: alpha).cgColor,
        UIColor(red: 68 / 255.0, green: 203 / 255.0, blue: 186 / 255.0, alpha: alpha).cgColor,
        UIColor(red: 72 / 255.0, green: 139 / 255.0, blue: 170 / 255.0, alpha: alpha).cgColor
    ]
    //rgba(33, 180, 178, 1), rgba(19, 214, 124, 1)
    let colors5 = [
        UIColor(red: 33 / 255.0, green: 180 / 255.0, blue: 178 / 255.0, alpha: alpha).cgColor,
        UIColor(red: 19 / 255.0, green: 214 / 255.0, blue: 124 / 255.0, alpha: alpha).cgColor,
        UIColor(red: 33 / 255.0, green: 180 / 255.0, blue: 178 / 255.0, alpha: alpha).cgColor
    ]
    //rgba(58, 50, 31, 1), rgba(93, 52, 40, 1)
    let colors6 = [
        UIColor(red: 58 / 255.0, green: 50 / 255.0, blue: 31 / 255.0, alpha: alpha).cgColor,
        UIColor(red: 93 / 255.0, green: 52 / 255.0, blue: 40 / 255.0, alpha: alpha).cgColor,
        UIColor(red: 58 / 255.0, green: 50 / 255.0, blue: 31 / 255.0, alpha: alpha).cgColor
    ]
    
    let gradient: CAGradientLayer = CAGradientLayer()
    gradient.frame = view.bounds
    gradient.startPoint = CGPoint(x: 1.0, y: 0)
    gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
    gradient.colors = colors1
    
    let gradientView = UIView(frame: view.frame)
    gradientView.layer.insertSublayer(gradient, at: 0)
    view.insertSubview(gradientView, at: 0)
    
    let animation0  = createTwoEndsAnimation(initColors: colors0, finalColors: colors1, beginAt: 0, duration: 2.0)
    let animation0_ = createTwoEndsAnimation(initColors: colors1, finalColors: colors1, beginAt: 2, duration: 1.0)
    
    let animation1  = createTwoEndsAnimation(initColors: colors1, finalColors: colors2, beginAt: 3, duration: 2.0)
    let animation1_ = createTwoEndsAnimation(initColors: colors2, finalColors: colors2, beginAt: 5, duration: 1.0)
    
    let animation2  = createTwoEndsAnimation(initColors: colors2, finalColors: colors3, beginAt: 6, duration: 2.0)
    let animation2_ = createTwoEndsAnimation(initColors: colors3, finalColors: colors3, beginAt: 8, duration: 1.0)
    
    let animation3  = createTwoEndsAnimation(initColors: colors3, finalColors: colors4, beginAt: 9, duration: 2.0)
    let animation3_ = createTwoEndsAnimation(initColors: colors4, finalColors: colors4, beginAt: 11, duration: 1.0)
    
    let animation4  = createTwoEndsAnimation(initColors: colors4, finalColors: colors5, beginAt: 12, duration: 2.0)
    let animation4_ = createTwoEndsAnimation(initColors: colors5, finalColors: colors5, beginAt: 14, duration: 1.0)
    
    let animation5  = createTwoEndsAnimation(initColors: colors5, finalColors: colors6, beginAt: 15, duration: 2.0)
    let animation5_ = createTwoEndsAnimation(initColors: colors6, finalColors: colors6, beginAt: 17, duration: 1.0)
    
    let animation6  = createTwoEndsAnimation(initColors: colors6, finalColors: colors0, beginAt: 18, duration: 2.0)
    let animation6_ = createTwoEndsAnimation(initColors: colors0, finalColors: colors0, beginAt: 20, duration: 1.0)
    
    let animationGroup = CAAnimationGroup()
    animationGroup.isRemovedOnCompletion = false
    animationGroup.fillMode = CAMediaTimingFillMode.forwards
    animationGroup.repeatCount = Float.infinity
    animationGroup.duration = 21
    animationGroup.animations = [animation0, animation0_,
                                 animation1, animation1_,
                                 animation2, animation2_,
                                 animation3, animation3_,
                                 animation4, animation4_,
                                 animation5, animation5_,
                                 animation6, animation6_]
    
    gradient.add(animationGroup, forKey: nil)
    
    return gradientView
}

func createTwoEndsAnimation(initColors:[CGColor], finalColors:[CGColor], beginAt:CFTimeInterval, duration:CFTimeInterval) -> CABasicAnimation {
    
    // Animate Corner Radius
    let animation = CABasicAnimation(keyPath: "colors")
    animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    animation.fromValue = initColors
    animation.toValue = finalColors
    animation.duration = duration
    animation.fillMode = CAMediaTimingFillMode.forwards
    animation.beginTime = beginAt
    
    return animation
}

