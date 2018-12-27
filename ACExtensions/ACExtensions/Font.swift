//
//  Font.swift
//  Revree UI Test
//
//  Created by Adam Cobb on 4/12/17.
//  Copyright © 2017 Revree. All rights reserved.
//

import UIKit

public extension UIFont {
    public static func UL(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNext-UltraLight", size: size)!}
    public static func ULC(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNextCondensed-UltraLight", size: size)!}
    public static func L(_ size:CGFloat)->UIFont {return UIFont(name: "Avenir-Light", size: size)!}
    public static func R(_ size:CGFloat)->UIFont {return UIFont(name: "Avenir-Book", size: size)!}
    public static func RI(_ size:CGFloat)->UIFont {return UIFont(name: "Avenir-BookOblique", size: size)!}
    public static func RC(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNextCondensed-Regular", size: size)!}
    public static func M(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNext-DemiBold", size: size)!}
    public static func MI(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNext-DemiBoldItalic", size: size)!}
    public static func MC(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNextCondensed-DemiBold", size: size)!}
    public static func B(_ size:CGFloat)->UIFont {return UIFont(name: "Avenir-Black", size: size)!}
    public static func BC(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNextCondensed-Bold", size: size)!}
    public static func H(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNext-Heavy", size: size)!}
    public static func HC(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNextCondensed-Heavy", size: size)!}
    
    
    public static func monoR(_ size:CGFloat)->UIFont {return UIFont(name: "Courier", size: size)!}
    public static func monoRI(_ size:CGFloat)->UIFont {return UIFont(name: "Courier-Oblique", size: size)!}
    public static func monoB(_ size:CGFloat)->UIFont {return UIFont(name: "Courier-Bold", size: size)!}
    public static func monoBI(_ size:CGFloat)->UIFont {return UIFont(name: "Courier-BoldOblique", size: size)!}
}

