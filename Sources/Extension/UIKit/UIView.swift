//
//  UIView.swift
//  
//
//  Created by 韦烽传 on 2021/11/27.
//

import Foundation
import UIKit

// MARK: - 视图的视图控制器

public extension UIView {
    
    /// 最后一个视图控制器
    var lastVC: UIViewController? {
        
        var vc: UIViewController?
        
        switch self {
        case let w as UIWindow:
            vc = w.rootViewController
        default:
            vc = window?.rootViewController
        }
        
        while true {
            
            switch vc {
                
            case let nav as UINavigationController:
                
                vc = nav.viewControllers.last
                
            case let tab as UITabBarController:
                
                vc = tab.selectedViewController
                
            default:
                
                if vc?.presentedViewController != nil {
                    
                    vc = vc?.presentedViewController
                }
                else {
                    
                    return vc
                }
            }
        }
    }
}
