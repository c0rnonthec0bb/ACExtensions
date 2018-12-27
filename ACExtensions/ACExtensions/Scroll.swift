//
//  Scroll.swift
//  Uplift
//
//  Created by Adam Cobb on 11/30/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import UIKit

open class UIScrollViewX : UIScrollView, UIScrollViewDelegate{
    
    required public init(coder:NSCoder?){
        
        if let coder = coder{
            super.init(coder: coder)!
        }else{
            super.init(frame: .zero)
        }
        
        self.delegate = self
        self.bounces = false
        self.delaysContentTouches = false
        self.panGestureRecognizer.cancelsTouchesInView = false
    }
    
    public convenience init (){
        self.init(coder: nil)
    }
    
    open var canScroll = true
    open var horizontalScrollingEnabled = true
    open var verticalScrollingEnabled = true
    
    override open var contentOffset: CGPoint{
        get{
            return super.contentOffset
        }
        
        set(value){
            if canScroll{
                super.contentOffset = CGPoint(x: horizontalScrollingEnabled ? value.x : contentOffset.x, y: verticalScrollingEnabled ? value.y : contentOffset.y)
            }
            scrollViewDidScroll(self)
        }
    }
    
    open var scrollChangedListeners:[(_ scroll: CGPoint)->Void] = []
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for listener in self.scrollChangedListeners{
            listener(contentOffset)
        }
    }
    
    open var scrollY:CGFloat{
        get{
            return contentOffset.y
        }
        
        set(scroll){
            let oldCanScroll = canScroll
            canScroll = true
            let scroll = max(0, min(contentSize.height - originalSize.height, scroll))
            setContentOffset(CGPoint(x: contentOffset.x, y:scroll), animated: false)
            canScroll = oldCanScroll
        }
    }
    
    open var scrollX:CGFloat{
        get{
            return contentOffset.x
        }
        
        set(scroll){
            let oldCanScroll = canScroll
            canScroll = true
            let scroll = max(0, min(contentSize.width - originalSize.width, scroll))
            setContentOffset(CGPoint(x: scroll, y:contentOffset.y), animated: false)
            canScroll = oldCanScroll
        }
    }
    
    open func smoothScrollY(_ scroll: CGFloat, durationInMillis:Int64, delay:Int64 = 0, curve: UIView.AnimationOptions = .curveEaseInOut){
        UIView.animate(withDuration: TimeInterval(durationInMillis) / 1000, delay: TimeInterval(delay) / 1000, options: curve, animations: {
            self.scrollY = scroll
        }, completion: nil)
    }
    
    open func smoothScrollX(_ scroll: CGFloat, durationInMillis:Int64, delay:Int64 = 0, curve: UIView.AnimationOptions = .curveEaseInOut){
        UIView.animate(withDuration: TimeInterval(durationInMillis) / 1000, delay: TimeInterval(delay) / 1000, options: curve, animations: {
            self.scrollX = scroll
        }, completion: nil)
    }
}
