//
//  ProgressBar.swift
//  Uplift
//
//  Created by Adam Cobb on 12/29/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import UIKit

public class ProgressBar : UIActivityIndicatorView{
    required public init(coder:NSCoder?){
        
        if coder == nil{
            super.init(frame: .zero)
        }else{
            super.init(coder: coder!)
        }
        
        self.startAnimating()
    }
    
    public convenience init(withColor: UIColor){
        self.init(coder: nil)
        self.color = withColor
    }
}
