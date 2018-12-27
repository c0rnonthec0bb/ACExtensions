//
//  Switch.swift
//  Extensions
//
//  Created by Adam on 8/23/18.
//  Copyright © 2018 Revree. All rights reserved.
//

import UIKit

extension UISwitch{
    
    open override var clipsToBounds: Bool{
        set{
            super.clipsToBounds = false
        }
        get{
            return false
        }
    }
}

open class UISwitchX : UISwitch{
    required public init(coder:NSCoder? = nil) {
        super.init(frame: .zero)
        
        addTarget(self, action: #selector(flipped), for: .valueChanged)
    }
    
    open var onFlippedListeners:[(Bool)->()] = []
    
    @objc open func flipped(){
        for listener in onFlippedListeners{
            listener(isOn)
        }
    }
}
