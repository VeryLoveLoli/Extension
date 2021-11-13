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
     获取索引字符串
     */
    subscript(_ i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    /**
     获取索引区间字符串
     */
    subscript(_ range: Range<Int>) -> String {
        
        if count == 0 {
            
            return ""
        }
        
        let i = min(range.lowerBound, self.count)
        let l = min(range.upperBound, self.count) - range.lowerBound
        
        let start = index(startIndex, offsetBy: i)
        let end = index(start, offsetBy: l)
        
        return String(self[start..<end])
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
