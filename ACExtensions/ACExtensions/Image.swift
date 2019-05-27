//
//  Image.swift
//  Uplift
//
//  Created by Adam Cobb on 11/9/16.
//  Copyright © 2016 Adam Cobb. All rights reserved.
//

import UIKit

public extension UIImage{
    func scaled(toSize newSize: CGSize) -> UIImage {
        let newSize = newSize / UIScreen.main.scale
        let newRect = CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.interpolationQuality = .high
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
        context.concatenate(flipVertical)
        context.draw(self.cgImage!, in: newRect)
        let newImage = UIImage(cgImage: context.makeImage()!)
        UIGraphicsEndImageContext()
        return newImage
    }
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
    
    func cropped(toRect rect:CGRect)->UIImage{
        
        var orientedScaledRect = CGRect()
        
        switch self.imageOrientation{
        case .up, .downMirrored:
            orientedScaledRect.origin.x = rect.origin.x
            orientedScaledRect.size.width = rect.width
        case .down, .upMirrored:
            orientedScaledRect.origin.x = self.size.width - rect.origin.x - rect.size.width
            orientedScaledRect.size.width = rect.width
        case .left, .leftMirrored:
            orientedScaledRect.origin.x = rect.origin.y
            orientedScaledRect.size.width = rect.height
        case .right, .rightMirrored:
            orientedScaledRect.origin.x = self.size.height - rect.origin.y - rect.size.height
            orientedScaledRect.size.width = rect.height
        @unknown default:
            fatalError()
        }
        
        switch self.imageOrientation{
        case .up, .upMirrored:
            orientedScaledRect.origin.y = rect.origin.y
            orientedScaledRect.size.height = rect.height
        case .down, .downMirrored:
            orientedScaledRect.origin.y = self.size.height - rect.origin.y - rect.size.height
            orientedScaledRect.size.height = rect.height
        case .left, .rightMirrored:
            orientedScaledRect.origin.y = rect.origin.x
            orientedScaledRect.size.height = rect.width
        case .right, .leftMirrored:
            orientedScaledRect.origin.y = self.size.width - rect.origin.x - rect.size.width
            orientedScaledRect.size.height = rect.width
        @unknown default:
            fatalError()
        }
        
        orientedScaledRect = orientedScaledRect * self.scale
        
        let imageRef = self.cgImage!.cropping(to: orientedScaledRect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    /*
    public func rotated(toOrientation newOrientation: UIImage.Orientation)->UIImage{
        var angleIn:CGFloat!
        switch imageOrientation{
        case .up , .upMirrored:
            angleIn = 0
        case .left, .leftMirrored:
            angleIn = -.pi / 2
        case .down, .downMirrored:
            angleIn = .pi
        case .right, .rightMirrored:
            angleIn = .pi / 2
        }
        
        var angleOut:CGFloat!
        switch newOrientation{
        case .up , .upMirrored:
            angleOut = 0
        case .left, .leftMirrored:
            angleOut = -.pi / 2
        case .down, .downMirrored:
            angleOut = .pi
        case .right, .rightMirrored:
            angleOut = .pi / 2
        }
        
        let netAngle = angleOut - angleIn
        
        let rotatedSize = (netAngle.truncatingRemainder(dividingBy: .pi) == 0) ? size : CGSize(width: size.height, height: size.width)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        let context = UIGraphicsGetCurrentContext()!
        context.interpolationQuality = .high
        context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //context.rotate(by: netAngle)
        //var transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
        //context.concatenate(transform)
        context.draw(self.cgImage!, in: CGRect(origin: CGPoint(x: -size.width / 2, y: -size.height / 2), size: rotatedSize))
        let newImage = UIImage(cgImage: context.makeImage()!, scale: 1, orientation: newOrientation)
        UIGraphicsEndImageContext()
        return newImage
    }*/
    
    func fixedOrientation() -> UIImage? {
        
        guard imageOrientation != UIImage.Orientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        @unknown default:
            fatalError()
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            fatalError()
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}

public extension CGImage{
    func scaled(toSize newSize: CGSize) -> CGImage {
        let newSize = newSize / UIScreen.main.scale
        let newRect = CGRect(x: 0,y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.interpolationQuality = .high
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
        context.concatenate(flipVertical)
        context.draw(self, in: newRect)
        let result = context.makeImage()!
        UIGraphicsEndImageContext()
        return result
    }
}
