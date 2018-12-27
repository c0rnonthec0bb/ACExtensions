//
//  ImageView.swift
//  Revree iOS
//
//  Created by Adam Cobb on 6/20/17.
//  Copyright © 2017 Revree. All rights reserved.
//

import UIKit

open class UIImageViewX : UIView{ //for insets
    private let imageView = UIImageView()
    
    open var image:UIImage?{
        get{
            return imageView.image
        }
        
        set(value){
            imageView.image = value
        }
    }
    
    open override var contentMode:UIView.ContentMode{
        get{
            return imageView.contentMode
        }
        
        set(value){
            imageView.contentMode = value
        }
    }
    
    public required init(coder:NSCoder?){
        
        if coder == nil{
            super.init(frame: .zero)
        }else{
            super.init(coder: coder!)!
        }
        
        self.setInsets(.zero)
        self.addSubview(imageView)
        contentMode = .scaleAspectFit
        LayoutParams.alignParentLeftRight(subview: imageView)
        LayoutParams.alignParentTopBottom(subview: imageView)
    }
    
    public convenience init(){
        self.init(coder: nil)
    }
    
    public func adoptImageAspectRatio(){
        if let image = image{
            LayoutParams.setAspectRatio(view: self, widthToHeight: image.size.widthToHeight)
        }
    }
}

