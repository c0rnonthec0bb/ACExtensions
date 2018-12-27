//
//  Color.swift
//  Uplift
//
//  Created by Adam Cobb on 9/6/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import UIKit

public extension UIColor{
    
    @nonobjc public static let WHITE = UIColor(hexString: "#FFF")!
    @nonobjc public static let BLACK = UIColor(hexString: "#000")!
    @nonobjc public static let HALFBLACK = UIColor(hexString: "#7f7f7f")!
    
    public convenience init?(alpha: Int, red: Int, green: Int, blue: Int) {
        if min(alpha, red, green, blue) < 0 || max(alpha, red, green, blue) > 255{
            return nil
        }
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }
    
    static fileprivate func charToInt(_ char:String)->Int{
        if let digit = Int(char){
            return digit
        }else{
            return Int(char.unicodeScalars.first!.value) - Int("a".unicodeScalars.first!.value) + 10
        }
    }
    
    /// RGB, ARGB, RRGGBB, or AARRGGBB
    public convenience init?(hexString: String){
        var hexString = hexString
        
        var alpha:Int = 0, red:Int = 0, green:Int = 0, blue:Int = 0;
        if hexString.charAt(0) == "#"{
            hexString = hexString.substring(1)
        }
        hexString = hexString.toLowerCase()
        switch(hexString.length()){
        case 3:
            alpha = 255;
            red = UIColor.charToInt(hexString.charAt(0)) * 17
            green = UIColor.charToInt(hexString.charAt(1)) * 17
            blue = UIColor.charToInt(hexString.charAt(2)) * 17
        case 4:
            alpha = UIColor.charToInt(hexString.charAt(0)) * 17
            red = UIColor.charToInt(hexString.charAt(1)) * 17
            green = UIColor.charToInt(hexString.charAt(2)) * 17
            blue = UIColor.charToInt(hexString.charAt(3)) * 17
            break;
        case 6:
            alpha = 255;
            red = UIColor.charToInt(hexString.charAt(0)) * 16 + UIColor.charToInt(hexString.charAt(1))
            green = UIColor.charToInt(hexString.charAt(2)) * 16 + UIColor.charToInt(hexString.charAt(3))
            blue = UIColor.charToInt(hexString.charAt(4)) * 16 + UIColor.charToInt(hexString.charAt(5))
            break;
        case 8:
            alpha = UIColor.charToInt(hexString.charAt(0)) * 16 + UIColor.charToInt(hexString.charAt(1))
            red = UIColor.charToInt(hexString.charAt(2)) * 16 + UIColor.charToInt(hexString.charAt(3))
            green = UIColor.charToInt(hexString.charAt(4)) * 16 + UIColor.charToInt(hexString.charAt(5))
            blue = UIColor.charToInt(hexString.charAt(6)) * 16 + UIColor.charToInt(hexString.charAt(7))
            break;
        default:
            return nil
        }
        
        self.init(alpha: alpha, red: red, green: green, blue: blue)
    }
    
    public convenience init?(cssHexString:String){
        
        var cssHexString = cssHexString
        
        if cssHexString.count == 8{
            cssHexString = cssHexString.substring(6) + cssHexString.substring(0, 6)
        }
        if cssHexString.count == 4{
            cssHexString = cssHexString.substring(3) + cssHexString.substring(0, 3)
        }
        self.init(hexString: cssHexString)
    }
    
    convenience init?(x8 netHex:Int) {
        
        self.init(alpha: (netHex >> 24) & 0xff, red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init?(x6 netHex:Int) {
        
        self.init(alpha: 0xff, red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init?(x4 netHex:Int) {
        
        self.init(alpha: ((netHex >> 12) & 0xf) * 0x11, red:((netHex >> 8) & 0xf) * 0x11, green:((netHex >> 4) & 0xf) * 0x11, blue: (netHex & 0xf) * 0x11)
    }
    
    convenience init?(x3 netHex:Int) {
        
        self.init(alpha: 0xff, red:((netHex >> 8) & 0xf) * 0x11, green:((netHex >> 4) & 0xf) * 0x11, blue: (netHex & 0xf) * 0x11)
    }
    
    public var hexString: String {
        get{
            var r:CGFloat = 0
            var g:CGFloat = 0
            var b:CGFloat = 0
            var a:CGFloat = 0
            
            getRed(&r, green: &g, blue: &b, alpha: &a)
            
            let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
            
            return String(format:"#%06x", rgb)
        }
    }
}
