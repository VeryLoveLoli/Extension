//
//  UIImage.swift
//  
//
//  Created by 韦烽传 on 2021/11/13.
//

import Foundation
import UIKit
import Print

// MARK: - 图片

public extension UIImage {
    
    /**
     获取颜色图片
     
     - parameter    color:      颜色
     
     - returns: UIImage
     */
    class func color(_ color: UIColor) -> UIImage {
        
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /**
     获取视图图片
     
     - parameter    view:       视图
     
     - returns: UIImage
     */
    class func view(_ view: UIView) -> UIImage {
        
        return layer(view.layer)
    }
    
    /**
     获取图层图片
     
     - parameter    layer:      图层
     
     - returns: UIImage
     */
    class func layer(_ layer: CALayer) -> UIImage {
        
        let size = layer.bounds.size
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /**
     获取透明度图片
     
     - parameter    value:      透明值
     
     - returns: UIImage
     */
    func alpha(_ value: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -size.height)
        context.setBlendMode(CGBlendMode.multiply)
        context.setAlpha(value)
        context.draw(cgImage!, in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /**
     重新绘制图片
     
     - parameter    value:      图片大小比率
     
     - returns: 图片
     */
    func redraw(_ value: CGFloat) -> UIImage {
        
        return redraw(CGSize.init(width: size.width * value, height: size.height * value))
    }
    
    /**
     重新绘制图片
     
     - parameter    size:       图片大小
     
     - returns: UIImage
     */
    func redraw(_ size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /**
     裁剪图片
     
     - parameter    rect:       裁剪区域
     
     - returns: UIImage
     */
    func clip(_ rect: CGRect) -> UIImage {
        
        let scale = UIScreen.main.scale
        
        let scaleRect = CGRect.init(x: rect.origin.x * scale,
                                    y: rect.origin.y * scale,
                                    width: rect.size.width * scale,
                                    height: rect.size.height * scale)
        
        
        let image = UIImage.init(cgImage: cgImage!.cropping(to: scaleRect)!, scale: UIScreen.main.scale, orientation: .up)
        
        return image
    }
    
    /**
     路径图片
     
     - parameter    path:       路径
     - parameter    size:       图片大小
     */
    func path(_ path: CGPath, size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()!
        context.addPath(path)
        context.clip()
        
        draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        
        context.drawPath(using: .fillStroke)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /**
     圆角图片
     
     - parameter    value:      圆角大小
     - parameter    size:       图片大小
     */
    func cornerRadius(_ value: CGFloat, size: CGSize) -> UIImage {
        
        let bezierPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: value)
        
        return path(bezierPath.cgPath, size: size)
    }
}

// MARK: - 颜色值

public extension UIImage {
    
    /**
     获取图片中的像素颜色
     
     - parameter    point:      图片中的位置
     
     - returns: UIColor
     */
    func pixelColor(_ point: CGPoint) -> UIColor {
        
        let (r, g, b, a) = pixelColorValue(point)
        
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
    }
    
    
    /**
     获取图片中的像素颜色值
     
     - parameter    point:      图片中的位置
     
     - returns: (R,G,B,A)
     */
    func pixelColorValue(_ point: CGPoint) -> (red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        
        let pixelData = self.cgImage!.dataProvider!.data
        
        let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(point.y)) + Int(point.x)) * 4
        
        return (data[pixelInfo], data[pixelInfo+1], data[pixelInfo+2], data[pixelInfo+3])
    }
}

// MARK: - 存储

extension UIImage {
    
    /**
     保存图片
     
     - parameter    filePath:   文件路径
     */
    func save(_ filePath: String) -> Bool {
        
        var jp = pngData()
        
        if jp == nil {
            
            jp = jpegData(compressionQuality: 1)
        }
        
        if let data = jp {
            
            do {
                
                try data.write(to: URL.init(fileURLWithPath: filePath))
                
                return true
                
            } catch {
                
                Print.error(error)
                
                return false
            }
        }
        else {
            
            return false
        }
    }
    
    /**
     获取磁盘图片
     
     - parameter    filePath:   文件路径
     */
    static func disk(_ filePath: String) -> UIImage? {
        
        do {
            
            let data = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
            
            return UIImage.init(data: data)
            
        } catch {
            
            return nil
        }
    }
}

// MARK: - 二维码

public extension UIImage {
    
    /**
     检测
     
     - parameter    type:   类型
     */
    func detector(_ type: String) -> [CIFeature]? {
        
        /// 获取CI图像
        guard let ci = ciImage else { return nil }
        
        /// 检测器
        guard let detector = CIDetector(ofType: type, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) else { return nil }
        
        /// 返回检测特征
        return detector.features(in: ci)
    }
    
    /**
     检测二维码
     */
    func detectorQRcode() -> [String]? {
        
        /// 特征列表
        guard let features = detector(CIDetectorTypeQRCode) else { return nil }
        
        var urls: [String] = []
        
        for item in features {
            
            if let qr = item as? CIQRCodeFeature {
                
                /// 二维码特征消息
                if let url = qr.messageString {
                    
                    urls.append(url)
                }
            }
        }
        
        return urls
    }
    
    /**
     生成二维码
     
     - parameter    content:        内容
     - parameter    size:           大小
     - parameter    quality:        质量
     - parameter    background:     背景颜色
     - parameter    color:          二维码颜色
     */
    static func generateQRcode(_ content: String, size: CGSize, quality: CGInterpolationQuality = .none, background: UIColor = .white, color: UIColor = .black) -> UIImage? {
        
        /// 过滤器
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        /// 设置输入消息
        filter.setValue(content.data(using: .utf8), forKey: "inputMessage")
        /// 导出二维码图像
        guard let outputImage = filter.outputImage else { return nil }
        
        /// 颜色过滤器
        guard let filter_color = CIFilter(name: "CIFalseColor") else { return nil }
        /// 设置输入图像
        filter_color.setValue(outputImage, forKey: "inputImage")
        /// 设置图像颜色
        filter_color.setValue(CIColor(color: color), forKey: "inputColor0")
        /// 设置图像背景颜色
        filter_color.setValue(CIColor(color: background), forKey: "inputColor1")
        /// 转换颜色的二维码图像
        guard let ciImage = filter_color.outputImage else { return nil }
        
        /// CG二维码图像
        guard let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) else { return UIImage(ciImage: ciImage) }
        
        /// 开始图像上下文
        UIGraphicsBeginImageContext(size)
        
        /// 上下文
        guard let context = UIGraphicsGetCurrentContext() else { UIGraphicsEndImageContext(); return UIImage(ciImage: ciImage) }
        /// 插入质量
        context.interpolationQuality = quality
        /// 上下反转
        context.scaleBy(x: 1, y: -1)
        /// 绘制图片
        context.draw(cgImage, in: context.boundingBoxOfClipPath)
        
        /// 获取上下文图片
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { UIGraphicsEndImageContext(); return UIImage(ciImage: ciImage) }
        
        /// 结束图像上下文
        UIGraphicsEndImageContext()
        
        return image
    }
}
