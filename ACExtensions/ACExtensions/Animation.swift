//
//  ViewAnimations.swift
//  Uplift
//
//  Created by Adam Cobb on 9/25/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import UIKit

public extension UIView{
    func animate()->UIViewAnimationHelper{
        return UIViewAnimationHelper(view: self)
    }
}

public class UIViewAnimationHelper{
    var view:UIView!
    var animations:[()->Void] = []
    var keyframeAnimations:[()->Void] = []
    var delay:TimeInterval = 0
    var duration:TimeInterval = 1
    var interpolator = Interpolator.linear
    var listener:AnimatorListener? = nil
    
    public init(view:UIView) {
        self.view = view
        
        Async.run(SyncInterface(runTask: {
            
            let completionInKeyframeBlock = self.animations.isEmpty
            
            if let timingFunction = self.interpolator.definingFactior as? UIView.AnimationOptions{
                
                UIView.animate(withDuration: self.duration, delay: self.delay, options: [.beginFromCurrentState, .allowUserInteraction, timingFunction], animations: {
                    for animation in self.animations{
                        animation()
                    }
                    self.animations = []
                }, completion: {finished in
                    if finished && !completionInKeyframeBlock, let listener = self.listener{
                            listener.onAnimationEnd()
                    }
                })
                
            }else if let springDamping = self.interpolator.definingFactior as? CGFloat{
                UIView.animate(withDuration: self.duration, delay: self.delay, usingSpringWithDamping: springDamping, initialSpringVelocity: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                    for animation in self.animations{
                        animation()
                    }
                    self.animations = []
                }, completion: {finished in
                    if finished{
                        if let listener = self.listener{
                            listener.onAnimationEnd()
                        }
                    }
                })
            }
            
            UIView.animateKeyframes(withDuration: self.duration, delay: self.delay, options: [.beginFromCurrentState, .allowUserInteraction, .calculationModeLinear], animations: {
                for animation in self.keyframeAnimations{
                    animation()
                }
                self.keyframeAnimations = []
            }, completion: {finished in
                if finished && completionInKeyframeBlock{
                    if let listener = self.listener{
                        listener.onAnimationEnd()
                    }
                }
            })
        }))
    }
    
    public func cancel(){
        self.view.layer.removeAllAnimations()
        Async.run(SyncInterface(runTask: {
            self.view.layer.removeAllAnimations()
        }))
    }
    
    public func setStartDelay(seconds:TimeInterval)->UIViewAnimationHelper{
        self.delay = seconds
        return self
    }
    
    public func setStartDelay(_ delay:Milliseconds)->UIViewAnimationHelper{
        return self.setStartDelay(seconds: TimeInterval(delay) / 1000)
    }
    
    public func setDuration(seconds:TimeInterval)->UIViewAnimationHelper{
        self.duration = seconds
        return self
    }
    
    public func setDuration(_ duration:Milliseconds)->UIViewAnimationHelper{
        return self.setDuration(seconds: TimeInterval(delay) / 1000)
    }
    
    public func setInterpolator(_ interpolator:Interpolator)->UIViewAnimationHelper{
        self.interpolator = interpolator
        return self
    }
    
    public func setListener(_ listener:AnimatorListener?)->UIViewAnimationHelper{
        self.listener = listener
        return self
    }
    
    public func translationX(_ value:CGFloat)->UIViewAnimationHelper{
        animations.append({self.view.translationX = value})
        return self
    }
    
    public func translationY(_ value:CGFloat)->UIViewAnimationHelper{
        animations.append({self.view.translationY = value})
        return self
    }
    
    public func translationXBy(_ value:CGFloat)->UIViewAnimationHelper{
        animations.append({self.view.translationX += value})
        return self
    }
    
    public func translationYBy(_ value:CGFloat)->UIViewAnimationHelper{
        animations.append({self.view.translationY += value})
        return self
    }
    
    public func scaleX(_ value:CGFloat)->UIViewAnimationHelper{
        animations.append({
            self.view.scaleX = value
        })
        return self
    }
    
    public func scaleY(_ value:CGFloat)->UIViewAnimationHelper{
        animations.append({
            self.view.scaleY = value
        })
        return self
    }
    
    public func scaleXBy(_ value:CGFloat)->UIViewAnimationHelper{
        return scaleX(view.scaleX * value)
    }
    
    public func scaleYBy(_ value:CGFloat)->UIViewAnimationHelper{
        return scaleY(view.scaleY * value)
    }
    
    public func rotation(_ value:CGFloat)->UIViewAnimationHelper{
        let valueToGo = value - view.rotation
        if abs(valueToGo) < 180{
            animations.append({
                self.view.rotation = value
            })
        }else{
            keyframeAnimations.append({
                let iterations = ceil(abs(valueToGo) / 170) //170 is a number slightly less than 180
                for i in stride(from: 1, through: iterations, by: 1){
                    UIView.addKeyframe(withRelativeStartTime: Double((i - 1) / iterations), relativeDuration: 1 / Double(iterations), animations: {
                        self.view.rotation = value + (i / iterations - 1) * valueToGo
                    })
                }
            })
        }
        return self
    }
    
    public func rotationBy(_ value:CGFloat)->UIViewAnimationHelper{
        return rotation(view.rotation + value)
    }
    
    public func alpha(_ value:CGFloat)->UIViewAnimationHelper{
        animations.append({
            self.view.alpha = value
        })
        return self
    }
    
    public func alphaBy(_ value:CGFloat)->UIViewAnimationHelper{
        return alpha(view.alpha + value)
    }
}

public class Interpolator{
    var type:Int!
    var definingFactior:Any!
    
    public init(timingFunction:UIView.AnimationOptions){
        self.type = 1
        self.definingFactior = timingFunction
    }
    public init(springDamping:CGFloat){
        self.type = 2
        self.definingFactior = springDamping
    }
    public static let linear = Interpolator(timingFunction: .curveLinear)
    public static let accelerate = Interpolator(timingFunction: .curveEaseIn)
    public static let decelerate = Interpolator(timingFunction: .curveEaseOut)
    public static let accelerateDecelerate = Interpolator(timingFunction: .curveEaseInOut)
    public static let overshoot = Interpolator(springDamping:0.6)
    public static let anticipate = Interpolator(springDamping:-0.6)
    public static let bounce = decelerate
}

public class AnimatorListener{
    var onAnimationEnd:()->Void
 
    public init(onAnimationEnd:@escaping ()->Void){
        self.onAnimationEnd = onAnimationEnd
    }
}
