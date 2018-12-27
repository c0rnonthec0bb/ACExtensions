//
//  Number.swift
//  Uplift
//
//  Created by Adam Cobb on 11/2/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import UIKit

public extension Int{
    public func sign()->Int{
        return self == 0 ? 0 : self > 0 ? 1 : -1
    }
}

public extension CGFloat{
    public func sign()->CGFloat{
        return self == 0 ? 0 : self > 0 ? 1 : -1
    }
}
