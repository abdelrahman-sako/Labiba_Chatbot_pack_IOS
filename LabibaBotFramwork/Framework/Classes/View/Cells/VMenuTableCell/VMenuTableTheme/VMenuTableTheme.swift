//
//  VMenuTableTheme.swift
//  LabibaBotFramwork
//
//  Created by Osama Hasan on 10/05/2023.
//  Copyright © 2023 Abdul Rahman. All rights reserved.
//

import Foundation

public struct VMenuTableTheme {
    
    public var separatorStyle : UITableViewCell.SeparatorStyle = .none
    public var backgroundColor : UIColor = .clear
    public var showVerticalIndicator: Bool = true
    public var showHorizontalIndicator: Bool = true
    public var edgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    public var estimatedRowHeight = 85.0
    public var rowHeight = UITableView.automaticDimension
        
}
