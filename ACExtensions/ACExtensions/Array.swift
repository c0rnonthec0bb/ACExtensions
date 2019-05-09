//
//  Array.swift
//  Uplift
//
//  Created by Adam Cobb on 12/23/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import Foundation

public extension Array where Element : AnyObject{
    func index(ofExact: Element)->Int?{
        for i in 0 ..< count{
            if self[i] === ofExact{
                return i;
            }
        }
        return nil;
    }
    
    mutating func remove(exactElement:Element){
        while let index = index(ofExact: exactElement){
            let _ = self.remove(at: index)
        }
    }
}

public extension Array where Element : Equatable{
    func index(of:Element)->Int?{
        for i in 0 ..< count{
            if self[i] == of{
                return i;
            }
        }
        return nil;
    }
    
    mutating func remove(element:Element){
        while let index = index(of: element){
            let _ = self.remove(at: index)
        }
    }
    
    func instances(of:Element)->Int{
        var count = 0
        for item in self{
            if item == of{
                count += 1
            }
        }
        return count
    }
}
