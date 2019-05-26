//
//  Insets.swift
//  Extensions
//
//  Created by Adam on 5/16/18.
//  Copyright © 2018 Revree. All rights reserved.
//

import UIKit

public extension UIEdgeInsets{
    init(topBottom:CGFloat, leftRight: CGFloat) {
        self.init(top: topBottom, left: leftRight, bottom: topBottom, right: leftRight)
    }
}
