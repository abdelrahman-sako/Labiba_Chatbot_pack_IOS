//
//  ContentSizedTableView.swift
//  LabibaBotFramwork
//
//  Created by Osama Hasan on 10/05/2023.
//  Copyright © 2023 Abdul Rahman. All rights reserved.
//

import Foundation
import UIKit
final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height + contentInset.bottom)
    }
}
