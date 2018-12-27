//
//  Touch.swift
//  Uplift
//
//  Created by Adam Cobb on 11/3/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//


import UIKit
import WebKit

//private var touchListenerKey: UInt8 = 0

public class TouchListener {
    
    var touchDown:(UIView, [UITouch])->Bool
    var touchMove:(UIView, [UITouch])->Bool
    var touchUp:(UIView, [UITouch])->Bool
    var touchCancel:(UIView, [UITouch])->Bool
    
    public convenience init(return value:Bool){
        self.init(touchDown: {_,_  in return value}, touchMove: {_,_ in return value}, touchUpCancel: {_,_,_ in return value})
    }
    
    public init(touchDown:@escaping (UIView, [UITouch])->Bool, touchMove:@escaping(UIView, [UITouch])->Bool, touchUp:@escaping(UIView, [UITouch])->Bool, touchCancel:@escaping(UIView, [UITouch])->Bool){
        self.touchDown = touchDown
        self.touchMove = touchMove
        self.touchUp = touchUp
        self.touchCancel = touchCancel
    }
    
    public init(touchDown:@escaping (UIView, [UITouch])->Bool, touchMove:@escaping(UIView, [UITouch])->Bool, touchUpCancel:@escaping(Bool, UIView, [UITouch])->Bool){
        self.touchDown = touchDown
        self.touchMove = touchMove
        self.touchUp = { (view, touches) in
            return touchUpCancel(true, view, touches)
        }
        self.touchCancel = {(view, touches) in
            return touchUpCancel(false, view, touches)
        }
    }
    
    internal static let listenerTable = NSMapTable<UIView, TouchListener>.init(keyOptions: [.weakMemory], valueOptions: [.strongMemory])
    
    internal static var disabledViews:[UIView] = []
    
    internal static var lastModeIsBegan = false
    internal static var lastInterceptedView:UIView? = nil
    
    internal static func submitTouchFunction(_ function:(UIView, [UITouch])->Bool, view: UIView, touches: [UITouch]){
        
        if !view.isHidden, lastInterceptedView == nil || lastInterceptedView == view{
            
            if view.getTouchEnabled(){
                if function(view, touches){
                    lastInterceptedView = view
                }else{
                    lastInterceptedView = nil
                }
            }else{
                lastInterceptedView = nil
            }
        }
    }
}

extension UIView{
    
    internal func myHeiarchy()->[Int]{
        var reverseHeiarchy:[Int] = []
        var view:UIView = self
        while(view.superview != nil){
            var subNum = 0
            for sub in view.superview!.subviews{
                if sub == view{
                    reverseHeiarchy.append(subNum)
                }
                subNum += 1
            }
            view = view.superview!
        }
        return reverseHeiarchy.reversed()
    }
    
    internal func printMyHeirarchy(){
        print("view heirarchy: \(myHeiarchy())")
    }
    
    public func setTouchEnabled(_ enabled:Bool){
        if enabled{
            for i in stride(from: TouchListener.disabledViews.count - 1, through: 0, by: -1){
                if TouchListener.disabledViews[i] === self{
                    TouchListener.disabledViews.remove(at: i)
                }
            }
        }else{
            TouchListener.disabledViews.append(self)
        }
        let _ = UIViewControllerX.context.view.fixUserInteraction()
    }
    
    public func getTouchEnabled()->Bool{
        return !TouchListener.disabledViews.contains(self)
    }
    
    internal class TouchListenerPair{
        var view: UIView
        var listener: TouchListener?
        init(view: UIView, listener:TouchListener?){
            self.view = view
            self.listener = listener
        }
    }
    
    internal class WeakTouchListenerPair{
        var pair:TouchListenerPair?
        init(view: UIView, listener:TouchListener?){
            self.pair = TouchListenerPair(view: view, listener: listener)
        }
    }
    
    public var touchListener:TouchListener?{
        get{
            //return (objc_getAssociatedObject(self, &touchListenerKey) as? WeakTouchListenerPair)?.pair?.listener
            return TouchListener.listenerTable.object(forKey: self)
        }
        
        set{
            //objc_setAssociatedObject(self, &touchListenerKey, WeakTouchListenerPair(view: self, listener: newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            TouchListener.listenerTable.setObject(newValue, forKey: self)
            let _ = UIViewControllerX.context.view.fixUserInteraction()
        }
    }
    
    @objc internal func fixUserInteraction()->Bool{
        var touchEnabled = false
        if /*!isHidden &&*/ getTouchEnabled(){
            for subview in subviews{
                if subview.fixUserInteraction(){
                    touchEnabled = true
                }
            }
            if touchListener != nil || !(gestureRecognizers?.isEmpty ?? true) {
                touchEnabled = true
            }
        }
        isUserInteractionEnabled = touchEnabled
        return touchEnabled
    }
    
    internal func touchesBeganX(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !TouchListener.lastModeIsBegan{
            TouchListener.lastModeIsBegan = true
            TouchListener.lastInterceptedView = nil
        }
        
        printMyHeirarchy()
        
        if self == UIViewControllerX.context.view{
            let _ = fixUserInteraction()
        }
        
        if let listener = touchListener{
            
            var touches = touches
            
            if let event = event{
                if let allTouches = event.allTouches{
                    touches = allTouches
                }
            }
            
            TouchListener.submitTouchFunction(listener.touchDown, view: self, touches: Array(touches))
        }else if TouchListener.lastInterceptedView == self{
            TouchListener.lastInterceptedView = nil
        }
    }
    
    internal func touchesMovedX(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        TouchListener.lastModeIsBegan = false
        
        if let listener = touchListener{
        
        var touches = touches
        
        if let event = event{
            if let allTouches = event.allTouches{
                touches = allTouches
            }
        }
        
            TouchListener.submitTouchFunction(listener.touchMove, view: self, touches: Array(touches))
        }else if TouchListener.lastInterceptedView == self{
            TouchListener.lastInterceptedView = nil
        }
    }
    
    internal func touchesEndedX(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        TouchListener.lastModeIsBegan = false
        
        if let listener = touchListener{
        
        var touches = touches
        
        if let event = event{
            if let allTouches = event.allTouches{
                touches = allTouches
            }
        }
        
            TouchListener.submitTouchFunction(listener.touchUp, view: self, touches: Array(touches))
        }else if TouchListener.lastInterceptedView == self{
            TouchListener.lastInterceptedView = nil
        }
    }
    
    internal func touchesCancelledX(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        TouchListener.lastModeIsBegan = false
        
        if let listener = touchListener{
        
        var touches = touches
        
        if let event = event{
            if let allTouches = event.allTouches{
                touches = allTouches
            }
        }
        
            TouchListener.submitTouchFunction(listener.touchCancel, view: self, touches: Array(touches))
        }else if TouchListener.lastInterceptedView == self{
            TouchListener.lastInterceptedView = nil
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesBeganX(touches, with: event)
        super.touchesBegan(touches, with: event)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesMovedX(touches, with: event)
        super.touchesMoved(touches, with: event)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEndedX(touches, with: event)
        super.touchesEnded(touches, with: event)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesCancelledX(touches, with: event)
        super.touchesCancelled(touches, with: event)
    }
}

public class TouchEnabledView:UIView{
    @objc override func fixUserInteraction() -> Bool {
        isUserInteractionEnabled = true
        return true
    }
}

extension UIScrollViewX{
    
    @objc internal override func fixUserInteraction() -> Bool {
        for subview in subviews{
            let _ = subview.fixUserInteraction()
        }
        isUserInteractionEnabled = true
        return true
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesBeganX(touches, with: event)
        super.touchesBegan(touches, with: event)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesMovedX(touches, with: event)
        
        if TouchListener.lastInterceptedView == nil{
            TouchListener.lastInterceptedView = self
            canScroll = true
        }else{
            panGestureRecognizer.setTranslation(.zero, in: nil)
            canScroll = false
        }
        
        super.touchesMoved(touches, with: event)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEndedX(touches, with: event)
        super.touchesEnded(touches, with: event)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesCancelledX(touches, with: event)
        super.touchesCancelled(touches, with: event)
    }
}

internal extension UITextView{
    
    @objc override func fixUserInteraction() -> Bool {
        isUserInteractionEnabled = true
        return true
    }
}

internal extension UITextField{
    
    @objc override func fixUserInteraction() -> Bool {
        isUserInteractionEnabled = true
        return true
    }
}

internal extension UISwitch{
    @objc override func fixUserInteraction() -> Bool {
        isUserInteractionEnabled = true
        return true
    }
}

extension WKWebView{
    @objc override func fixUserInteraction() -> Bool {
        isUserInteractionEnabled = true
        return true
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesBeganX(touches, with: event)
        super.touchesBegan(touches, with: event)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesMovedX(touches, with: event)
        
        if TouchListener.lastInterceptedView == nil{
            TouchListener.lastInterceptedView = self
        }
        
        super.touchesMoved(touches, with: event)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEndedX(touches, with: event)
        super.touchesEnded(touches, with: event)
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesCancelledX(touches, with: event)
        super.touchesCancelled(touches, with: event)
    }
}
