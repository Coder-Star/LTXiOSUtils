//
//  CoreDataUtils.swift
//  LTXiOSUtilsDemo
//
//  Created by 李天星 on 2020/9/26.
//  Copyright © 2020 李天星. All rights reserved.
//

import Foundation
import CoreData

/// CoreData数据管理
public final class CoreDataManager {

    private init() {}

    static let shared = CoreDataManager()

    // NSPersistentContainer是一个容器,封装了应用程序中的CoreData Stack
    // NSPersistentContainer简化了创建NSManagedObjectModel，NSPersistentStoreCoordinator,NSManagedObjectContext
    lazy var persistentContainer: NSPersistentContainer = {
        // data 为.xcdatamodeld文件名字
        let container = NSPersistentContainer(name: "data")

        // 设置数据存储地址，默认地址位于Library/Application Support
        let dataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("CoderStar").appendingPathExtension("sqlite")
        let description = NSPersistentStoreDescription(url: dataURL!)

        // 允许识别新版本
        description.shouldAddStoreAsynchronously = true
        // Core Data会试着把之前低版本的出现不兼容的持久化存储区迁移到新的模型中
        description.shouldMigrateStoreAutomatically = true
        // Core Data会根据自己认为最合理的方式去尝试MappingModel，从源模型实体的某个属性，映射到目标模型实体的某个属性
        description.shouldInferMappingModelAutomatically = true
        Log.d(container.persistentStoreDescriptions)
        container.persistentStoreDescriptions = [description]

        // 加载存储器，此方法必须要调用，否则无法存储数据
        container.loadPersistentStores { storeDescription, error in
            if error != nil {
                Log.d(error)
            }
            // 存储地址
            Log.d(storeDescription.url)
            // 存储类型
            Log.d(storeDescription.type)
        }

        return container
    }()

    // 返回一个基于多线程的管理对象上下文，我们无需关心多线程的内部实现以及线程安全，由NSPersistentContainer新创建一个
    // 返回的上下文做一些数据的处理都是在子线程中完成的，可以用于处理对数据库进行大量数据操作的场景
    //    container.newBackgroundContext()

    // 使用存储调度器快速在多线程中操作数据库，效率非常高(比主线程操作块50倍)
    //    container.performBackgroundTask { context in
    //
    //    }

}

extension CoreDataManager {
    func saveContext() -> (success: Bool, error: Error?) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                return (success: true, error: nil)
            } catch {
                return (success: false, error: error)
            }
        }
        return (success: true, error: nil)
    }
}
