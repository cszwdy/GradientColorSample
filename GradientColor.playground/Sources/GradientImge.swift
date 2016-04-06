import Foundation
import UIKit

private extension CGFloat {
    func toColorUInt8() -> UInt8 {
        return UInt8(255.0 * self)
    }
}

public struct PixelColor {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
    
    func toInt32() -> UInt32 {
        
        // Unix reverse store binary
        return UInt32(alpha.toColorUInt8()) << (24 - 24) | UInt32(red.toColorUInt8()) << (24 - 16) | UInt32(green.toColorUInt8()) << (24 - 8) | UInt32(blue.toColorUInt8()) << (24 - 0)
    }
    
    func averageWith(color: PixelColor, w: CGFloat) -> PixelColor {
        
        let average = {(a: CGFloat, b: CGFloat, w: CGFloat) -> CGFloat in
            return a + w * (b - a)
        }
        
        let color = PixelColor(
            red: average(self.red, color.red, w),
            green: average(self.green, color.green, w),
            blue: average(self.blue, color.blue, w),
            alpha: average(self.alpha, color.alpha, w))
        
        return color
    }
}

public func ovalgradientImage(size: CGSize, colors: [UIColor]) -> UIImage {
    
    let colorCount = colors.count
    if colorCount <= 0 {
        return UIImage()
    } else {
        
        // colors
        let pixelColors = colors.map({ color -> PixelColor in
            
            let cgColor = color.CGColor
            let n = CGColorGetNumberOfComponents(cgColor)
            let coms = CGColorGetComponents(cgColor)
            if n >= 4 {
                let r = coms[0]
                let g = coms[1]
                let b = coms[2]
                let a = coms[3]
                
                let color = PixelColor(red: r, green: g, blue: b, alpha: a)
                return color
                
            } else {
                let x = coms[0]
                let a = coms[1]
                return PixelColor(red: x, green: x, blue: x, alpha: a)
            }
        })
        
        // bitmap data
        let w = Int(size.width)
        let h = Int(size.height)
        let centerX = w / 2
        let centerY = h / 2
        let bitPerComponent = 8
        let componentCountPerPixel = 4
        let bitPerByte = 8
        let bytePerPixel = componentCountPerPixel * bitPerComponent / bitPerByte
        let bytePerRow = bytePerPixel * w
        
        let data = NSMutableData()
        
        for y in 0..<h {
            for x in 0..<w {
                
                let deltX = x - centerX
                let deltY = y - centerY
                let d = atan2(Double(deltY), Double(deltX))
                let angle = deltY >= 0 ? d : d + 2 * M_PI
                let progress = angle / (2 * M_PI)
                
                let t = progress * Double(colorCount - 1)
                let i = Int(t)
                let nexti = (i + 1) >= colorCount ? colorCount - 1 : i + 1
                let w = CGFloat(t - floor(t))
                
                if x < 2 && y < 2 {
                    print((angle / M_PI) * 180, t, i)
                }
                
                let c = pixelColors[i]
                let nc = pixelColors[nexti]
                var middleColor = c.averageWith(nc, w: w).toInt32()
                
                data.appendBytes(&middleColor, length: bytePerPixel)
            }
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let bitmapInfo =  CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        let ctx = CGBitmapContextCreate(data.mutableBytes, w, h, bitPerComponent,
                                        bytePerRow, colorSpace, bitmapInfo.rawValue)
        let img = CGBitmapContextCreateImage(ctx)!
        
        return UIImage(CGImage: img)
    }
}

public func lineGradientImage(size: CGSize, colors: [UIColor]) -> UIImage {
    
    let colorCount = colors.count
    if colorCount <= 0 {
        return UIImage()
    } else {
        
        // colors
        let pixelColors = colors.map({ color -> PixelColor in
            
            let cgColor = color.CGColor
            let n = CGColorGetNumberOfComponents(cgColor)
            let coms = CGColorGetComponents(cgColor)
            if n >= 4 {
                let r = coms[0]
                let g = coms[1]
                let b = coms[2]
                let a = coms[3]
                
                let color = PixelColor(red: r, green: g, blue: b, alpha: a)
                return color
                
            } else {
                let x = coms[0]
                let a = coms[1]
                return PixelColor(red: x, green: x, blue: x, alpha: a)
            }
        })
        
        // bitmap data
        let w = Int(size.width)
        let h = Int(size.height)
        let bitPerComponent = 8
        let componentCountPerPixel = 4
        let bitPerByte = 8
        let bytePerPixel = componentCountPerPixel * bitPerComponent / bitPerByte
        let bytePerRow = bytePerPixel * w
        
        let data = NSMutableData()
        for _ in 0..<h {
            for x in 0..<w {

                let progress = (Double(x) / Double(w))
                let t = progress * Double(colorCount - 1)
                let i = Int(t)
                let nexti = (i + 1) >= colorCount ? colorCount - 1 : i + 1
                let deltW = CGFloat(t - floor(t))
                
                let c = pixelColors[i]
                let nc = pixelColors[nexti]
                var middleColor = c.averageWith(nc, w: deltW).toInt32()
                data.appendBytes(&middleColor, length: bytePerPixel)
            }
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let bitmapInfo =  CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        
        let ctx = CGBitmapContextCreate(data.mutableBytes, w, h, bitPerComponent,
                                        bytePerRow, colorSpace, bitmapInfo.rawValue)
        let img = CGBitmapContextCreateImage(ctx)!
        return UIImage(CGImage: img)
    }
}