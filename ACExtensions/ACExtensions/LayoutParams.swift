//
//  LayoutParams.swift
//  Uplift
//
//  Created by Adam Cobb on 9/26/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import UIKit

public class LayoutParams {
    
    public static func setWidth(view:UIView, width:CGFloat){
        
        if view.translatesAutoresizingMaskIntoConstraints{
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        if !view.clipsToBounds{
            view.clipsToBounds = true
        }
        var widthConstraint:NSLayoutConstraint?
        for constraint in view.constraints{
            if constraint.firstAttribute == .width && constraint.secondItem == nil{
                widthConstraint = constraint
            }
        }
        if widthConstraint != nil{
            widthConstraint!.constant = width
        }else{
            widthConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        }
        
        widthConstraint!.isActive = true
    }
    
    public static func setHeight(view:UIView, height:CGFloat){
        
        if view.translatesAutoresizingMaskIntoConstraints{
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        if !view.clipsToBounds{
            view.clipsToBounds = true
        }
        var heightConstraint:NSLayoutConstraint?
        for constraint in view.constraints{
            if constraint.firstAttribute == .height && constraint.secondItem == nil{
                heightConstraint = constraint
            }
        }
        if heightConstraint != nil{
            heightConstraint!.constant = height
        }else{
            heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        }
        
        heightConstraint!.isActive = true
    }
    
    public static func setWidthHeight(view:UIView, width:CGFloat, height:CGFloat){
        setWidth(view: view, width: width)
        setHeight(view: view, height: height)
    }
    
    private static func superviewReady(for view: UIView)->Bool{
        if let superview = view.superview{
            if !superview.insetsSet(){
                superview.setInsets(.zero)
            }
            return true
        }
        return false
    }
    
    public static func setEqualConstraint(view1:UIView, attribute1: NSLayoutConstraint.Attribute, view2:@escaping ()->UIView?, attribute2: NSLayoutConstraint.Attribute?, ratio:CGFloat, margin:CGFloat, isReady:@escaping ()->Bool){
        
        if view1.translatesAutoresizingMaskIntoConstraints{
            view1.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if !view1.clipsToBounds{
            view1.clipsToBounds = true
        }
        
        if isReady(){
            let attribute2:NSLayoutConstraint.Attribute = attribute2 != nil ? attribute2! : .notAnAttribute
            let constraint = NSLayoutConstraint(item: view1, attribute: attribute1, relatedBy: .equal, toItem: view2(), attribute: attribute2, multiplier: ratio, constant: margin)
            constraint.isActive = true
        }else{
            if let context = UIViewControllerX.context{
                context.constraintsToActivate.append((isReady, {
                    let attribute2:NSLayoutConstraint.Attribute = attribute2 != nil ? attribute2! : .notAnAttribute
                    return NSLayoutConstraint(item: view1, attribute: attribute1, relatedBy: .equal, toItem: view2(), attribute: attribute2, multiplier: ratio, constant: margin)
                }))
            }else{
                Async.run(SyncInterface(runTask: {
                    setEqualConstraint(view1: view1, attribute1: attribute1, view2: view2, attribute2: attribute2, ratio: ratio, margin: margin, isReady: isReady)
                }))
            }
        }
    }
    
    public static func setEqualConstraint(view1:UIView, attribute1: NSLayoutConstraint.Attribute, view2:@escaping ()->UIView?, attribute2: NSLayoutConstraint.Attribute?, isReady:@escaping ()->Bool){
        setEqualConstraint(view1: view1, attribute1: attribute1, view2: view2, attribute2: attribute2, ratio: 1, margin: 0, isReady: isReady)
    }
    
    public static func setEqualConstraint(view1:UIView, attribute1: NSLayoutConstraint.Attribute, view2:UIView?, attribute2:NSLayoutConstraint.Attribute?, ratio:CGFloat, margin:CGFloat){
        setEqualConstraint(view1: view1, attribute1: attribute1, view2: {return view2}, attribute2: attribute2, ratio: ratio, margin: margin, isReady:{
            if let view2 = view2{
                return (view1.window != nil && view1.window == view2.window) || view1.superview == view2 || view2.superview == view1 || (view1.superview != nil && view1.superview == view2.superview)
            }else{
                return true
            }})
    }
    
    public static func setEqualConstraint(view1:UIView, attribute1: NSLayoutConstraint.Attribute, view2:UIView?, attribute2:NSLayoutConstraint.Attribute?){
        setEqualConstraint(view1: view1, attribute1: attribute1, view2: view2, attribute2: attribute2, ratio: 1, margin: 0)
    }
    
    public static func setAspectRatio(view:UIView, widthToHeight:CGFloat){
        setEqualConstraint(view1: view, attribute1: .width, view2: view, attribute2: .height, ratio: widthToHeight, margin: 0)
    }
    
    public static func alignLeft(view1:UIView, view2:UIView, margin:CGFloat = 0){
        setEqualConstraint(view1: view1, attribute1: .left, view2: view2, attribute2: .left, ratio: 1, margin: margin)
    }
    
    public static func alignRight(view1:UIView, view2:UIView, margin:CGFloat = 0){
        setEqualConstraint(view1: view1, attribute1: .right, view2: view2, attribute2: .right, ratio: 1, margin: -margin)
    }
    
    public static func alignLeftRight(view1:UIView, view2:UIView){
        alignLeft(view1: view1, view2: view2)
        alignRight(view1: view1, view2: view2)
    }
    
    public static func alignTop(view1:UIView, view2:UIView, margin:CGFloat = 0){
        setEqualConstraint(view1: view1, attribute1: .top, view2: view2, attribute2: .top, ratio: 1, margin: margin)
    }
    
    public static func alignBottom(view1:UIView, view2:UIView, margin:CGFloat = 0){
        setEqualConstraint(view1: view1, attribute1: .bottom, view2: view2, attribute2: .bottom, ratio: 1, margin: -margin)
    }
    
    public static func alignTopBottom(view1:UIView, view2:UIView){
        alignTop(view1: view1, view2: view2)
        alignBottom(view1: view1, view2: view2)
    }
    
    public static func centerVertical(view1:UIView, view2:UIView, margin:CGFloat = 0){
        setEqualConstraint(view1: view1, attribute1: .centerY, view2: view2, attribute2: .centerY, ratio: 1, margin: margin)
    }
    
    public static func centerHorizontal(view1:UIView, view2:UIView, margin:CGFloat = 0){
        setEqualConstraint(view1: view1, attribute1: .centerX, view2: view2, attribute2: .centerX, ratio: 1, margin: margin)
    }
    
    public static func alignParentLeft(subview:UIView, margin:CGFloat = 0){
        setEqualConstraint(view1: subview, attribute1: .left, view2: {return subview.superview}, attribute2: .leftMargin, ratio: 1, margin: margin, isReady:{return superviewReady(for: subview)})
    }
    
    public static func alignParentRight(subview:UIView, margin:CGFloat = 0){
        setEqualConstraint(view1: subview, attribute1: .right, view2: {return subview.superview}, attribute2: .rightMargin, ratio: 1, margin: -margin, isReady:{return superviewReady(for: subview)})
    }
    
    public static func alignParentLeftRight(subview:UIView, marginLeft:CGFloat = 0, marginRight:CGFloat = 0){
        alignParentLeft(subview: subview, margin: marginLeft)
        alignParentRight(subview: subview, margin: marginRight)
    }
    
    public static func alignParentTop(subview:UIView, margin:CGFloat = 0){
        setEqualConstraint(view1: subview, attribute1: .top, view2: {return subview.superview}, attribute2: .topMargin, ratio: 1, margin: margin, isReady:{return superviewReady(for: subview)})
    }
    
    public static func alignParentBottom(subview:UIView, margin:CGFloat = 0){
        setEqualConstraint(view1: subview, attribute1: .bottom, view2: {return subview.superview}, attribute2: .bottomMargin, ratio: 1, margin: -margin, isReady:{return superviewReady(for: subview)})
    }
    
    public static func alignParentTopBottom(subview:UIView, marginTop:CGFloat = 0, marginBottom:CGFloat = 0){
        alignParentTop(subview: subview, margin: marginTop)
        alignParentBottom(subview: subview, margin: marginBottom)
    }
    
    public static func alignParentScrollVertical(subview:UIView){
        alignParentLeftRight(subview: subview)
        alignParentTopBottom(subview: subview)
        setEqualConstraint(view1: subview, attribute1: .width, view2: {return subview.superview}, attribute2: .width, isReady:{return superviewReady(for: subview)})
    }
    
    public static func alignParentScrollHorizontal(subview:UIView){
        alignParentLeftRight(subview: subview)
        alignParentTopBottom(subview: subview)
        setEqualConstraint(view1: subview, attribute1: .height, view2: {return subview.superview}, attribute2: .height, isReady:{return superviewReady(for: subview)})
    }
    
    public static func centerParentHorizontal(subview:UIView, margin:CGFloat = 0){
        setEqualConstraint(view1: subview, attribute1: .centerX, view2: {return subview.superview}, attribute2: .centerX, ratio: 1, margin: margin, isReady:{return superviewReady(for: subview)})
    }
    
    public static func centerParentVertical(subview:UIView, margin:CGFloat = 0){
        setEqualConstraint(view1: subview, attribute1: .centerY, view2: {return subview.superview}, attribute2: .centerY, ratio: 1, margin: margin, isReady:{return superviewReady(for: subview)})
    }
    
    public static func stackVertical(topView:UIView, bottomView:UIView){
        setEqualConstraint(view1: bottomView, attribute1: .top, view2: topView, attribute2: .bottom)
    }
    
    public static func stackHorizontal(leftView:UIView, rightView:UIView){
        setEqualConstraint(view1: rightView, attribute1: .left, view2: leftView, attribute2: .right)
    }
    
    public static func stackVertical(topView:UIView, bottomView:UIView, margin:CGFloat){
        setEqualConstraint(view1: bottomView, attribute1: .top, view2: topView, attribute2: .bottom, ratio: 1, margin: margin)
    }
    
    public static func stackHorizontal(leftView:UIView, rightView:UIView, margin:CGFloat){
        setEqualConstraint(view1: rightView, attribute1: .left, view2: leftView, attribute2: .right, ratio: 1, margin: margin)
    }
}

public class RelativeParams{
    var actions:[(UIView)->()] = []
    
    public init(){
        
    }
    
    public func setWidth(_ width:CGFloat)->Self{
        actions.append{ view in
            LayoutParams.setWidth(view: view, width: width)
        }
        return self
    }
    
    public func setHeight(_ height:CGFloat)->Self{
        actions.append{ view in
            LayoutParams.setHeight(view: view, height: height)
        }
        return self
    }
    
    public func setWidthHeight(_ width:CGFloat, _ height:CGFloat)->Self{
        actions.append{ view in
            LayoutParams.setWidthHeight(view: view, width: width, height: height)
        }
        return self
    }
    
    public func setAspectRatio(widthToHeight:CGFloat)->Self{
        actions.append{ view in
            LayoutParams.setAspectRatio(view: view, widthToHeight: widthToHeight)
        }
        return self
    }
    
    public func alignLeft(view2:UIView, margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.alignLeft(view1: view, view2: view2, margin: margin)
        }
        return self
    }
    
    public func alignRight(view2:UIView, margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.alignRight(view1: view, view2: view2, margin: margin)
        }
        return self
    }
    
    public func alignLeftRight(view2:UIView)->Self{
        actions.append{ view in
            LayoutParams.alignLeftRight(view1: view, view2: view2)
        }
        return self
    }
    
    public func alignTop(view2:UIView, margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.alignTop(view1: view, view2: view2, margin: margin)
        }
        return self
    }
    
    public func alignBottom(view2:UIView, margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.alignBottom(view1: view, view2: view2, margin: margin)
        }
        return self
    }
    
    public func alignTopBottom(view2:UIView)->Self{
        actions.append{ view in
            LayoutParams.alignTopBottom(view1: view, view2: view2)
        }
        return self
    }
    
    public func centerVertical(view2:UIView, margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.centerVertical(view1: view, view2: view2, margin: margin)
        }
        return self
    }
    
    public func centerHorizontal(view2:UIView, margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.centerHorizontal(view1: view, view2: view2, margin: margin)
        }
        return self
    }
    
    public func alignParentLeft(margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.alignParentLeft(subview: view, margin: margin)
        }
        return self
    }
    
    public func alignParentRight(margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.alignParentRight(subview: view, margin: margin)
        }
        return self
    }
    
    public func alignParentLeftRight(marginLeft:CGFloat = 0, marginRight:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.alignParentLeftRight(subview: view, marginLeft: marginLeft, marginRight: marginRight)
        }
        return self
    }
    
    public func alignParentTop(margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.alignParentTop(subview: view, margin: margin)
        }
        return self
    }
    
    public func alignParentBottom(margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.alignParentBottom(subview: view, margin: margin)
        }
        return self
    }
    
    public func alignParentTopBottom(marginTop:CGFloat = 0, marginBottom:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.alignParentTopBottom(subview: view, marginTop: marginTop, marginBottom: marginBottom)
        }
        return self
    }
    
    public func alignParentScrollVertical()->Self{
        actions.append{ view in
            LayoutParams.alignParentScrollVertical(subview: view)
        }
        return self
    }
    
    public func alignParentScrollHorizontal()->Self{
        actions.append{ view in
            LayoutParams.alignParentScrollHorizontal(subview: view)
        }
        return self
    }
    
    public func centerParentHorizontal(margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.centerParentHorizontal(subview: view, margin: margin)
        }
        return self
    }
    
    public func centerParentVertical(margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.centerParentVertical(subview: view, margin: margin)
        }
        return self
    }
    
    public func stackBelow(topView:UIView, margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.stackVertical(topView: topView, bottomView: view, margin: margin)
        }
        return self
    }
    
    public func stackAbove(bottomView:UIView, margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.stackVertical(topView: view, bottomView: bottomView, margin: margin)
        }
        return self
    }
    
    public func stackLeftOf(rightView:UIView, margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.stackHorizontal(leftView: view, rightView: rightView, margin: margin)
        }
        return self
    }
    
    public func stackRightOf(leftView:UIView, margin:CGFloat = 0)->Self{
        actions.append{ view in
            LayoutParams.stackHorizontal(leftView: leftView, rightView: view, margin: margin)
        }
        return self
    }
}

public class LinearParams: RelativeParams {}

public extension UIView{
    public func addSubview(_ view:UIView, _ params:RelativeParams){
        self.addSubview(view)
        
        for action in params.actions{
            action(view)
        }
    }
}
