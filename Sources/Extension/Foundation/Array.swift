//
//  Array.swift
//  
//
//  Created by 韦烽传 on 2021/11/13.
//

import Foundation

// MARK: - 随机排序

public extension Array {
    
    /**
     随机排序
     */
    mutating func randomSorting() {
        
        for i in 0..<self.count {
            
            let j =  Int(arc4random() % UInt32(self.count))
            
            let item = self[i]
            self[i] = self[j]
            self[j] = item
        }
    }
}
