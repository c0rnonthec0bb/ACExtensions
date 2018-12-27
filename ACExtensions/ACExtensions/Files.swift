//
//  Files.swift
//  Revree iOS
//
//  Created by Adam Cobb on 9/6/16.
//  Copyright © 2017 Revree. All rights reserved.
//

import UIKit

public class Files {
    
    public static func documentsPath(name: String)->URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
        var path = paths.first!
        let nameComponents = name.split(separator: "/")
        for component in nameComponents{
            print("appending \(component)")
            path = path.appendingPathComponent(String(component))
        }
        return path
    }
    
    public static func deleteFile(_ name:String){
        UserDefaults.standard.removeObject(forKey: name)
    }
    
    public static func writeObject<T:Any>(_ name:String, _ value:T){
        UserDefaults.standard.set(value, forKey: name)
        UserDefaults.standard.synchronize()
    }
    
    public static func readObject<T:Any>(_ name:String)->T?{
        return UserDefaults.standard.object(forKey: name) as? T
    }
    
    public static func writeString(_ name:String, _ value:String){
        writeObject(name, value)
    }
    
    public static func readString(_ name:String)->String?{
        return readObject(name)
    }
    
    public static func writeStringList(_ name:String, _ value:[String]){
        writeObject(name, value)
    }
    
    public static func readStringList(_ name:String)->[String]?{
        return readObject(name)
    }
    
    public static func writeUrl(_ name:String, _ value:URL){
        UserDefaults.standard.set(value, forKey: name)
        UserDefaults.standard.synchronize()
    }
    
    public static func readUrl(_ name:String)->URL?{
        return UserDefaults.standard.url(forKey: name)
    }
    
    public static func writeBoolean(_ name:String, _ value:Bool){
        writeObject(name, value)
    }
    
    public static func readBoolean(_ name:String)->Bool?{
        return readObject(name)
    }
    
    public static func writeInteger(_ name:String, _ value:Int){
        writeObject(name, value)
    }
    
    public static func readInteger(_ name:String)->Int?{
        return readObject(name)
    }
    
    public static func writeDouble(_ name:String, _ value:Double){
        writeObject(name, value)
    }
    
    public static func readDouble(_ name:String)->Double?{
        return readObject(name)
    }
    
    public static func writeFloat(_ name:String, _ value:Float){
        writeObject(name, value)
    }
    
    public static func readFloat(_ name:String)->Float?{
        return readObject(name)
    }
    
    public static func writeImageAsJpeg(_ name:String, _ value:UIImage){
        do{
            if let imageData = value.jpegData(compressionQuality: 1){
                let path = self.documentsPath(name: name + ".jpg")
                try imageData.write(to: path)
            }else{
            }
        }catch{}
    }
    
    public static func readImageAsJpeg(_ name:String)->UIImage?{
        do{
            let path = self.documentsPath(name: name + ".jpg")
            let imageData = try Data(contentsOf: path)
            if let result = UIImage(data: imageData){
                return result
            }
        }catch{}
        return nil
    }
    
    public static func writeJson(_ name:String, _ value:[String:Any]){
        writeObject(name, value)
    }
    
    public static func readJson(_ name:String)->[String:Any]?{
        return readObject(name)
    }
    
    public static func writeAffirmatoryJson(_ name:String, _ value:[String:Bool]){
        writeObject(name, value)
    }
    
    public static func readAffirmatoryJson(_ name:String)->[String:Bool]?{
        return readObject(name)
    }
    
    public static func writeData(_ name:String, _ value:Data){
        writeObject(name, value)
    }
    
    public static func readData(_ name:String)->Data?{
        return readObject(name)
    }
    
    public static func makeUserDefaultsCompatible(on:Any, transform:(Any)->Any)->Any{
        let on = transform(on)
        if on is UserDefaultsCompatible{
            return on
        }
        if let array = (on as? Array<Any>){
            return array.map({ item in return makeUserDefaultsCompatible(on: item, transform: transform)})
        }
        if var dict = on as? Dictionary<String, Any>{
            print("found dict \(dict)")
            for key in dict.keys{
                dict[key] = makeUserDefaultsCompatible(on: dict[key]!, transform: transform)
            }
            return dict
        }
        print("returning nil for \(String(describing: on))")
        return 0
    }
}

public protocol UserDefaultsCompatible{}

extension NSData:UserDefaultsCompatible{}
extension NSNumber:UserDefaultsCompatible{}
extension NSString:UserDefaultsCompatible{}
extension NSURL:UserDefaultsCompatible{}
extension NSDate:UserDefaultsCompatible{}

extension Data:UserDefaultsCompatible{}
extension Int:UserDefaultsCompatible{}
extension Int32:UserDefaultsCompatible{}
extension Int64:UserDefaultsCompatible{}
extension Float:UserDefaultsCompatible{}
extension Double:UserDefaultsCompatible{}
extension Bool:UserDefaultsCompatible{}
extension URL:UserDefaultsCompatible{}
extension String:UserDefaultsCompatible{}
extension Date:UserDefaultsCompatible{}

public func areEqual(_ lhs:UserDefaultsCompatible, _ rhs:UserDefaultsCompatible)->Bool{
    if let lhs = lhs as? Int, let rhs = rhs as? Int{
        return lhs == rhs
    }
    if let lhs = lhs as? Int32, let rhs = rhs as? Int32{
        return lhs == rhs
    }
    if let lhs = lhs as? Int64, let rhs = rhs as? Int64{
        return lhs == rhs
    }
    if let lhs = lhs as? Float, let rhs = rhs as? Float{
        return lhs == rhs
    }
    if let lhs = lhs as? Double, let rhs = rhs as? Double{
        return lhs == rhs
    }
    if let lhs = lhs as? Bool, let rhs = rhs as? Bool{
        return lhs == rhs
    }
    if let lhs = lhs as? URL, let rhs = rhs as? URL{
        return lhs == rhs
    }
    if let lhs = lhs as? String, let rhs = rhs as? String{
        return lhs == rhs
    }
    if let lhs = lhs as? Date, let rhs = rhs as? Date{
        return lhs == rhs
    }
    if let lhs = lhs as? Data, let rhs = rhs as? Data{
        return lhs == rhs
    }
    
    return false
}



