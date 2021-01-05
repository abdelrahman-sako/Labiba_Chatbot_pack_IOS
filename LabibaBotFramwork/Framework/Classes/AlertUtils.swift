//
//  AlertUtils.swift
//  Visit Jordan Bot
//
//  Created by AhmeDroid on 10/13/16.
//  Copyright © 2016 Imagine Technologies. All rights reserved.
//

import UIKit

func showErrorMessage(_ message: String) -> Void
{

    DispatchQueue.main.async
    {

        let alert = UIAlertController(title: localString("app-title"),
                message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: localString("OK"), style: .default, handler: { _ in })

        alert.addAction(okAction)
        getTheMostTopViewController().present(alert, animated: true, completion: {})
    }
}
func showErrorMessage(title:String, message: String) -> Void
{

    DispatchQueue.main.async
    {

        let alert = UIAlertController(title: title,
                message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: localString("OK"), style: .default, handler: { _ in })

        alert.addAction(okAction)
        getTheMostTopViewController().present(alert, animated: true, completion: {})
    }
}

func showErrorMessage(_ message: String ,okHandelr:(()->Void)? = nil ) -> Void
{
    
    DispatchQueue.main.async
        {
            
            let alert = UIAlertController(title: "app-title".localForChosnLangCodeBB,
                                          message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title:"OK".localForChosnLangCodeBB, style: .default, handler: { _ in
                okHandelr?()
            })
            alert.addAction(okAction)
            getTheMostTopViewController().present(alert, animated: true, completion: {})
    }
}
func showErrorMessage(_ message: String ,okHandelr:(()->Void)? = nil , cancelHandler:(()->Void)? = nil) -> Void
{
    
    DispatchQueue.main.async
        {
            
            let alert = UIAlertController(title: "app-title".localForChosnLangCodeBB,
                                          message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK".localForChosnLangCodeBB, style: .default, handler: { _ in
                okHandelr?()
            })
            let cancelAction = UIAlertAction(title: "Cancel".localForChosnLangCodeBB, style: .default, handler: { _ in
                cancelHandler?()
            })
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
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
