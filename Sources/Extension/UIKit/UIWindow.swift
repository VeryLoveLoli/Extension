//
//  UIWindow.swift
//  
//
//  Created by 韦烽传 on 2021/11/27.
//

import Foundation
import UIKit

// MARK: - 窗口

public extension UIWindow {
    
    /// 关键窗口
    static var keyWindow: UIWindow? {
        
        if #available(iOS 15, *) {
            
            for scene in UIApplication.shared.connectedScenes {
                
                if let windowScene = scene as? UIWindowScene {
                    
                    for item in windowScene.windows {
                        
                        if item.isKeyWindow {
                            
                            return item
                        }
                    }
                }
            }
        }
        else if #available(iOS 13, *) {
            
            for item in UIApplication.shared.windows {
                
                if item.isKeyWindow {
                    
                    return item
                }
            }
        }
        else {
            
            return UIApplication.shared.keyWindow
        }
        
        return nil
    }
}
