//
//  Font.swift
//  Revree UI Test
//
//  Created by Adam Cobb on 4/12/17.
//  Copyright © 2017 Revree. All rights reserved.
//

import UIKit

public extension UIFont {
    static func UL(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNext-UltraLight", size: size)!}
    static func ULC(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNextCondensed-UltraLight", size: size)!}
    static func L(_ size:CGFloat)->UIFont {return UIFont(name: "Avenir-Light", size: size)!}
    static func R(_ size:CGFloat)->UIFont {return UIFont(name: "Avenir-Book", size: size)!}
    static func RI(_ size:CGFloat)->UIFont {return UIFont(name: "Avenir-BookOblique", size: size)!}
    static func RC(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNextCondensed-Regular", size: size)!}
    static func M(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNext-DemiBold", size: size)!}
    static func MI(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNext-DemiBoldItalic", size: size)!}
    static func MC(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNextCondensed-DemiBold", size: size)!}
    static func B(_ size:CGFloat)->UIFont {return UIFont(name: "Avenir-Black", size: size)!}
    static func BC(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNextCondensed-Bold", size: size)!}
    static func H(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNext-Heavy", size: size)!}
    static func HC(_ size:CGFloat)->UIFont {return UIFont(name: "AvenirNextCondensed-Heavy", size: size)!}
    
    
    static func monoR(_ size:CGFloat)->UIFont {return UIFont(name: "Courier", size: size)!}
    static func monoRI(_ size:CGFloat)->UIFont {return UIFont(name: "Courier-Oblique", size: size)!}
    static func monoB(_ size:CGFloat)->UIFont {return UIFont(name: "Courier-Bold", size: size)!}
    static func monoBI(_ size:CGFloat)->UIFont {return UIFont(name: "Courier-BoldOblique", size: size)!}
}

