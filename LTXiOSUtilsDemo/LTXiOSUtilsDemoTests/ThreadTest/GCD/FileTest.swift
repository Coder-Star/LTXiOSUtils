//
//  GCDTest.swift
//  LTXiOSUtilsDemoTests
//  
//  Created by 李天星 on 2020/8/26.
//  Copyright © 2020 李天星. All rights reserved.
//

import XCTest
import LTXiOSUtils

@testable import LTXiOSUtils

class FileTest: XCTestCase {

    // 并行队列
    let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)

    // 文件读写锁
    var pthreadRwlock = pthread_rwlock_t()

    /**
     使用栅栏函数使用多读单写
     */
    func readFile() -> String {
        // 这里使用同步任务，阻塞进入的线程，保证即读即得
        var result = ""
        concurrentQueue.sync {
            // 读写文件
            result = ""
        }
        return result
    }

    func writeFile() {
        // 这里使用异步任务，因为存入后不需要及时得到反馈结果
        concurrentQueue.async(flags: [.barrier]) {

        }
    }

    func initRwlock() {
        pthread_rwlock_init(&pthreadRwlock, nil)
    }

    func readFile1() -> String {
        pthread_rwlock_rdlock(&pthreadRwlock)
        defer {
            pthread_rwlock_unlock(&pthreadRwlock)
        }
        // 读文件
        return ""
    }

    func writeFile1() {
        pthread_rwlock_wrlock(&pthreadRwlock)
        defer {
            pthread_rwlock_unlock(&pthreadRwlock)
        }
        // 写文件
    }

    deinit {
        pthread_rwlock_destroy(&pthreadRwlock)
    }
}

