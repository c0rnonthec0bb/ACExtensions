//
//  Toast.swift
//  Uplift
//
//  Created by Adam Cobb on 9/22/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import UIKit

public class Toast{
    public static let LENGTH_LONG:Int64 = 3500
    public static let LENGTH_SHORT:Int64 = 2000
    
    private static var toasting = false
    private static var queue:[()->Void] = []
    
    public static func makeText(_ context:UIViewControllerX, _ message:String, _ length:Int64){
        let toast = UILabelX()
        toast.text = message
        toast.textColor = .white
        toast.backgroundColor = UIColor(hexString: "#e555")
        toast.setInsets(UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24))
        toast.roundCorners(corners: .allCorners, radius: 20)
        toast.font = .R(16)
        LayoutParams.centerParentHorizontal(subview: toast)
        LayoutParams.alignParentBottom(subview: toast, margin: 64)
        toast.alpha = 0
        context.view.addSubview(toast)
        
        NSLayoutConstraint(item: toast, attribute: .width, relatedBy: .lessThanOrEqual, toItem: context.view, attribute: .width, multiplier: 1, constant: -80).isActive = true
        
        let function:()->Void = {
        let _ = toast.animate().alpha(1).setDuration(500).setInterpolator(.linear).setListener(AnimatorListener(onAnimationEnd: {
            let _ = toast.animate().alpha(0).setDuration(500).setStartDelay(length).setListener(AnimatorListener(onAnimationEnd: {
                toast.removeFromSuperview()
            }))
            
            Async.run(length, SyncInterface(runTask: {
                if queue.isEmpty{
                    toasting = false
                }else{
                    queue.removeFirst()()
                }
            }))
        }))
        }
        
        if !toasting{
            toasting = true
            function()
        }else{
            queue.append(function)
        }
    }
}
