//
//  View.swift
//  Uplift
//
//  Created by Adam Cobb on 10/12/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import UIKit

public class ViewHelper{
    internal static var onDidLayoutSubviews:[UIView:[()->Void]] = [:]
    
    public static func addOnDidLayoutSubviews(view:UIView, action:@escaping ()->()){
        var array = onDidLayoutSubviews[view] ?? []
        array.append(action)
        onDidLayoutSubviews[view] = array
    }
}

private var measuredOriginKey: UInt8 = 0
private var measuredSizeKey: UInt8 = 1
private var insetsSetKey: UInt8 = 2
private var backgroundViewKey: UInt8 = 3
private var subviewVisibilityChangedKey: UInt8 = 4

public extension UIView{
    
    public var measuredOrigin:CGPoint{
        get{
            if let value = objc_getAssociatedObject(self, &measuredOriginKey) as? CGPoint{
                return value
            }
            return originalOrigin
        }
        set(value){
            objc_setAssociatedObject(self, &measuredOriginKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            Async.run(SyncInterface(runTask: {
                objc_setAssociatedObject(self, &measuredOriginKey, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }))
        }
    }
    
    public var measuredSize:CGSize{
        get{
            if let value = objc_getAssociatedObject(self, &measuredSizeKey) as? CGSize{
                return value
            }
            return originalSize
        }
        set(value){
            objc_setAssociatedObject(self, &measuredSizeKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            Async.run(SyncInterface(runTask: {
                objc_setAssociatedObject(self, &measuredSizeKey, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }))
        }
    }
    
    public func removeAllViews(){
        let subviews = self.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
        
    }
    
    @objc public func setInsets(_ insets:UIEdgeInsets){
        layoutMargins = insets
        
        objc_setAssociatedObject(self, &insetsSetKey, true, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    public func insetsSet()->Bool{
        if let _ = objc_getAssociatedObject(self, &insetsSetKey){
            return true
        }
        return false
    }
    
    public func getInsets()->UIEdgeInsets{
        if insetsSet(){
            return layoutMargins
        }else{
            return .zero
        }
    }
    
    public func roundCorners(corners: UIRectCorner, radius: CGFloat){
        if corners == .allCorners{
            self.layer.cornerRadius = radius
        }else{
            ViewHelper.addOnDidLayoutSubviews(view: self){
                let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
                let mask = CAShapeLayer()
                mask.path = path.cgPath
                self.layer.mask = mask
            }
            superview?.layoutSubviews()
        }
    }
    
    public func setupBorder(color: UIColor?, width: CGFloat){
        layer.borderColor = color?.cgColor
        layer.borderWidth = width
    }
    
    public func currentFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        
        return nil
    }
    
    public var backgroundImage:UIImage?{
        get{
            if let view = objc_getAssociatedObject(self, &backgroundViewKey) as? UIImageView{
                return view.image
            }
            return nil
        }
        
        set(value){
            if let view = objc_getAssociatedObject(self, &backgroundViewKey) as? UIImageView{
                view.removeFromSuperview()
            }
            let view = UIImageView()
            view.image = value
            addSubview(view)
            LayoutParams.setEqualConstraint(view1: view, attribute1: .left, view2: self, attribute2: .left)
            LayoutParams.setEqualConstraint(view1: view, attribute1: .right, view2: self, attribute2: .right)
            LayoutParams.setEqualConstraint(view1: view, attribute1: .top, view2: self, attribute2: .top)
            LayoutParams.setEqualConstraint(view1: view, attribute1: .bottom, view2: self, attribute2: .bottom)
            sendSubviewToBack(view)
        }
    }
    
    public var subviewVisibilityChangedFunc:()->(){
        get{
            if let value = objc_getAssociatedObject(self, &subviewVisibilityChangedKey) as? ()->(){
                return value
            }
            return {}
        }
        set(value){
            objc_setAssociatedObject(self, &subviewVisibilityChangedKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var isHiddenX:Bool{
        get{
            return isHidden
        }
        
        set(value){
            isHidden = value
            var superview = self.superview
            while superview != nil{
                superview!.subviewVisibilityChangedFunc()
                superview = superview!.superview
            }
        }
    }
}
