//
//  VMenuCellTheme.swift
//  LabibaBotFramwork
//
//  Created by Osama Hasan on 10/05/2023.
//  Copyright © 2023 Abdul Rahman. All rights reserved.
//

import Foundation

public struct VMenuCellTheme {
    public var isImageHidden:Bool
    public var imageTintColor:UIColor = .clear
    public var imageBackgroundColor:UIColor?
    public var contentLabelTheme:TextTheme
    public var imageCornerTheme: ViewTheme
    public var cellCornerTheme: ViewTheme
    public var shadow : LabibaUIShadow?
    
    public init(isImageHidden: Bool = false, imageTintColor: UIColor  = .clear, imageBackgroundColor: UIColor? = nil, contentLabelTheme: TextTheme = TextTheme(), imageCornerTheme: ViewTheme = ViewTheme() , cellCornerTheme: ViewTheme = ViewTheme(), shadow: LabibaUIShadow? = nil) {
        self.isImageHidden = isImageHidden
        self.imageTintColor = imageTintColor
        self.imageBackgroundColor = imageBackgroundColor
        self.contentLabelTheme = contentLabelTheme
        self.imageCornerTheme = imageCornerTheme
        self.cellCornerTheme = cellCornerTheme
        self.shadow = shadow
    }
}


public struct TextTheme {
    public var fontStyle:UIFont
    public var textColor: UIColor
    
    public init(fontStyle: UIFont  = UIFont.systemFont(ofSize: 17), textColor: UIColor = .black) {
        self.fontStyle = fontStyle
        self.textColor = textColor
    }
    
}

public struct ViewTheme {
    public var  corners: UIRectCorner
    public var radius: CGFloat
    public init(corners: UIRectCorner = .allCorners, radius: CGFloat = 8) {
        self.corners = corners
        self.radius = radius
    }
}

public struct LabibaUIShadow {
    public var offset: CGSize
    public var opacity: Float
    public var radius : CGFloat
    public var color : UIColor
    
    public init(offset: CGSize = CGSize(width: 0, height: 0) , opacity: Float = 1.0, radius: CGFloat = 1.0 , color: UIColor = .black) {
        self.offset = offset
        self.opacity = opacity
        self.radius = radius
        self.color = color
    }
    
}
