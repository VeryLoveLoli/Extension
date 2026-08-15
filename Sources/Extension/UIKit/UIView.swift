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

// MARK: - 视图布局方向

public extension UIView {
    
    /**
     用户界面布局方向
     */
    func userInterfaceLayoutDirection() -> UIUserInterfaceLayoutDirection {
        
        switch semanticContentAttribute {
        case .forceLeftToRight:
            return .leftToRight
        case .forceRightToLeft:
            return .rightToLeft
        default:
            /// 应用内切换语言后，使用`UserDefaults.standard.set(["en"], forKey: "AppleLanguages")`切换语言
            /// `Bundle.main.preferredLocalizations`没改变
            /// `Locale.current.identifier`没改变
            /// `UIApplication.shared.userInterfaceLayoutDirection`也没改变
            /// 以上重启应用才改变
            /// `Locale.preferredLanguages`改变了
            /// `UserDefaults.standard.stringArray(forKey: "AppleLanguages")`改变了
            return UIApplication.shared.userInterfaceLayoutDirection
        }
    }
}
