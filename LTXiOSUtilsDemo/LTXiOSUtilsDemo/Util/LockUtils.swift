//
//  LockUtils.swift
//  LTXiOSUtilsDemo
//
//  Created by CoderStar on 2022/9/25.
//

import Foundation

/// 自旋锁
public class SpinLock {
    private var locked = 0

    public func lock() {
        while !OSAtomicCompareAndSwapLongBarrier(0, 1, &locked) {}
    }

    public func unlock() {
        OSAtomicCompareAndSwapLongBarrier(1, 0, &locked)
    }
}

/// 递归自旋锁
public class RecursiveSpinLock {
    private var thread: UnsafeMutableRawPointer?
    private var count = 0

    public func lock() {
        if OSAtomicCompareAndSwapPtrBarrier(pthread_self(), pthread_self(), &thread) {
            count += 1
            return
        }
        while !OSAtomicCompareAndSwapPtrBarrier(nil, pthread_self(), &thread) {
            /// usleep 10提高性能
            usleep(10)
        }
    }

    public func unlock() {
        if count > 0 {
            count -= 1
        } else {
            OSAtomicCompareAndSwapPtrBarrier(pthread_self(), nil, &thread)
        }
    }
}
