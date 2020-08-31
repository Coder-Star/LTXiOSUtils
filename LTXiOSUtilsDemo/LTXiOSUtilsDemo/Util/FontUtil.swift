//
//  FontUtil.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/8/29.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

/// 字体工具类
public class FontUtil {
    /// 输出所有字体
    public static func printAllFont() {
        for family in UIFont.familyNames {
            Log.d("字体---\(family)")
            for names in UIFont.fontNames(forFamilyName: family) {
                Log.d("\(names)")
            }
        }
    }
}
