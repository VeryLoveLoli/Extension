//
//  UIApplication.swift
//  Extension
//
//  Created by 韦烽传 on 2026/8/15.
//

import Foundation
import  UIKit

// MARK: - 应用语言

public extension UIApplication {
    
    /**
     语言类型
     */
    enum LanguageType {
        
        /// 绑捆首选
        case bundlePreferred
        /// 本地首选
        case localePreferred
        /// 本地当前
        case localCurrent
        /// 用户默认
        case userDefaults
    }
    
    /**
     语言
     
     - parameter    type:   语言类型
     */
    static func language(_ type: LanguageType) -> String? {
        
        var language: String?
        
        switch type {
        case .bundlePreferred:
            language = Bundle.main.preferredLocalizations.first
        case .localePreferred:
            language = Locale.preferredLanguages.first
        case .localCurrent:
            language = Locale.current.identifier
        case .userDefaults:
            language = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first
        }
        
        return language
    }
    
    /**
     语言布局方向
     
     - parameter    type:   语言类型
     */
    static func languageLayoutDirection(_ type: LanguageType) -> UIUserInterfaceLayoutDirection {
        
        guard let language = language(type)?.lowercased() else { return UIApplication.shared.userInterfaceLayoutDirection }
        
        if language.hasPrefix("ar") {
            /// 阿拉伯
            return .rightToLeft
        }
        else if language.hasPrefix("heb") {
            /// 希伯来
            return .rightToLeft
        }
        else if language.hasPrefix("per") {
            /// 波斯
            return .rightToLeft
        }
        else if language.hasPrefix("urd") {
            /// 乌尔都
            return .rightToLeft
        }
        else if language.hasPrefix("tgk") {
            /// 塔吉克
            return .rightToLeft
        }
        else if language.hasPrefix("pan") {
            /// 旁遮普
            return .rightToLeft
        }
        else if language.hasPrefix("kur") {
            /// 库尔德
            return .rightToLeft
        }
        else {
            
            return .leftToRight
        }
    }
    
    /// 是否右到左布局
    static var isRTL: Bool {
        
        languageLayoutDirection(.userDefaults) == .rightToLeft
    }
}
