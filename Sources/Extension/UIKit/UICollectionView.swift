//
//  UICollectionView.swift
//  
//
//  Created by 韦烽传 on 2021/11/13.
//

import Foundation
import UIKit

// MARK: - 注册方法

public extension UICollectionView {
    
    /**
     注册Cell
     
     - parameter    name:           XIB名称
     - parameter    bundle:         Bundle包
     - parameter    identifier:     identifier
     */
    func registerCell(_ name: String, bundle: Bundle? = Extension.bundle, identifier: String = "Cell") {
        
        register(UINib.init(nibName: name, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }
    
    /**
     注册Header
     
     - parameter    name:           XIB名称
     - parameter    bundle:         Bundle包
     - parameter    identifier:     identifier
     */
    func registerHeader(_ name: String, bundle: Bundle? = Extension.bundle, identifier: String = "Header") {
        
        register(UINib.init(nibName: name, bundle: bundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }
    
    /**
     注册Footer
     
     - parameter    name:           XIB名称
     - parameter    bundle:         Bundle包
     - parameter    identifier:     identifier
     */
    func registerFooter(_ name: String, bundle: Bundle? = Extension.bundle, identifier: String = "Footer") {
        
        register(UINib.init(nibName: name, bundle: bundle), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
    }
}
