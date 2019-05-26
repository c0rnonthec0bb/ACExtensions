//
//  Number.swift
//  Uplift
//
//  Created by Adam Cobb on 11/2/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import UIKit

public extension Int{
    func sign()->Int{
        return self == 0 ? 0 : self > 0 ? 1 : -1
    }
}

public extension CGFloat{
    func sign()->CGFloat{
        return self == 0 ? 0 : self > 0 ? 1 : -1
    }
}

public extension CGFloat{
    init?(fromJunk junk:Any?){
        
        if let float = junk as? CGFloat{
            self.init(float)
            return
        }
        
        if let float = junk as? Float{
            self.init(float)
            return
        }
        
        if let int = junk as? Int{
            self.init(int)
            return
        }
        
        if let long = junk as? Int64{
            self.init(long)
            return
        }
        
        if let double = junk as? Double{
            self.init(double)
            return
        }
        
        if let string = junk as? String, let stringFloat = Float(string){
            self.init(stringFloat)
            return
        }
        
        return nil
    }
}

public extension Float{
    init?(fromJunk junk:Any?){
        
        if let float = junk as? CGFloat{
            self.init(float)
            return
        }
        
        if let float = junk as? Float{
            self.init(float)
            return
        }
        
        if let int = junk as? Int{
            self.init(int)
            return
        }
        
        if let long = junk as? Int64{
            self.init(long)
            return
        }
        
        if let double = junk as? Double{
            self.init(double)
            return
        }
        
        if let string = junk as? String, let stringFloat = Float(string){
            self.init(stringFloat)
            return
        }
        
        return nil
    }
}
