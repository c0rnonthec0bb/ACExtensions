//
//  Transform.swift
//  Uplift
//
//  Created by Adam Cobb on 12/26/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import UIKit

public extension CGAffineTransform{
    public var scaleX:CGFloat{
        get{
            return sqrt(a*a+c*c)
        }
        set(value){
            let r = rotation
            let cosr = cos(r)
            let sinr = sin(r)
            a = value * cosr
            c = value * -sinr
        }
    }
    
    public var scaleY:CGFloat{
        get{
            return sqrt(b*b+d*d)
        }
        set(value){
            let r = rotation
            let cosr = cos(r)
            let sinr = sin(r)
            b = value * sinr
            d = value * cosr
        }
    }
    
    public var uniformScale:CGFloat{
        get{
            return (scaleX + scaleY) / 2
        }
        
        set(value){
            let r = rotation
            let cosr = cos(r)
            let sinr = sin(r)
            a = value * cosr
            c = value * -sinr
            b = value * sinr
            d = value * cosr
        }
    }
    
    public var scale:CGSize{
        get{
            return CGSize(width: scaleX, height: scaleY)
        }
        
        set(value){
            scaleX = value.width
            scaleY = value.height
        }
    }
    
    public var rotation:CGFloat{
        get{
            return atan2(b, a)
        }
        
        set(value){
            let cosr = cos(value)
            let sinr = sin(value)
            let sx = scaleX
            let sy = scaleY
            a = sx * cosr
            c = sx * -sinr
            b = sy * sinr
            d = sy * cosr
        }
    }
    
    public var translation:CGPoint{
        get{
            return CGPoint(x: tx, y: ty)
        }
        
        set(value){
            tx = value.x
            ty = value.y
        }
    }
    
    public func translatedBy(_ concatenatedTranslation: CGPoint)->CGAffineTransform{
        return translatedBy(x: concatenatedTranslation.x, y: concatenatedTranslation.y)
    }
}

public extension UIView{
    
    public var scaleX:CGFloat{
        get{
            return transform.scaleX
        }
        set(value){
            transform.scaleX = value
        }
    }
    
    public var scaleY:CGFloat{
        get{
            return transform.scaleY
        }
        set(value){
            transform.scaleY = value
        }
    }
    
    ///this is in degrees!
    public var rotation:CGFloat{
        get{
            return transform.rotation * 180 / CGFloat.pi
        }
        
        set(value){
            transform.rotation = value * CGFloat.pi / 180
        }
    }
    
    public var translationX:CGFloat{
        get{
            return transform.tx
        }
        set(value){
            transform.tx = value
        }
    }
    
    public var translationY:CGFloat{
        get{
            return transform.ty
        }
        set(value){
            transform.ty = value
        }
    }
    
    public var translation:CGPoint{
        get{
            return CGPoint(x: translationX, y: translationY)
        }
        
        set(value){
            translationX = value.x
            translationY = value.y
        }
    }
    
    public var width:CGFloat{
        get{
            let t = transform
            transform = .identity
            let value = frame.size.width
            transform = t
            return value
        }
        set(value){
            let t = transform
            transform = .identity
            frame.size.width = value
            transform = t
        }
    }
    
    public var height:CGFloat{
        get{
            let t = transform
            transform = .identity
            let value = frame.size.height
            transform = t
            return value
        }
        set(value){
            let t = transform
            transform = .identity
            frame.size.height = value
            transform = t
        }
    }
    
    public var x:CGFloat{
        get{
            let t = transform
            transform = .identity
            let value = frame.origin.x
            transform = t
            return value
        }
        set(value){
            let t = transform
            transform = .identity
            frame.origin.x = value
            transform = t
        }
    }
    
    public var y:CGFloat{
        get{
            let t = transform
            transform = .identity
            let value = frame.origin.y
            transform = t
            return value
        }
        set(value){
            let t = transform
            transform = .identity
            frame.origin.y = value
            transform = t
        }
    }
    
    public var originalOrigin:CGPoint{
        get{
            return CGPoint(x: x, y: y)
        }
        
        set(value){
            x = value.x
            y = value.y
        }
    }
    
    public var originalSize:CGSize{
        get{
            return CGSize(width: width, height: height)
        }
        
        set(value){
            width = value.width
            height = value.height
        }
    }
    
    public var originalFrame:CGRect{
        get{
            return CGRect(origin: originalOrigin, size: originalSize)
        }
        
        set(value){
            originalOrigin = value.origin
            originalSize = value.size
        }
    }
    
    public var left:CGFloat{
        get{
            return measuredOrigin.x
        }
    }
    
    public var top:CGFloat{
        get{
            return measuredOrigin.y
        }
    }
    
    public var right:CGFloat{
        get{
            return left + measuredSize.width
        }
    }
    
    public var bottom:CGFloat{
        get{
            return top + measuredSize.height
        }
    }
}
