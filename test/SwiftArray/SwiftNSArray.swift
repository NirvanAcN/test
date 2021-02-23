//
//  SwiftNSArray.swift
//  test
//
//  Created by 马浩萌 on 2021/1/30.
//

import Foundation

extension NSArray {
    
    /// 随机元素
    @objc
    public var mhm_randomElement: NSArray.Element? {
        return mhm_swiftArrayValue()?.randomElement()
    }
    
    @objc
    public func mhm_map(_ transform: (Element) -> Element) -> [Element]? {
        return mhm_swiftArrayValue()?.map(transform)
    }
    
    private func mhm_swiftArrayValue() -> [NSArray.Element]? {
        return self as? [NSArray.Element]
    }
}
