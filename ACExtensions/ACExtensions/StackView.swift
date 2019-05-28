//
//  StackView.swift
//  Revree UI Test
//
//  Created by Adam Cobb on 6/3/17.
//  Copyright © 2017 Revree. All rights reserved.
//

import UIKit

open class VerticalStackView: UIView {
    
    required public init(coder:NSCoder? = nil){
        
        if coder == nil{
            super.init(frame: .zero)
        }else{
            super.init(coder: coder!)!
        }
        
        setInsets(.zero)
        
        self.subviewVisibilityChangedFunc = {
            self.needsUpdateConstraintsX = true
            self.setNeedsUpdateConstraints()
        }
    }
    
    open override func addSubview(_ view: UIView) {
        needsUpdateConstraintsX = true
        setNeedsUpdateConstraints()
        super.addSubview(view)
    }
    
    open func addSubview(_ view: UIView, margin:CGFloat, _ params:RelativeParams = RelativeParams()) {
        marginTops[view] = margin
        addSubview(view, params)
    }
    
    var marginTops:[UIView:CGFloat] = [:]
    var subviewConstraints:[NSLayoutConstraint] = []
    
    open var marginBottom:CGFloat = 0
    
    open func marginTop(for view:UIView)->CGFloat{
        if let margin = marginTops[view]{
            return margin
        }
        return 0
    }
    
    override open func updateConstraints() {
        
        super.updateConstraints()
        
        updateConstraintsX()
    }
    
    open var needsUpdateConstraintsX = true
    
    open func updateConstraintsX(){
        
        if !needsUpdateConstraintsX{
            return
        }
        
        needsUpdateConstraintsX = false
        
        NSLayoutConstraint.deactivate(subviewConstraints)
        
        subviewConstraints.removeAll()
        
        var prevView:UIView = self
        for subview in subviews{
            if !subview.isHiddenX{
                let constraint = NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: prevView, attribute: prevView == self ? .topMargin : .bottom, multiplier: 1, constant: marginTop(for:subview))
                subviewConstraints.append(constraint)
                prevView = subview
            }
        }
        
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottomMargin, relatedBy: .equal, toItem: prevView, attribute: prevView == self ? .topMargin : .bottom, multiplier: 1, constant: marginBottom)
        subviewConstraints.append(bottomConstraint)
        
        NSLayoutConstraint.activate(subviewConstraints)
    }
    
    override open func willRemoveSubview(_ subview: UIView) {
        needsUpdateConstraintsX = true
        marginTops.removeValue(forKey: subview)
    }
}


open class HorizontalStackView: UIView {
    
    required public init(coder:NSCoder? = nil){
        
        if coder == nil{
            super.init(frame: .zero)
        }else{
            super.init(coder: coder!)!
        }
        
        setInsets(.zero)
        
        self.subviewVisibilityChangedFunc = {
            self.needsUpdateConstraintsX = true
            self.setNeedsUpdateConstraints()
        }
    }
    
    override open func addSubview(_ view:UIView){
        needsUpdateConstraintsX = true
        setNeedsUpdateConstraints()
        super.addSubview(view)
    }
    
    open func addSubview(_ view: UIView, margin:CGFloat, _ params:RelativeParams = RelativeParams()) {
        marginLefts[view] = margin
        addSubview(view, params)
    }
    
    open func addSubview(_ view:UIView, weight:CGFloat, _ params: RelativeParams = RelativeParams()) {
        weights[view] = weight
        addSubview(view, params)
    }
    
    open func addSubview(_ view:UIView, margin:CGFloat, weight:CGFloat, _ params: RelativeParams = RelativeParams()) {
        marginLefts[view] = margin
        weights[view] = weight
        addSubview(view, params)
    }
    
    var marginLefts:[UIView:CGFloat] = [:]
    var subviewConstraints:[NSLayoutConstraint] = []
    
    open var marginRight:CGFloat = 0
    
    open func marginLeft(for view:UIView)->CGFloat{
        if let margin = marginLefts[view]{
            return margin
        }
        return 0
    }
    
    open var weighted = false
    var weights:[UIView:CGFloat] = [:]
    
    open func weight(for view:UIView)->CGFloat{
        if let weight = weights[view]{
            return weight
        }
        return 1
    }
    
    open override func updateConstraints() {
        
        super.updateConstraints()
        
        updateConstraintsX()
    }
    
    open var needsUpdateConstraintsX = true
    
    open func updateConstraintsX(){
        
        if !needsUpdateConstraintsX{
            return
        }
        
        print("updating horizontal constraints")
        
        needsUpdateConstraintsX = false
        
        NSLayoutConstraint.deactivate(subviewConstraints)
        
        subviewConstraints.removeAll()
        
        var prevView:UIView = self
        for subview in subviews{
            let constraint = NSLayoutConstraint(item: subview, attribute: .left, relatedBy: .equal, toItem: prevView, attribute: prevView == self ? .leftMargin : .right, multiplier: 1, constant: marginLeft(for:subview))
            subviewConstraints.append(constraint)
            if !subview.isHiddenX{
                prevView = subview
            }
        }
        
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .rightMargin, relatedBy: .equal, toItem: prevView, attribute: prevView == self ? .leftMargin : .right, multiplier: 1, constant: marginRight)
        subviewConstraints.append(rightConstraint)
        
        if weighted{
            for subview in subviews.dropFirst(){
                let constraint = NSLayoutConstraint(item: subview, attribute: .width, relatedBy: .equal, toItem: subviews.first!, attribute: .width, multiplier: weight(for: subview) / weight(for: subviews.first!), constant: 0)
                subviewConstraints.append(constraint)
            }
        }
        
        NSLayoutConstraint.activate(subviewConstraints)
    }
    
    override open func willRemoveSubview(_ subview: UIView) {
        needsUpdateConstraintsX = true
        setNeedsUpdateConstraints()
        marginLefts.removeValue(forKey: subview)
        weights.removeValue(forKey: subview)
    }
}

