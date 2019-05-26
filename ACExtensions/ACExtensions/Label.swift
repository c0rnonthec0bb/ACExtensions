//
//  super.swift
//  Uplift
//
//  Created by Adam Cobb on 11/7/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import UIKit

open class UILabelX:UIView{
    
    public var sizeShouldHugText = false
    
    public let label = UILabel()
    
    public required init(coder:NSCoder? = nil){
        
        if coder == nil{
            super.init(frame: .zero)
        }else{
            super.init(coder: coder!)!
        }
        
        addSubview(label)
        LayoutParams.alignParentLeftRight(subview: label)
        LayoutParams.alignParentTopBottom(subview: label)
        numberOfLines = 0
    }
    
    open var text:String?{
        get{
            return label.text
        }
        
        set(value){
            
            if sizeShouldHugText{
                self.label.updateConstraints()
                self.updateConstraints()
            }
            
            if Async.isAsync(){
                Async.run(SyncInterface(runTask: {
                    self.text = value
                }))
                return
            }
            label.text = value
        }
    }
    
    open var textColor:UIColor!{
        get{
            return label.textColor
        }
        
        set(value){
            if Async.isAsync(){
                Async.run(SyncInterface(runTask: {
                    self.textColor = value
                }))
                return
            }
            label.textColor = value
        }
    }
    
    open var font:UIFont!{
        get{
            return label.font
        }
        
        set(value){
            if Async.isAsync(){
                Async.run(SyncInterface(runTask: {
                    self.font = value
                }))
                return
            }
            label.font = value
        }
    }
    
    open var textAlignment:NSTextAlignment{
        get{
            return label.textAlignment
        }
        
        set(value){
            if Async.isAsync(){
                Async.run(SyncInterface(runTask: {
                    self.textAlignment = value
                }))
                return
            }
            label.textAlignment = value
        }
    }
    
    open var numberOfLines:Int{
        get{
            return label.numberOfLines
        }
        
        set(value){
            if Async.isAsync(){
                Async.run(SyncInterface(runTask: {
                    self.numberOfLines = value
                }))
                return
            }
            label.numberOfLines = value
        }
    }
    
    open var lineBreakMode:NSLineBreakMode{
        get{
            return label.lineBreakMode
        }
        
        set(value){
            if Async.isAsync(){
                Async.run(SyncInterface(runTask: {
                    self.lineBreakMode = value
                }))
                return
            }
            label.lineBreakMode = value
        }
    }
    /*
    open override var intrinsicContentSize: CGSize{
        get{
            //var result = label.intrinsicContentSize
            var result = (text ?? "").boundingRect(with: CGSize(width: .max, height: .max), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [.font: font], context: nil).size// - offset
            
            if result.height <= 0{
                result.height = "A".boundingRect(with: CGSize(width: .max, height: .max), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).height// - offset.height
            }
            
            result.width += getInsets().left + getInsets().right
            result.height += getInsets().top + getInsets().bottom
            
            if UIScreen.main.isIPhoneX{
                //result.height -= 44
            }
            
            return result
        }
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = size
        size.width -= getInsets().left + getInsets().right
        size.height -= getInsets().top + getInsets().bottom
        
        var result = label.sizeThatFits(size)
        
        if result.height <= 0{
            result.height = "A".boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).height
        }
        result.width += getInsets().left + getInsets().right
        result.height += getInsets().top + getInsets().bottom
        print("size that fits for \(text?.prefix(3) ?? "nil"): \(result)")
        return result
    }*/
 
    open func setTextFromHtml(_ text: String){
        
        if Async.isAsync(){
            Async.run(SyncInterface(runTask: {
                self.setTextFromHtml(text)
            }))
            return
        }
        
        do{
            
            var textPlus = "<div style=\"text-align:center; margin: 0 !important; padding: 0 !important; "
            textPlus += "font-family: " + font.familyName + "; "
            textPlus += "font-size: " + font.pointSize.description + "px; "
            textPlus += "color: " + textColor.hexString
            textPlus += "\">" + text + "</div>"
            
            let attributedText = try NSAttributedString(data: textPlus.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [ .documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            label.attributedText = attributedText
        }catch{
            self.text = text
        }
    }
}

open class UIEditLabelX: UITextView, UITextViewDelegate{
    
    private var _underLineColor = UIColor.HALFBLACK
    open var underlineColor:UIColor{
        get{
            return _underLineColor
        }
        set(value){
            _underLineColor = value
            setNeedsDisplay()
        }
    }
    
    private var _underlineHeight:CGFloat = 1
    open var underlineHeight:CGFloat{
        get{
            return _underlineHeight
        }
        set(value){
            _underlineHeight = value
            setNeedsDisplay()
        }
    }
    
    open var numberOfLines:Int{
        get{
            return textContainer.maximumNumberOfLines
        }
        set(value){
            textContainer.maximumNumberOfLines = value
        }
    }
    
    public required init(coder:NSCoder? = nil){
        
        if coder == nil{
            super.init(frame: .zero, textContainer: nil)
        }else{
            super.init(coder: coder!)!
        }
        
        numberOfLines = 0
        backgroundColor = .clear
        textContainer.lineFragmentPadding = 0
        setInsets(UIEdgeInsets(top: 12, left: 4, bottom: 12, right: 4))
        isScrollEnabled = false
        
        ViewHelper.addOnDidLayoutSubviews(view: self){
            self.setNeedsDisplay()
        }
        
        self.delegate = self
    }
    
    @objc open override func setInsets(_ insets: UIEdgeInsets) {
        super.setInsets(insets)
        textContainerInset = insets
    }
    
    open override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()!
        let underline = CGRect(x: rect.origin.x + getInsets().left,y: rect.origin.y + rect.height - getInsets().bottom + 2, width: rect.width - getInsets().left - getInsets().right, height: underlineHeight)
        context.setFillColorSpace(CGColorSpaceCreateDeviceRGB())
        context.setFillColor(underlineColor.cgColor)
        context.fill(underline)
    }
    
    open var onTextChanged:[((String)->Void)] = []
    
    open override var text: String!{
        get{
            return super.text
        }
        set(value){
            
            super.text = value
            
            for function in self.onTextChanged{
                function(value)
            }
            
            UIViewControllerX.context.scrollToFocus(duration: 0.1, animationOptions: .curveEaseOut, specificView: self)
        }
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        text = super.text
    }
    
    open var onFocusChanged:((Bool)->Void)!
    
    open override func becomeFirstResponder()->Bool{
        if let onFocusChanged = self.onFocusChanged{
            onFocusChanged(true)
        }
        underlineHeight = 2
        return super.becomeFirstResponder()
    }
    
    open override func resignFirstResponder()->Bool{
        if let onFocusChanged = self.onFocusChanged{
            onFocusChanged(false)
        }
        underlineHeight = 1
        return super.resignFirstResponder()
    }
}

open class UIEditFieldX: UITextField, UITextFieldDelegate{
    
    private var _underLineColor = UIColor.HALFBLACK
    open var underlineColor:UIColor{
        get{
            return _underLineColor
        }
        set(value){
            _underLineColor = value
            setNeedsDisplay()
        }
    }
    
    private var _underlineHeight:CGFloat = 1
    open var underlineHeight:CGFloat{
        get{
            return _underlineHeight
        }
        set(value){
            _underlineHeight = value
            setNeedsDisplay()
        }
    }
    
    public required init(coder:NSCoder? = nil){
        
        if coder == nil{
            super.init(frame: .zero)
        }else{
            super.init(coder: coder!)!
        }
        
        delegate = self
        
        backgroundColor = .clear
        setInsets(UIEdgeInsets(top: 12, left: 4, bottom: 12, right: 4))
        
        ViewHelper.addOnDidLayoutSubviews(view: self){
            self.setNeedsDisplay()
        }
        
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: getInsets())
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: getInsets())
    }
    /*
    open override var intrinsicContentSize: CGSize{
        get{
            var result = text.boundingRect(with: CGSize(width: .max, height: .max), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font!], context: nil).size
            
            if result.height <= 0{
                result.height = "A".boundingRect(with: CGSize(width: .max, height: .max), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font!], context: nil).height
            }
            
            result.width += getInsets().left + getInsets().right
            result.height += getInsets().top + getInsets().bottom
            
            if UIScreen.main.isIPhoneX{
                //result.height -= 44
            }
            
            return result
        }
    }*/
    
    open override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()!
        let underline = CGRect(x: rect.origin.x + getInsets().left,y: rect.origin.y + rect.height - getInsets().bottom - underlineHeight, width: rect.width - getInsets().left - getInsets().right, height: underlineHeight)
        context.setFillColorSpace(CGColorSpaceCreateDeviceRGB())
        context.setFillColor(underlineColor.cgColor)
        context.fill(underline)
    }
    
    open var onTextChanged:[((String)->Void)] = []
    
    open override var text: String!{
        get{
            return super.text
        }
        set(value){
            
            super.text = value
            
            for function in self.onTextChanged{
                function(value)
            }
            
            UIViewControllerX.context.scrollToFocus(duration: 0.1, animationOptions: .curveEaseOut, specificView: self)
        }
    }
    
    @objc open func textFieldDidChange(_ textField: UITextField) {
        text = super.text
    }
    
    open var onFocusChanged:((Bool)->Void)!
    
    open override func becomeFirstResponder()->Bool{
        if let onFocusChanged = self.onFocusChanged{
            onFocusChanged(true)
        }
        underlineHeight = 2
        return super.becomeFirstResponder()
    }
    
    open override func resignFirstResponder()->Bool{
        if let onFocusChanged = self.onFocusChanged{
            onFocusChanged(false)
        }
        underlineHeight = 1
        return super.resignFirstResponder()
    }
    
    open var onReturn = {}
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturn()
        return true
    }
}

