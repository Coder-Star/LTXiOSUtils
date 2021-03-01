//
//  AdModel.swift
//  LTXiOSUtilsDemo
//  开屏广告实体
//  Created by 李天星 on 2020/2/12.
//  Copyright © 2020 李天星. All rights reserved.
//

//import Foundation
//import ObjectMapper
//import XHLaunchAd
//
//struct AdModel {
//    /// 图片url
//    var imgUrl: String?
//    /// 图片点击url
//    var actionUrl: String?
//    /// 显示时间
//    var duration: Int?
//    /// 完成动画类型
//    var animationType: ShowFinishAnimate?
//    /// 跳过按钮动画类型
//    var skipBtnType: SkipType?
//}
//
//extension AdModel: Mappable {
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//        imgUrl <- map["imgUrl"]
//        actionUrl <- map["actionUrl"]
//        duration <- map["duration"]
//        animationType <- (map["animationType"], EnumTransform())
//        skipBtnType <- (map["skipBtnType"], EnumTransform())
//    }
//}
