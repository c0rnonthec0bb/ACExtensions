//
//  Activity.swift
//  Uplift
//
//  Created by Adam Cobb on 12/31/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import UIKit

open class UIViewControllerX : UIViewController{
    
    internal static weak var context : UIViewControllerX!
    
    @IBOutlet public weak var bottomConstraint:NSLayoutConstraint!
    private var keyboardShown = false
    
    private var constraintsToActivateX:[(isReady:()->Bool, constraint:()->NSLayoutConstraint)] = []
    
    internal var constraintsToActivate:[(isReady:()->Bool, constraint:()->NSLayoutConstraint)]{
        get{
            return constraintsToActivateX
        }
        set(value){
            constraintsToActivateX = value
            view.setNeedsUpdateConstraints()
        }
    }
    
    override open func updateViewConstraints() {
        for i in stride(from: constraintsToActivateX.count - 1, through: 0, by: -1){
            let item = constraintsToActivateX[i];
            if item.isReady(){
                item.constraint().isActive = true
                self.constraintsToActivateX.remove(at: i)
            }
        }
        super.updateViewConstraints()
    }
    
    internal var views = NSHashTable<UIView>(options: [.weakMemory])
    
    override open func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        Async.run(SyncInterface(runTask: {
            self.stuffForEachView(self.view)
            let _ = self.view.fixUserInteraction()
            for item in ViewHelper.onDidLayoutSubviews{
                if item.key.window != nil{
                    for action in item.value{
                        action()
                    }
                }
            }
            self.freeViews()
        }))
    }
    
    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        
        viewDidLayoutSubviews()
    }
    
    internal func stuffForEachView(_ view:UIView){
        if !views.contains(view){
            views.add(view)
        }
        view.layer.bounds = view.bounds
        for subview in view.subviews{
            stuffForEachView(subview)
        }
    }
    
    open func onStart(){
    }
    
    open func onResume() {
    }
    
    open func onPause(){
    }
    
    open func onStop(){
        freeViews()
    }
    
    open func onWindowFocusChanged(_ focused:Bool){
        }
    
    internal func freeViews(){
        let views = self.views.allObjects
        for view in views{
            
            if view.window == nil{
                self.views.remove(view)
                ViewHelper.onDidLayoutSubviews.removeValue(forKey: view)
                objc_removeAssociatedObjects(view)
                if let scroll = view as? UIScrollViewX{
                    scroll.scrollChangedListeners.removeAll()
                }
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewControllerX.context = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    @objc public func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            
            var duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
 
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
            
            var options:UIView.AnimationOptions?
                
            if let curve = curve{
                options = UIView.AnimationOptions.init(rawValue: curve)
            }
            
            if duration == nil{
                duration = 0.3
            }
            
            if options == nil{
                options = UIView.AnimationOptions.curveEaseOut
            }
            
            if keyboardShown{
                duration = 0.1
            }
            
            keyboardAnimating(toHeight: keyboardSize.height, withDuration: duration!, withOptions: options!)
            
            bottomConstraint?.constant = keyboardSize.height/* - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)*/
            
            Async.run(SyncInterface{
                self.scrollToFocus(duration: duration!, animationOptions: options!)
            })
            
            keyboardShown = true
        }
        
    }
    
    @objc open func keyboardDidShow(notification: NSNotification) {
    }
    
    @objc public func keyboardWillHide(notification: NSNotification) {
        var duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
        
        var options:UIView.AnimationOptions?
        
        if let curve = curve{
            options = UIView.AnimationOptions.init(rawValue: curve)
        }
        
        if duration == nil{
            duration = 0.3
        }
        
        if options == nil{
            options = UIView.AnimationOptions.curveEaseIn
        }
        
        keyboardAnimating(toHeight: 0, withDuration: duration!, withOptions: options!)
        
        bottomConstraint?.constant = 0
        
        UIView.animate(withDuration: duration!, delay: 0, options: options!, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        keyboardShown = false
    }
    
    @objc open func keyboardDidHide(notification: NSNotification) {
    }
    
    open func keyboardAnimating(toHeight height:CGFloat, withDuration duration:TimeInterval, withOptions options:UIView.AnimationOptions){
        
    }
    
    
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    open func clearAllFocus(){
        self.view.endEditing(true)
    }
    
    open func scrollToFocus(duration:TimeInterval, animationOptions:UIView.AnimationOptions, specificView:UIView? = nil){
        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
            self.view.layoutIfNeeded()
            
            if let firstResponder = self.view.currentFirstResponder(), specificView == nil || firstResponder == specificView{
                var view:UIView? = firstResponder
                while(view != nil){
                    if let scrollview = view as? UIScrollViewX{
                        scrollview.scrollRectToVisible(firstResponder.convert(firstResponder.bounds, to: scrollview.subviews.first!), animated: false)
                        return;
                    }
                    view = view!.superview
                }
            }
        }, completion: nil)
    }
}
