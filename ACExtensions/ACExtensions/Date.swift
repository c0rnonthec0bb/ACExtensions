//
//  Date.swift
//  Uplift
//
//  Created by Adam Cobb on 1/3/17.
//  Copyright © 2017 Adam Cobb. All rights reserved.
//

import Foundation

public typealias Milliseconds = Int64

public extension Date{
    public var timeInMillis:Milliseconds{
        return Milliseconds(timeIntervalSince1970 * 1000)
    }
    
    init(milliseconds: Milliseconds) {
        self.init(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
