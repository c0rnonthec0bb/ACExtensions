//
//  Point.swift
//  Extensions
//
//  Created by Adam on 12/24/17.
//  Copyright © 2017 Revree. All rights reserved.
//

import UIKit

public extension CGPoint{
    func isWithin(rect:CGRect)->Bool{
        return x >= rect.minX && x <= rect.maxX && y >= rect.minY && y <= rect.maxY
    }
}
