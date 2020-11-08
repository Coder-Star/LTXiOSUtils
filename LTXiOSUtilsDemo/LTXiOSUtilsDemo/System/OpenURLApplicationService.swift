//
//  OpenURLApplicationService.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/11/2.
//  Copyright © 2020 李天星. All rights reserved.
//

final class OpenURLApplicationService: NSObject, ApplicationService {

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        Log.d(url)
        Log.d(options)
        return true
    }

}
