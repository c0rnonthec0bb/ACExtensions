//
//  Async.swift
//  Uplift
//
//  Created by Adam Cobb on 9/3/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import Foundation
public class Async{
    
    public static var PRIORITY_WAITING = 1
    
    public static var PRIORITY_INTERNETBIG = 3
    
    public static var PRIORITY_INTERNETSMALL = 4
    
    public static var PRIORITY_IMPORTANT = 6
    
    private static func createQueue(_ priority:Int)->DispatchQueue{
        return DispatchQueue(label: "queue" + String(priority), qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: priority))
    }
    
    public static func run(_ syncInterface:SyncInterface){
            DispatchQueue.main.async {
                if !Thread.isMainThread{
                    
                }
                syncInterface.runTask()
            }
    }
    
    public static func run(_ delay:Milliseconds, _ syncInterface:SyncInterface){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(delay * Milliseconds(NSEC_PER_MSEC)) / Double(NSEC_PER_SEC)){
            run(syncInterface)
        }
    }
    
    public static func run(_ priority:Int, _ asyncInterface:AsyncInterface){
        run(priority, AsyncSyncInterface(runTask: asyncInterface.runTask, afterTask: {}))
    }
    
    public static func run(_ priority:Int, _ asyncSyncInterface:AsyncSyncInterface){
        run(priority, AsyncSyncSuccessInterface(runTask: {try asyncSyncInterface.runTask(); return true}, afterTask: {
        (success:Bool, message:String) in
            asyncSyncInterface.afterTask()
        }))
    }
    
    public static func run(_ priority:Int, _ asyncSyncSuccessInterface:AsyncSyncSuccessInterface){
        
        createQueue(priority).async{
            
            var result:Bool = false
            var message:String = ""
            
            do{
                try result = asyncSyncSuccessInterface.runTask()
            }catch let e{
                message = e.localizedDescription
            }
            
            DispatchQueue.main.async {
                if !Thread.isMainThread{
                    
                }
                asyncSyncSuccessInterface.afterTask(result, message)
            }
        }
    }
    
    public static func run(_ delay:Milliseconds,_ priority:Int,  _ asyncInterface:AsyncInterface){
        run(delay, SyncInterface(runTask: {run(priority, asyncInterface)}))
    }
    
    public static func run(_ delay:Milliseconds,_ priority:Int,  _ asyncSyncInterface:AsyncSyncInterface){
        run(delay, SyncInterface(runTask: {run(priority, asyncSyncInterface)}))
    }
    
    public static func run(_ delay:Milliseconds,_ priority:Int,  _ asyncSyncSuccessInterface:AsyncSyncSuccessInterface){
        run(delay, SyncInterface(runTask: {run(priority, asyncSyncSuccessInterface)}))
    }
    
    public static func toast(_ message:String, _ length_long:Bool){
        if isAsync(){
            run(SyncInterface(runTask: {
                Toast.makeText(UIViewControllerX.context, message, (length_long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT))
            }))
        }else{
            Toast.makeText(UIViewControllerX.context, message, (length_long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT))
        }
    }
    
    public static func isAsync()->Bool{
        return !Thread.isMainThread
    }
}

public class SyncInterface {
    public init(runTask:@escaping () -> Void){
        self.runTask = runTask
    }
    final var runTask:() -> Void
}

public class AsyncInterface {
    public init(runTask:@escaping () throws -> Void){
        self.runTask = runTask
    }
    final var runTask:() throws -> Void
}

public class AsyncSyncInterface{
    public init(runTask:@escaping () throws -> Void, afterTask:@escaping () -> Void){
        self.runTask = runTask
        self.afterTask = afterTask
    }
    final var runTask:() throws -> Void
    final var afterTask:() -> Void
}

public class AsyncSyncSuccessInterface{
    public init(runTask : @escaping () throws -> Bool, afterTask : @escaping (_ success:Bool, _ message:String)-> Void){
        self.runTask = runTask
        self.afterTask = afterTask
    }
    final var runTask : () throws -> Bool
    final var afterTask : (_ success:Bool, _ message:String) -> Void
}
