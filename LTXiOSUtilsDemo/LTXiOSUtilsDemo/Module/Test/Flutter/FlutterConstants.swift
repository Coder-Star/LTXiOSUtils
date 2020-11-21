//
//  FlutterConstants.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/11/19.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

struct FlutterConstants {

    static let bundleID = "com.star.LTXiOSUtils"

    enum ChannelType: String {
        case method
        case event
        case basicMessage
    }

    static func getChannelName(type: ChannelType, channelName: String?) -> String {
        let tempChannel = bundleID + "/" + type.rawValue + "/app"
        return channelName != nil ? tempChannel + "/" + channelName! : tempChannel
    }

}
