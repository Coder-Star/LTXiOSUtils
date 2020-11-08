//
//  PerformanceMonitorUtil.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/10/27.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation

struct PerformanceMonitorUtil {

    private var displayLink: CADisplayLink?
    private var accumulatedInformationIsEnough = false

//    mutating func configureDisplayLink() {
//        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkAction(displayLink:)))
//        displayLink?.isPaused = true
//        displayLink?.add(to: .current, forMode: .common)
//    }
//
//
//    @objc func displayLinkAction(displayLink: CADisplayLink) {
//        takePerformanceEvidence()
//    }
//
//    func takePerformanceEvidence() {
//        if accumulatedInformationIsEnough {
//            let cpuUsage = self.cpuUsage()
//            let fps = self.linkedFramesList.count
//            let memoryUsage = self.memoryUsage()
//            self.report(cpuUsage: cpuUsage, fps: fps, memoryUsage: memoryUsage)
//        } else if let start = self.startTimestamp, Date().timeIntervalSince1970 - start >= Constants.accumulationTimeInSeconds {
//            self.accumulatedInformationIsEnough = true
//        }
//    }
}

extension PerformanceMonitorUtil {

    /// 获取CPU使用率
    /// - Returns: CPU使用率
    func cpuUsage() -> Double {
        var totalUsageOfCPU: Double = 0.0
        var threadsList = UnsafeMutablePointer(mutating: [thread_act_t]())
        var threadsCount = mach_msg_type_number_t(0)
        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }

        if threadsResult == KERN_SUCCESS {
            for index in 0..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }

                guard infoResult == KERN_SUCCESS else {
                    break
                }

                let threadBasicInfo = threadInfo as thread_basic_info
                if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                    totalUsageOfCPU = (totalUsageOfCPU + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
                }
            }
        }

        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
        return totalUsageOfCPU
    }

    /// 内存使用量及总量
    func memoryUsage() -> (used: UInt64, total: UInt64) {
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }

        var used: UInt64 = 0
        if result == KERN_SUCCESS {
            used = UInt64(taskInfo.phys_footprint)
        }

        let total = ProcessInfo.processInfo.physicalMemory
        return (used, total)
    }
}
