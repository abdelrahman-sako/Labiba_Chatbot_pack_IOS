//
//  AlertUtils.swift
//  Visit Jordan Bot
//
//  Created by AhmeDroid on 10/13/16.
//  Copyright © 2016 Imagine Technologies. All rights reserved.
//

import UIKit


func showErrorMessage(title:String = "app-title".localForChosnLangCodeBB , _ message: String ,okHandelr:(()->Void)? = nil , cancelHandler:(()->Void)? = nil) -> Void
{
    
    guard !message.isEmpty else {
        print("empty popup canceld")
        return
    }
    DispatchQueue.main.async
        {
            
            let alert = UIAlertController(title: "",
                                          message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localForChosnLangCodeBB, style: .default, handler: { _ in
                okHandelr?()
            })
            alert.addAction(okAction)
            if cancelHandler != nil {
                let cancelAction = UIAlertAction(title: "Cancel".localForChosnLangCodeBB, style: .default, handler: { _ in
                    cancelHandler?()
                })
                alert.addAction(cancelAction)
            }
            getTheMostTopViewController().present(alert, animated: true, completion: {})
    }
}

func getTheMostTopViewController() -> UIViewController!
{

    if let rootVC = UIApplication.shared.keyWindow?.rootViewController
    {

        var topVC = rootVC
        while topVC.presentedViewController != nil
        {
            topVC = topVC.presentedViewController!;
        }
        return topVC
    }

    return nil
}

func getTheMostTopView() -> UIView!
{

    if let topVC = getTheMostTopViewController()
    {
        return topVC.view
    }
    return nil
}
