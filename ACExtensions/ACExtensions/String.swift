//
//  String.swift
//  Uplift
//
//  Created by Adam Cobb on 9/5/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import UIKit

extension String:Error{}

public extension String{
    func length()->Int{
        return self.count
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    subscript (bounds: Int) -> String {
        let start = index(startIndex, offsetBy: bounds)
        return String(self[start])
    }
    
    func contains(_ s: String) -> Bool
    {
        return self.range(of: s) != nil
    }
    
    func replace(_ target: String, _ replacement: String) -> String
    {
        return self.replacingOccurrences(of: target, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func toString()->String{
        return self
    }
    
    func toUpperCase()->String{
        return self.uppercased()
    }
    
    func toLowerCase()->String{
        return self.lowercased()
    }
    
    func contentEquals(_ s:String)->Bool{
        return self == s
    }
    
    func substring(_ start:Int)->String{
        return String(self[self.index(self.startIndex, offsetBy: start)...])
    }
    
    func substring(_ start:Int, _ end:Int)->String{
        return String(self[self.index(self.startIndex, offsetBy: start) ..< self.index(self.startIndex, offsetBy: end)])
    }
    
    func charAt(_ index:Int)->String{
        return self.substring(index, index + 1)
    }
    
    func indexOf(_ string: String) -> Int?
    {
        if let range = self.range(of: string) {
            return self.distance(from: self.startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    
    func indexOf(_ string: String, _ start: Int) -> Int?
    {
        if let indexInSub = self.substring(start).indexOf(string){
            return indexInSub + start
        }else{
            return nil
        }
    }
    
    func lastIndexOf(_ string: String) -> Int?
    {
        if let range = self.range(of: string, options: .backwards) {
            return self.distance(from: self.startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
    
    func lastIndexOf(_ string: String, _ start:Int) -> Int?
    {
        return self.substring(0, start).lastIndexOf(string)
    }
    
    func replaceAll(_ regularExpression:String, _ replacement:String)->String{
        return self.replace(regularExpression, replacement)
    }
    
    func startsWith(_ prefix:String)->Bool{
        return self.hasPrefix(prefix)
    }
    
    func endsWith(_ suffix:String)->Bool{
        return self.hasSuffix(suffix)
    }
    
    var isValidEmail:Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            /*"(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
        "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"*/
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}


