//
//  LaunchImageUtils.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2022/9/27.
//

import Foundation

struct LaunchImageUtils {
    public static func clearLaunchScreenCache() {
        let version = 1
        let key = "UpdateLaunchScreen_\(version)"
        let isUpdated = UserDefaults.standard.bool(forKey: key)
        if isUpdated { return }
        if let path = launchImageCacheDirectory() {
            do {
                try FileManager.default.removeItem(atPath: path)
                UserDefaults.standard.set(true, forKey: key)
            } catch {
                print("Failed to delete launch screen cache: \(error)")
            }
        }
    }

    public static func launchImageCacheDirectory() -> String? {
        guard let bundleId = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") else { return nil }
        let fileManager = FileManager.default
        // iOS 13
        if #available(iOS 13.0, *) {
            let libraryDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first
            let libraryPath = libraryDirectory! as NSString
            let snaPath = libraryPath.appending("/SplashBoard/Snapshots/\(bundleId) - {DEFAULT GROUP}")
            if fileManager.fileExists(atPath: snaPath) {
                return snaPath
            }

        } else {
            let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
            let cachePath = cacheDirectory! as NSString
            let snap = cachePath.appendingPathComponent("Snapshots") as NSString
            let snapPath = snap.appendingPathComponent(bundleId as! String)
            if fileManager.fileExists(atPath: snapPath) {
                return snapPath
            }
        }
        return nil
    }
}
