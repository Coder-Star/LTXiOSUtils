//
//  LaunchMonitor.swift
//  LTXiOSUtils
//
//  Created by CoderStar on 2021/12/27.
//

import Foundation

extension ProcessInfo {
    /// 调用时间距进程启动时刻间隔时间
    public var uptime: TimeInterval {
        return Date().timeIntervalSince(startTime)
    }

    /// 当前进程启动时间
    public var startTime: Date {
        return processStartTime(for: processIdentifier)
    }

    /// 根据进程id获取进程启动时间
    /// - Parameter pid: 进程id
    /// - Returns: 进程启动时间
    public func processStartTime(for pid: Int32) -> Date {
        var mib = [CTL_KERN, KERN_PROC, KERN_PROC_PID, pid]
        var proc = kinfo_proc()
        var size = MemoryLayout.size(ofValue: proc)
        mib.withUnsafeMutableBufferPointer { p in
            _ = sysctl(p.baseAddress, 4, &proc, &size, nil, 0)
        }

        let time = proc.kp_proc.p_starttime
        let seconds = Double(time.tv_sec) + Double(time.tv_usec) / Double(NSEC_PER_SEC)

        return Date(timeIntervalSince1970: seconds)
    }
}
