//
//  String.swift
//  
//
//  Created by 韦烽传 on 2021/11/13.
//

import Foundation
import Print

// MARK: - 区间字符串

public extension String {
    
    /**
     获取索引字符串（用于`String.count`的`0..<count`）
     */
    subscript(_ i: Int) -> String {
        
        return self[i ..< i + 1]
    }
    
    /**
     获取索引区间字符串（用于`String.count`的`0..<count`）
     */
    subscript(_ range: Range<Int>) -> String {
        
        if count == 0 || range.lowerBound >= count {
            
            return ""
        }
        
        let l = min(range.upperBound, count) - range.lowerBound
        
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: l)
        
        return String(self[start..<end])
    }
    
    /**
     获取索引区间字符串
     
     注意：表情符号长度占2个长度
     例如：
     ```
     let string = "😄"
     let v1 = string[NSRange(location: 0, length: 1)]
     let v2 = string[NSRange(location: 0, length: 2)]
     print(v1)
     print(v2)
     ```
     输出：
     
     😄
     `v2`才能正确输出
     */
    subscript(_ range: NSRange) -> String {
        
        if let rangeIndex = self.range(range) {
            
            return String(self[rangeIndex])
        }
        
        return ""
    }
}

// MARK: - 创建文件夹

public extension String {
    
    /**
     文件夹路径创建
     */
    func createDirectory() -> Bool {
                
        var path = self
        
        if let last = path.last, last != "/" {
            
            path += "/"
        }
        
        guard !FileManager.default.fileExists(atPath: path) else { return true }
        
        do {
            
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            
        } catch {
            
            Print.error(error)
            
            return false
        }
        
        return true
    }
    
    /**
     从文件路径创建文件夹
     */
    func createDirectoryFromFilePath() -> Bool {
                
        if FileManager.default.fileExists(atPath: self) {
            
            return true
        }
        
        var pathArray = self.components(separatedBy: "/")
        
        if pathArray.count >= 2 {
            
            pathArray.removeLast()
            
            var directoryPath = pathArray.joined(separator: "/")
            
            if let last = directoryPath.last, last != "/" {
                
                directoryPath += "/"
            }
            
            if !FileManager.default.fileExists(atPath: directoryPath)  {
                
                do {
                    
                    try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
                    
                } catch {
                    
                    Print.error(error)
                    
                    return false
                }
            }
        }
        
        return true
    }
}

// MARK: - 字符串URL编码

public extension String {
    
    /// URL编码集
    static let URLEncodeSet = CharacterSet.init(charactersIn: " !*'();:@&=+$,/?%#[]{}\"").inverted
    
    /**
     URL编码
     */
    func urlEncode() -> String {
        
        return addingPercentEncoding(withAllowedCharacters: String.URLEncodeSet) ?? ""
    }
}

// MARK: - 文字集合

public extension String {
    
    /**
     中文集合
     */
    static func chineseSet() -> [String] {
        
        return unicodeSet(0x4e00, end: 0x9fa5) + unicodeSet(0x3400, end: 0x4db5)
    }

    /**
     日文集合
     */
    static func japaneseSet() -> [String] {
        
        return unicodeSet(0x0800, end: 0x4e00)
    }

    /**
     韩文集合
     */
    static func koreanSet() -> [String] {
        
        return unicodeSet(0x3130, end: 0x318f) + unicodeSet(0xac00, end: 0xd7a3)
    }

    /**
     `unicode`编码集合
     
     - parameter    start:  开始编码
     - parameter    end:    结束编码
     */
    static func unicodeSet(_ start: UInt16, end: UInt16) -> [String] {
        
        var array: [String] = []
        
        for item in start...end {
            
            var bytes: [UInt8] = [0,0]
            
            bytes[0] = UInt8((item<<0)>>8)
            bytes[1] = UInt8((item<<8)>>8)
            
            let data = Data.init(bytes: bytes, count: bytes.count)
            
            if let string = String.init(data: data, encoding: .unicode) {
                
                array.append(string)
            }
            else {
                
                Print.error("\(item): 转换失败")
            }
        }
        
        return array
    }
}

// MARK: - 正在替换

public extension String {
    
    /**
     正则替换
     
     - parameter    pattern:            表达式
     - parameter    options:            选项
     - parameter    optionsMatches:     匹配选项
     - parameter    with:               新内容
     */
    func regular(_ pattern: String, options: NSRegularExpression.Options = [], optionsMatches: NSRegularExpression.MatchingOptions = [], with: String) -> String {
        
        do {
            
            let regular = try NSRegularExpression(pattern: pattern, options: options)
            
            return regular.stringByReplacingMatches(in: self, options: optionsMatches, range: NSRange(location: 0, length: self.count), withTemplate: with)
            
        } catch {
            
            Print.error(error.localizedDescription)
            
            return ""
        }
    }
}

// MARK - 范围转换

extension String {
     
    /**
     `Range<String.Index>` 转 `NSRange`
     
     - parameter    range:      索引范围
     */
    func range(_ range: Range<String.Index>) -> NSRange {
        
        let from = range.lowerBound.samePosition(in: utf16)!
        let to = range.upperBound.samePosition(in: utf16)!
        
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                       length: utf16.distance(from: from, to: to))
    }
     
    /**
     `NSRange` 转 `Range<String.Index>`
     
     - parameter    range:      范围
     */
    func range(_ range: NSRange) -> Range<String.Index>? {
        
        if let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex),
           let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex),
           let from = String.Index(from16, within: self),
           let to = String.Index(to16, within: self) {
            
            return from ..< to
        }
        
        return nil
    }
}

// MARK: - 正则搜索

extension String {
    
    /**
     匹配
     */
    struct Match {
        
        /// 类型
        var type: NSTextCheckingResult.CheckingType
        /// 范围
        var range: NSRange
        /// 内容
        var content: String
        
    }
    
    /**
     正则搜索
     
     - parameter    pattern:            表达式
     - parameter    options:            选项
     - parameter    optionsMatches:     匹配选项
     
     - returns  匹配列表
     */
    func regular(_ pattern: String, options: NSRegularExpression.Options = [], optionsMatches: NSRegularExpression.MatchingOptions = []) -> [String.Match] {
        
        do {
            
            let regular = try NSRegularExpression(pattern: pattern, options: options)
            
            let list = regular.matches(in: self, options: [], range: NSRange(location: 0, length: count))
            
            var matches: [String.Match] = []
            
            for item in list {
                
                let match = String.Match(type: item.resultType, range: item.range, content: self[item.range])
                
                matches.append(match)
            }
            
            return matches
            
        } catch {
            
            Print.error(error.localizedDescription)
            
            return []
        }
    }
}
