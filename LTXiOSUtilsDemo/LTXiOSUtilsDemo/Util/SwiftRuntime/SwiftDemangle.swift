//
//  SwiftDemangle.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2022/2/3.
//
import Foundation

@_silgen_name("swift_demangle")
private func stdlibDemangleImpl(
    mangledName: UnsafePointer<CChar>?,
    mangledNameLength: UInt,
    outputBuffer: UnsafeMutablePointer<CChar>?,
    outputBufferSize: UnsafeMutablePointer<UInt>?,
    flags: UInt32
) -> UnsafeMutablePointer<CChar>?

public struct SwiftDemangle {
    /// 对Swift函数名进行demangle
    /// - Parameter mangledName: 函数名
    /// - Returns: demangle后的函数名
    public static func getDemangleName(_ mangledName: String) -> String {
        return mangledName.utf8CString.withUnsafeBufferPointer { mangledNameUTF8CStr in
            let demangledNamePtr = stdlibDemangleImpl(
                mangledName: mangledNameUTF8CStr.baseAddress,
                mangledNameLength: UInt(mangledNameUTF8CStr.count - 1),
                outputBuffer: nil,
                outputBufferSize: nil,
                flags: 0
            )

            if let demangledNamePtr = demangledNamePtr {
                let demangledName = String(cString: demangledNamePtr)
                free(demangledNamePtr)
                return demangledName
            }
            return mangledName
        }
    }
}
