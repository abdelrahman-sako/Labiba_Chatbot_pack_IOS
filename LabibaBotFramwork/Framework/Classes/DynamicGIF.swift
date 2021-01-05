//
//  DynamicGIF.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 8/26/19.
//  Copyright © 2019 Abdul Rahman. All rights reserved.
//

import UIKit
//import Alamofire

class DynamicGIF: UIView {

    @IBOutlet weak var imageView: UIImageView!
    
    private var _loadingTask: DataRequest?
    class func create() -> DynamicGIF
    {
        let podBundle = Bundle(for: ConversationViewController.self)
        return podBundle.loadNibNamed(String(describing: DynamicGIF.self), owner: nil, options: nil)![0] as! DynamicGIF
    }
    
    override func awakeFromNib() {
        self.isUserInteractionEnabled = false
    }
    
    func popUp(on view: UIView) -> Void
    {
        let root = view
        let r = root.frame
        let w = r.size.width
        let h = r.size.height
        self.frame = CGRect(x: 0, y: 0, width: w, height: h)
        root.addSubview(self)
    }
    
    func showGIF(url: URL , looping:Bool = false) -> Void
    {
        _loadingTask =  request(url).responseData(completionHandler: { (response) in
            if let error = response.result.error
            {
                print("Error  while loading dynamic gif , error (\(error.localizedDescription))")
                
            }else if let data = response.result.value
            {
                self.imageView.gif(data: data , looping:looping )
            }
        })
   
    }
    
    func remove() -> Void
    {
        self._loadingTask?.cancel()
        self.removeFromSuperview()
    }
    
    
    
}
