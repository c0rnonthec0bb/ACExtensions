//
//  Operators.swift
//  Uplift
//
//  Created by Adam Cobb on 1/2/17.
//  Copyright © 2017 Adam Cobb. All rights reserved.
//

import UIKit

//Number

public func sign<T:SignedNumeric & Comparable>(_ num:T)->T{
    return num == 0 ? 0 : num > 0 ? 1 : -1
}


//Int

infix operator %%
public func %% (left: Int, right:Int)-> Int{
    var posLeft = left
    while posLeft < 0{
        posLeft += right
    }
    return posLeft % right
}

//CGFloat

public func %% (left: CGFloat, right:CGFloat)-> CGFloat{
    var posLeft = left
    while posLeft < 0{
        posLeft += right
    }
    return posLeft.truncatingRemainder(dividingBy: right)
}

//CGPoint

public extension CGPoint{
    init(_ cgSize: CGSize){
        self.init(x: cgSize.width, y: cgSize.height)
    }
    
    ///hypotenuse
    var length:CGFloat{
        get{
            return hypot(self)
        }
    }
    
    ///radians
    var angle:CGFloat{
        get{
            return atan2(y, x)
        }
    }
    
    ///raw
    var raw:(x:Float, y:Float){
        get{
            return (x: Float(x), y: Float(y))
        }
    }
}

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

public func max(_ left: CGPoint, _ right: CGPoint) -> CGPoint {
    return CGPoint(x: max(left.x, right.x), y: max(left.y, right.y))
}

public func min(_ left: CGPoint, _ right: CGPoint) -> CGPoint {
    return CGPoint(x: min(left.x, right.x), y: min(left.y, right.y))
}

public func / (left: CGPoint, right: CGFloat)->CGPoint{
    return CGPoint(x: left.x / right, y: left.y / right)
}

public func * (left: CGPoint, right: CGFloat)->CGPoint{
    return CGPoint(x: left.x * right, y: left.y * right)
}

public func * (left: CGPoint, right: CGSize)->CGPoint{
    return CGPoint(x: left.x * right.width, y: left.y * right.height)
}

public func hypot(_ point: CGPoint)->CGFloat{
    return hypot(point.x, point.y)
}

public prefix func -(right:CGPoint)->CGPoint{
    return .zero - right
}

//CGSize

public extension CGSize{
    init(_ cgPoint: CGPoint){
        self.init(width: cgPoint.x, height: cgPoint.y)
    }
    
    ///hypotenuse
    var length:CGFloat{
        get{
            return hypot(width, height)
        }
    }
    
    var widthToHeight:CGFloat{
        get{
            return width / height
        }
    }
    
    ///raw
    var raw:(x:Float, y:Float){
        get{
            return (x: Float(width), y: Float(height))
        }
    }
}

public func + (left: CGSize, right: CGSize)->CGSize{
    return CGSize(width: left.width + right.width, height: left.height + right.height)
}

public func - (left: CGSize, right: CGSize)->CGSize{
    return CGSize(width: left.width - right.width, height: left.height - right.height)
}

public func * (left: CGSize, right: CGFloat)->CGSize{
    return CGSize(width: left.width * right, height: left.height * right)
}

public func / (left: CGSize, right: CGFloat)->CGSize{
    return CGSize(width: left.width / right, height: left.height / right)
}

public func * (left: CGSize, right: CGSize)->CGSize{
    return CGSize(width: left.width * right.width, height: left.height * right.height)
}

public func / (left: CGSize, right: CGSize)->CGSize{
    return CGSize(width: left.width / right.width, height: left.height / right.height)
}

//CGRect

public func * (left: CGRect, right: CGFloat)->CGRect{
    return CGRect(origin: left.origin * right, size: left.size * right)
}

public func * (left: CGRect, right: CGSize)->CGRect{
    return CGRect(origin: left.origin * right, size: left.size * right)
}

//UInt

public extension UInt{
    static func raw(_ w:(UInt, UInt))->(Float, Float){
        return (Float(w.0), Float(w.1))
    }
}

//UIEdgeInsets

public func - (left: UIEdgeInsets, right: UIEdgeInsets)->UIEdgeInsets{
    return UIEdgeInsets(top: left.top - right.top, left: left.left - right.left, bottom: left.bottom - right.bottom, right: left.right - right.right)
}

public prefix func -(right:UIEdgeInsets)->UIEdgeInsets{
    return .zero - right
}
